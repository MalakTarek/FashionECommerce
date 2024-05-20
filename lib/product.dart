import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_ecommerce/users.dart' as users;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'category.dart';
class Product {
  final String name;
  final String vendorName;
  final String image;
  final double price;
  double newPrice = 0;
  final Category category;
  final String description;
  final List<String> comments;
  List<double> ratings = [];
  final double overallRating;
  late final List<String> sizes;
  late final Map<String, Map<String, int>> unitsByColorAndSize;

  Product( {
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
      //id: snapshot.id,
      name: data['name'],
      vendorName: data['vendorName'],
      image: data['image'],
      price: data['price'],
      category: CategoryExtension.fromString(data['category']),
      comments: [],
      overallRating: 0.0,
      description: '',
      sizes: [],
      unitsByColorAndSize: {}, 
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
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final String _collectionPath = 'products';

Future<void> createProduct(Product product) async {
    try {
      // Get the current user from FirebaseAuth
      users.User? user = FirebaseAuth.instance.currentUser as users.User?;

      // Check if the user is logged in
      if (user != null) {
        // Use the user's display name as the vendor name
        String vendorName = user.name;

        // Update the product with the vendor name
        Product updatedProduct = Product(
          name: product.name,
          vendorName: vendorName,
          image: product.image,
          price: product.price,
          category: product.category, comments: [], description: '', overallRating: 0, sizes: [], unitsByColorAndSize: {},
        );

        // Save the updated product to Firestore
        await _firestore.collection(_collectionPath).add(updatedProduct.toFirestore());
      } else {
        // If the user is not logged in, throw an error 
        throw Exception('User is not logged in.');
      }
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

        final shoppersQuerySnapshot = await _firestore.collection('users')
            .where('role', isEqualTo: 'shopper')
            .get();
        List<String> fcmTokens = [];
        for (var doc in shoppersQuerySnapshot.docs) {
          String? token = doc.data()['fcmToken'];
          if (token != null) {
            fcmTokens.add(token);
          }
        }
        for (String token in fcmTokens) {
          await _sendPushNotification(
            token,
            'Discount Alert!',
            'The product "${product.name}" is now available at a $discountPercentage% discount. New Price: \$${newPrice.toStringAsFixed(2)}'
          );
        }
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

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection(_collectionPath).doc(productId).delete();
    } catch (error) {
      throw Exception('Failed to delete product: $error');
    }
  }

  Future<void> editProductAttributes(String productId, Map<String, dynamic> updatedAttributes) async {
    try {
      await _firestore.collection(_collectionPath).doc(productId).update(updatedAttributes);
    } catch (error) {
      throw Exception('Failed to edit product attributes: $error');
    }
  }

  Future<void> rateProduct(String productId, double rating) async {
    try {
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
    try {
      final doc = await _firestore.collection(_collectionPath).doc(productId).get();
      if (doc.exists) {
        await _firestore.collection(_collectionPath).doc(productId).update({
          'comments': FieldValue.arrayUnion([comment])
        });
        final product = Product.fromFirestore(doc);

        // Fetch vendor's FCM token
        final vendorDoc = await _firestore.collection('users').doc(product.vendorName).get();
        final vendorToken = vendorDoc.data()?['fcmToken'];

        if (vendorToken != null) {
          await _sendPushNotification(
            vendorToken,
            'New Comment on Your Product',
            'A new comment has been added to your product "${product.name}": $comment'
          );
        }
      }
    } catch (error) {
      throw Exception('Failed to add comment to product: $error');
    }
  }
   Future<List<Product>> getVendorProducts(String vendorName) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('vendorName', isEqualTo: vendorName)
          .get();
      return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (error) {
      throw Exception('Failed to get vendor products: $error');
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
  Future<List<Product>> getProductsByCategory(Category category) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('category', isEqualTo: category.name) // Filter by category name
          .get();

      return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (error) {
      throw Exception('Failed to get products by category: $error');
    }
  }
    Future<List<Product>> searchProductsByName(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('name', isGreaterThanOrEqualTo: query) // Filter by name
          .where('name', isLessThan: query + 'z') // Ensures case-insensitive search
          .get();

      return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (error) {
      throw Exception('Failed to search products by name: $error');
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

  Future<void> _sendPushNotification(String token, String title, String body) async {
    try {
      await _messaging.sendMessage(
        to: token,
        data: {
          'title': title,
          'body': body,
        }
      );
    } catch (error) {
      throw Exception('Failed to send push notification: $error');
    }
  }
}