import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final String vendorName;
  final String image;
  final double price;
  double newPrice=0;
  final String category;
  final String description; 
  final List<String> comments;
  List<double> ratings = [];
  final double overallRating;
  late final List<String> sizes;
  late final Map<String, Map<String, int>> unitsByColorAndSize; 

  Product({
    required this.name,
    required this.vendorName,
    required this.image,
    required this.price,
    required this.comments,
    required this.category,
    required this.description,
    required this.overallRating,
    required this.sizes,
    required this.unitsByColorAndSize,
  });
    String getImage() {
    return image;
  }
    void setAvailableOptions(List<String> sizes, Map<String, Map<String, int>> unitsByColorAndSize) {
    this.sizes = sizes;
    this.unitsByColorAndSize = unitsByColorAndSize;
  }
   List<String> getAvailableSizes() {
    return sizes;
  }
    List<String> getAvailableColorsForSize(String size) {
    return unitsByColorAndSize[size]?.keys.toList() ?? [];
  }
   int getAvailableUnitsForColorAndSize(String color, String size) {
    return unitsByColorAndSize[size]?[color] ?? 0; 
  }
    List<String> getAllAvailableColors() {
    Set<String> allColors = {};
    for (var size in sizes) {
      allColors.addAll(unitsByColorAndSize[size]?.keys ?? []);
    }
    return allColors.toList();
  }

    double calculateNewPrice(double discountPercentage) {
    double discountAmount = price * (discountPercentage / 100);
    return price - discountAmount;
  }
    void addRating(double rating) {
    ratings.add(rating);
  }
    void addComment(String comment) {
    comments.add(comment);
  }
  double calculateOverallRating() {
    if (ratings.isEmpty) {
      return 0.0; 
    }
    double sum = ratings.reduce((value, element) => value + element);
    return sum / ratings.length;
  }
   String getDescription() {
    return description;
  }
  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Product(
      name: data['name'],
      vendorName: data['vendorName'],
      image: data['image'],
      price: data['price'],
      category: data['category'],
      comments: [],
      overallRating: 0.0, description: '', sizes: [], unitsByColorAndSize: {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'vendorName': vendorName,
      'image': image,
      'price': price,
      'category': category,
    };
  }
}

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'products';

  Future<void> createProduct(Product product) async {
    try {//await productRepository.createProduct(newProduct);
      await _firestore.collection(_collectionPath).add(product.toFirestore());
    } catch (error) {
      throw Exception('Failed to create product: $error');
    }
  }
 
Future<void> applyDiscountAndSetNewPrice(String productId, double discountPercentage) async {
    try {
      final doc = await _firestore.collection(_collectionPath).doc(productId).get();
      if (doc.exists) {
        Product product = Product.fromFirestore(doc);
        double newPrice = product.calculateNewPrice(discountPercentage);
        await _firestore.collection(_collectionPath).doc(productId).update({'newPrice': newPrice});
      }
    } catch (error) {
      throw Exception('Failed to apply discount and set new price: $error');
    }
  }
  Future<List<Product>> getAllProducts() async {
    try {
      final querySnapshot = await _firestore.collection(_collectionPath).get();
      return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (error) {
      throw Exception('Failed to get all products: $error');
    }
  }

  Future<Product?> getProduct(String productId) async {
    try {
      final doc = await _firestore.collection(_collectionPath).doc(productId).get();
      if (doc.exists) {
        return Product.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (error) {
      throw Exception('Failed to get product: $error');
    }
  }
     Future<void> rateProduct(String productId, double rating) async {
    try { // pass rating from user and pass product id from firebase (current screen)
    //await productRepository.rateProduct(productId, userRating);(how to call it with button)
      final doc = await _firestore.collection(_collectionPath).doc(productId).get();
      if (doc.exists) {
        Product product = Product.fromFirestore(doc);
        product.addRating(rating);
        await _firestore.collection(_collectionPath).doc(productId).update({'ratings': product.ratings});
      }
    } catch (error) {
      throw Exception('Failed to rate product: $error');
    }
  }
  Future<void> addCommentToProduct(String productId, String comment) async {
    try {// pass comment from user and pass product id from firebase (current screen)
    //await productRepository.addCommentToProduct(productId, comment);(how to call it with button)
      final doc = await _firestore.collection(_collectionPath).doc(productId).get();
      if (doc.exists) {
        await _firestore.collection(_collectionPath).doc(productId).update({
          'comments': FieldValue.arrayUnion([comment])
        });
      }
    } catch (error) {
      throw Exception('Failed to add comment to product: $error');
    }
  }
    Future<String?> getProductDescription(String productId) async {
    try {
      final doc = await _firestore.collection(_collectionPath).doc(productId).get();
      if (doc.exists) {
        return Product.fromFirestore(doc).getDescription();
      } else {
        return null;
      }
    } catch (error) {
      throw Exception('Failed to get product description: $error');
    }
  }
    Future<String?> getProductImage(String productId) async {
    try {
      final doc = await _firestore.collection(_collectionPath).doc(productId).get();
      if (doc.exists) {
        return Product.fromFirestore(doc).getImage();
      } else {
        return null;
      }
    } catch (error) {
      throw Exception('Failed to get product image: $error');
    }
  }
}
