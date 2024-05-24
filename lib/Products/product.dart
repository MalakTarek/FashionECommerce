import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< Updated upstream:lib/product.dart
import 'package:firebase_messaging/firebase_messaging.dart';

=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../Registration/users.dart' as users;
import '../clothingCategory.dart';
>>>>>>> Stashed changes:lib/Products/product.dart

class Product {
  String pid;
  late final String vendorId;
  final String name;
  final String vendorName;
  final String imageUrl;
  final double price;
<<<<<<< Updated upstream:lib/product.dart
  double newPrice=0;
  final String category;
=======
  double newPrice;
  final ClothingCategory category;
>>>>>>> Stashed changes:lib/Products/product.dart
  final String description;
  final List<String> comments;
  List<double> ratings = [];
  final double overallRating;
  late final List<String> sizes;
  late final Map<String, Map<String, int>> unitsByColorAndSize;

  Product({
<<<<<<< Updated upstream:lib/product.dart
=======
      required this.pid,
    required this.vendorId,
>>>>>>> Stashed changes:lib/Products/product.dart
    required this.name,
    required this.vendorName,
    required this.imageUrl,
    required this.price,
    required this.comments,
    required this.category,
    required this.description,
     this.overallRating=0.0,
    required this.sizes,
    required this.unitsByColorAndSize,
  });
  String getImage() {
    return imageUrl;
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
    final user = FirebaseAuth.instance.currentUser;

    return Product(
<<<<<<< Updated upstream:lib/product.dart
      name: data['name'],
      vendorName: data['vendorName'],
      imageUrl: data['image'],
      price: data['price'],
      category: data['category'],
      comments: [],
      overallRating: 0.0, description: '', sizes: [], unitsByColorAndSize: {},
=======
        pid: snapshot.id,
        vendorId: user!.uid,
        name: data['name'],
        vendorName: data['vendorName'],
        imageUrl: data['image'],
        price: (data['price'] as num?)?.toDouble() ?? 0.0,
        category: CategoryExtension.fromString(data['category'] ?? ''), // Provide default value if null        overallRating: data['overallRating'] ?? 0.0, comments: [],
        description: data['description'] ?? '',
        sizes: [],
        unitsByColorAndSize: {},
        comments: [],
        newPrice: (data['newPrice'] as num?)?.toDouble() ?? 0.0,

>>>>>>> Stashed changes:lib/Products/product.dart
    );
  }
/*
price: (data['price'] as num?)?.toDouble() ?? 0.0,
overallRating: (data['overallRating'] as num?)?.toDouble() ?? 0.0,
newPrice: (data['newPrice'] as num?)?.toDouble() ?? 0.0,
 */

  Map<String, dynamic> toFirestore() {
    // Convert other properties to Firestore data
    Map<String, dynamic> data = {
      'vendorId': vendorId,
      'name': name,
      'vendorName': vendorName,
      'image': imageUrl,
      'price': price,
<<<<<<< Updated upstream:lib/product.dart
      'category': category,
=======
      'category': category.name,
      'comments': comments,
      'overallRating': overallRating,
      'description': description,
      'sizes': sizes,
      'unitsByColorAndSize': unitsByColorAndSize,
      'newPrice': newPrice,
      'isDiscounted': isDiscounted,
>>>>>>> Stashed changes:lib/Products/product.dart
    };
    // If pid is available, add it to Firestore data
    data['pid'] = pid;
      return data;
  }

}

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final String _collectionPath = 'products';

<<<<<<< Updated upstream:lib/product.dart
  Future<void> createProduct(Product product) async {
    try {//await productRepository.createProduct(newProduct);
      await _firestore.collection(_collectionPath).add(product.toFirestore());
      await _sendNewProductNotification(product);
    } catch (error) {
      throw Exception('Failed to create product: $error');
    }
  }
  Future<void> _sendNewProductNotification(Product product) async {
    try {
      // Fetch all users with role "shopper"
      final shoppersQuerySnapshot = await _firestore.collection('users')
          .where('role', isEqualTo: 'shopper')
          .get();

      // Extract FCM tokens
      List<String> fcmTokens = [];
      for (var doc in shoppersQuerySnapshot.docs) {
        String? token = doc.data()['fcmToken'];
        if (token != null) {
          fcmTokens.add(token);
        }
      }

      // Send push notifications to all shoppers
      for (String token in fcmTokens) {
        await _sendPushNotification(
            token,
            'New Product Alert!',
            'A new product "${product.name}" has been added by ${product.vendorName}. Check it out now!'
        );
=======

  Future<bool> isProductDiscounted(String productId) async {
    try {
      final doc = await _firestore.collection(_collectionPath)
          .doc(productId)
          .get();
      if (doc.exists) {
        bool isDiscounted = doc.data()?['isDiscounted'] ?? false;
        return isDiscounted;
      } else {
        throw Exception('Product not found');
>>>>>>> Stashed changes:lib/Products/product.dart
      }
    } catch (error) {
      throw Exception('Failed to send new product notification: $error');
    }
  }
  Future<void> _sendPushNotification(String token, String title, String body) async {
    try {
      // ignore: deprecated_member_use
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
<<<<<<< Updated upstream:lib/product.dart
  Future<void> applyDiscountAndSetNewPrice(String productId, double discountPercentage) async {
=======

  Future<void> applyDiscountAndSetNewPrice(String productId,
      double discountPercentage) async {
>>>>>>> Stashed changes:lib/Products/product.dart
    try {
      final doc = await _firestore.collection(_collectionPath)
          .doc(productId)
          .get();
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
<<<<<<< Updated upstream:lib/product.dart
          for (String token in fcmTokens) {
            await _sendPushNotification(
                token,
                'Discount Alert!',
                'The product "${product.name}" is now available at a $discountPercentage% discount. New Price: \$${newPrice.toStringAsFixed(2)}'
            );
          }
=======
        }
        for (String token in fcmTokens) {
          await _sendPushNotification(
              token,
              'Discount Alert!',
              'The product "${product
                  .name}" is now available at a $discountPercentage% discount. New Price: \$${newPrice
                  .toStringAsFixed(2)}'
          );
>>>>>>> Stashed changes:lib/Products/product.dart
        }
      }
    } catch (error) {
      throw Exception('Failed to apply discount and set new price: $error');
    }
  }
<<<<<<< Updated upstream:lib/product.dart
=======

  Future<void> _sendNewProductNotification(Product product) async {
    try {
      final shoppersQuerySnapshot = await _firestore.collection('users').where(
          'role', isEqualTo: 'shopper').get();

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
          'New Product Alert!',
          'A new product "${product.name}" has been added by ${product
              .vendorName}. Check it out now!',
        );
      }
    } catch (error) {
      throw Exception('Failed to send new product notification: $error');
    }
  }

  Future<void> _sendPushNotification(String token, String title,
      String body) async {
    try {
      await _messaging.sendMessage(
        to: token,
        data: {
          'title': title,
          'body': body,
        },
      );
    } catch (error) {
      throw Exception('Failed to send push notification: $error');
    }
  }

>>>>>>> Stashed changes:lib/Products/product.dart
  Future<List<Product>> getAllProducts() async {
    try {
      final querySnapshot = await _firestore.collection(_collectionPath).get();
      return querySnapshot.docs.map((doc) => Product.fromFirestore(doc))
          .toList();
    } catch (error) {
      throw Exception('Failed to get all products: $error');
    }
  }

  Future<Product?> getProduct(String productId) async {
    try {
      final doc = await _firestore.collection(_collectionPath)
          .doc(productId)
          .get();
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
<<<<<<< Updated upstream:lib/product.dart
  Future<void> editProductAttributes(String productId, Map<String, dynamic> updatedAttributes) async {
=======

  Future<void> editProductAttributes(String productId,
      Map<String, dynamic> updatedAttributes) async {
>>>>>>> Stashed changes:lib/Products/product.dart
    try {
      await _firestore.collection(_collectionPath).doc(productId).update(
          updatedAttributes);
    } catch (error) {
      throw Exception('Failed to edit product attributes: $error');
    }
  }
  Future<void> rateProduct(String productId, double rating) async {
<<<<<<< Updated upstream:lib/product.dart
    try { // pass rating from user and pass product id from firebase (current screen)
      //await productRepository.rateProduct(productId, userRating);(how to call it with button)
      final doc = await _firestore.collection(_collectionPath).doc(productId).get();
=======
    try {
      final doc = await _firestore.collection(_collectionPath)
          .doc(productId)
          .get();
>>>>>>> Stashed changes:lib/Products/product.dart
      if (doc.exists) {
        Product product = Product.fromFirestore(doc);
        product.addRating(rating);
        await _firestore.collection(_collectionPath).doc(productId).update(
            {'ratings': product.ratings});
      }
    } catch (error) {
      throw Exception('Failed to rate product: $error');
    }
  }
  Future<void> addCommentToProduct(String productId, String comment) async {
<<<<<<< Updated upstream:lib/product.dart
    try {// pass comment from user and pass product id from firebase (current screen)
      //await productRepository.addCommentToProduct(productId, comment);(how to call it with button)
      final doc = await _firestore.collection(_collectionPath).doc(productId).get();
=======
    try {
      final doc = await _firestore.collection(_collectionPath)
          .doc(productId)
          .get();
>>>>>>> Stashed changes:lib/Products/product.dart
      if (doc.exists) {
        await _firestore.collection(_collectionPath).doc(productId).update({
          'comments': FieldValue.arrayUnion([comment])
        });
        final product = Product.fromFirestore(doc);

        // Fetch vendor's FCM token
        final vendorDoc = await _firestore.collection('users').doc(
            product.vendorName).get();
        final vendorToken = vendorDoc.data()?['fcmToken'];

        if (vendorToken != null) {
          await _sendPushNotification(
              vendorToken,
              'New Comment on Your Product',
<<<<<<< Updated upstream:lib/product.dart
              'A new comment has been added to your product "${product.name}": $comment'
=======
              'A new comment has been added to your product "${product
                  .name}": $comment'
>>>>>>> Stashed changes:lib/Products/product.dart
          );
        }
      }
    } catch (error) {
      throw Exception('Failed to add comment to product: $error');
    }
  }
<<<<<<< Updated upstream:lib/product.dart
=======

  Future<List<Product>> getVendorProducts(String vendorName) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('vendorName', isEqualTo: vendorName)
          .get();
      return querySnapshot.docs.map((doc) => Product.fromFirestore(doc))
          .toList();
    } catch (error) {
      throw Exception('Failed to get vendor products: $error');
    }
  }

>>>>>>> Stashed changes:lib/Products/product.dart
  Future<String?> getProductDescription(String productId) async {
    try {
      final doc = await _firestore.collection(_collectionPath)
          .doc(productId)
          .get();
      if (doc.exists) {
        return Product.fromFirestore(doc).getDescription();
      } else {
        return null;
      }
    } catch (error) {
      throw Exception('Failed to get product description: $error');
    }
  }
<<<<<<< Updated upstream:lib/product.dart
=======

  Future<List<Product>> getProductsByCategory(ClothingCategory category) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where(
          'category', isEqualTo: category.name) // Filter by category name
          .get();

      return querySnapshot.docs.map((doc) => Product.fromFirestore(doc))
          .toList();
    } catch (error) {
      throw Exception('Failed to get products by category: $error');
    }
  }

  Future<List<Product>> searchProductsByName(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('name', isGreaterThanOrEqualTo: query) // Filter by name
          .where(
          'name', isLessThan: query + 'z') // Ensures case-insensitive search
          .get();

      return querySnapshot.docs.map((doc) => Product.fromFirestore(doc))
          .toList();
    } catch (error) {
      throw Exception('Failed to search products by name: $error');
    }
  }

>>>>>>> Stashed changes:lib/Products/product.dart
  Future<String?> getProductImage(String productId) async {
    try {
      final doc = await _firestore.collection(_collectionPath)
          .doc(productId)
          .get();
      if (doc.exists) {
        return Product.fromFirestore(doc).getImage();
      } else {
        return null;
      }
    } catch (error) {
      throw Exception('Failed to get product image: $error');
    }
  }
<<<<<<< Updated upstream:lib/product.dart
=======

>>>>>>> Stashed changes:lib/Products/product.dart
}
