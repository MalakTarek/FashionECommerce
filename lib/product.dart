import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_ecommerce/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Product {
  final String name;
  final String vendorName;
  final String image;
  final double price;
  final String category;
  final List<String> comments;
  final List<double> ratings;
  double overallRating;

  Product({
    required this.name,
    required this.vendorName,
    required this.image,
    required this.price,
    required this.comments,
    required this.category,
    required this.ratings,
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
      ratings: List<double>.from(data['ratings'] ?? []),
      overallRating: data['overallRating'] ?? 0.0, comments: [],
    );
  }
  void updateOverallRating() {
    if (ratings.isEmpty) {
      overallRating = 0.0;
    } else {
      double sum = ratings.reduce((value, element) => value + element);
      overallRating = sum / ratings.length;
    }
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

  /*Future<void> addProductRating(String productId, double rating) async {
    try {

      if (currentUser != null) {
        // Check if the user has the role "shopper"
        // Note: You may need to adjust this based on how user roles are stored in your database
        if (currentUser.role == 'shopper') {
          final productRef = _firestore.collection(_collectionPath).doc(productId);
          final productDoc = await productRef.get();
          if (productDoc.exists) {
            final product = Product.fromFirestore(productDoc);
            product.ratings.add(rating);
            product.updateOverallRating();
            await productRef.update(product.toFirestore());
          } else {
            throw Exception('Product not found');
          }
        } else {
          throw Exception('User does not have the required role to add a rating');
        }
      } else {
        throw Exception('User not authenticated');
      }
    } catch (error) {
      throw Exception('Failed to add rating to product: $error');
    }
  }

   */

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
