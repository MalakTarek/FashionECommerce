import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_ecommerce/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Product {
  final String name;
  final String vendorName;
  final String imageUrl;
  final double price;
  final String category;
<<<<<<< Updated upstream
=======
  final String description;
>>>>>>> Stashed changes
  final List<String> comments;
  final List<double> ratings;
  double overallRating;

  Product({
    required this.name,
    required this.vendorName,
    required this.imageUrl,
    required this.price,
    required this.comments,
    required this.category,
    required this.ratings,
    required this.overallRating,
    required List ratings,
  });
<<<<<<< Updated upstream

=======
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
>>>>>>> Stashed changes
  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Product(
      name: data['name'],
      vendorName: data['vendorName'],
      imageUrl: data['image'],
      price: data['price'],
      category: data['category'],
<<<<<<< Updated upstream
      ratings: List<double>.from(data['ratings'] ?? []),
      overallRating: data['overallRating'] ?? 0.0, comments: [],
=======
      comments: [],
      overallRating: 0.0, description: '', ratings: [],
>>>>>>> Stashed changes
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
      'image': imageUrl,
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

<<<<<<< Updated upstream
  /*Future<void> addProductRating(String productId, double rating) async {
=======
  Future<void> applyDiscountAndSetNewPrice(String productId, double discountPercentage) async {
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
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
>>>>>>> Stashed changes
}
