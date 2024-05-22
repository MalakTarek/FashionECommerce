import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_ecommerce/product.dart';
import 'order.dart' as orders;
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String uid;
  final String email;
  final String name;
  final String role;
  List<orders.Order> ordersList;
  List<Product> wishlist;
  List<Product> cart;

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.ordersList = const [],
    this.wishlist = const [],
    this.cart = const [],
  });

  void addOrder(orders.Order order) {
    ordersList.add(order);
  }

  void addToWishlist(Product product) {
    if (!wishlist.contains(product)) {
      wishlist.add(product);
    }
  }

  void removeFromWishlist(Product product) {
    wishlist.remove(product);
  }

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return User(
      uid: snapshot.id,
      email: data['email'],
      name: data['name'],
      role: data['role'],
      ordersList: (data['orders'] as List<dynamic>)
          .map((order) => orders.Order.fromMap(order))
          .toList(),
      wishlist: (data['wishlist'] as List<dynamic>)
          .map((item) => Product.fromFirestore(item))
          .toList(),
      cart: (data['cart'] as List<dynamic>)
          .map((item) => Product.fromFirestore(item))
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'orders': ordersList.map((order) => order.toMap()).toList(),
      'wishlist': wishlist.map((product) => product.toFirestore()).toList(),
      'cart': cart.map((product) => product.toFirestore()).toList(),
    };
  }
}

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'users';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection(_collectionPath).doc(uid).get();
      if (doc.exists) {
        return User.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (error) {
      throw Exception('Failed to get user profile: $error');
    }
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection(_collectionPath).doc(uid).update(updatedData);
    } catch (error) {
      throw Exception('Failed to update user profile: $error');
    }
  }

  Future<void> addToWishlist(String uid, Product product) async {
    try {
      await _firestore.collection(_collectionPath).doc(uid).update({
        'wishlist': FieldValue.arrayUnion([product.toFirestore()])
      });
    } catch (error) {
      throw Exception('Failed to add to wishlist: $error');
    }
  }

  Future<void> removeFromWishlist(String uid, Product product) async {
    try {
      await _firestore.collection(_collectionPath).doc(uid).update({
        'wishlist': FieldValue.arrayRemove([product.toFirestore()])
      });
    } catch (error) {
      throw Exception('Failed to remove from wishlist: $error');
    }
  }

  Future<List<Product>> getWishlist() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final doc = await _firestore.collection(_collectionPath).doc(uid).get();
        if (doc.exists) {
          final data = doc.data();
          return (data?['wishlist'] as List<dynamic>)
              .map((item) => Product.fromFirestore(item))
              .toList();
        }
      }
      return [];
    } catch (error) {
      throw Exception('Failed to get wishlist: $error');
    }
  }

  Future<String?> getUserRole() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final doc = await _firestore.collection(_collectionPath).doc(uid).get();
        if (doc.exists) {
          final data = doc.data();
          return data?['role'];
        }
      }
      return null;
    } catch (error) {
      throw Exception('Failed to get user role: $error');
    }
  }

  Future<void> addToCart(String uid, Product product) async {
    try {
      await _firestore.collection(_collectionPath).doc(uid).update({
        'cart': FieldValue.arrayUnion([product.toFirestore()])
      });
    } catch (error) {
      throw Exception('Failed to add to cart: $error');
    }
  }

  Future<void> removeFromCart(String uid, Product product) async {
    try {
      await _firestore.collection(_collectionPath).doc(uid).update({
        'cart': FieldValue.arrayRemove([product.toFirestore()])
      });
    } catch (error) {
      throw Exception('Failed to remove from cart: $error');
    }
  }

  Future<List<Product>> getCart() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final doc = await _firestore.collection(_collectionPath).doc(uid).get();
        if (doc.exists) {
          final data = doc.data();
          return (data?['cart'] as List<dynamic>)
              .map((item) => Product.fromFirestore(item))
              .toList();
        }
      }
      return [];
    } catch (error) {
      throw Exception('Failed to get cart: $error');
    }
  }
}
