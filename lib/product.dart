import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final String vendorName;
  final String image;
  final double price;
  final String category;
  final List<String> comments;
  final double overallRating;

  Product({
    required this.name,
    required this.vendorName,
    required this.image,
    required this.price,
    required this.category,
    required this.comments,
    required this.overallRating,
  });

  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Product(
      name: data['name'],
      vendorName: data['vendorName'],
      image: data['image'],
      price: data['price'],
      category: data['category'],
      comments: [],
      overallRating: 0.0,
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
    try {
      await _firestore.collection(_collectionPath).add(product.toFirestore());
    } catch (error) {
      throw Exception('Failed to create product: $error');
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
}
