import 'package:cloud_firestore/cloud_firestore.dart';
import 'order.dart' as orders;
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String uid;
  final String email;
  final String name;
  final String role;
  List<orders.Order> ordersList;
  List<String> wishlist;

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.ordersList = const [],
    this.wishlist = const [],
  });

  void addOrder(orders.Order order) {
    ordersList.add(order);
  }

  void addToWishlist(String productId) {
    if (!wishlist.contains(productId)) {
      wishlist.add(productId);
    }
  }

  void removeFromWishlist(String productId) {
    wishlist.remove(productId);
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
      wishlist: List<String>.from(data['wishlist'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'orders': ordersList.map((order) => order.toMap()).toList(),
      'wishlist': wishlist,
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

  Future<void> addToWishlist(String uid, String productId) async {
    try {
      await _firestore.collection(_collectionPath).doc(uid).update({
        'wishlist': FieldValue.arrayUnion([productId])
      });
    } catch (error) {
      throw Exception('Failed to add to wishlist: $error');
    }
  }

  Future<void> removeFromWishlist(String uid, String productId) async {
    try {
      await _firestore.collection(_collectionPath).doc(uid).update({
        'wishlist': FieldValue.arrayRemove([productId])
      });
    } catch (error) {
      throw Exception('Failed to remove from wishlist: $error');
    }
  }

  Future<List<String>> getWishlist() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final doc = await _firestore.collection(_collectionPath).doc(uid).get();
        if (doc.exists) {
          final data = doc.data();
          return List<String>.from(data?['wishlist'] ?? []);
        }
      }
      return [];
    } catch (error) {
      throw Exception('Failed to get wishlist: $error');
    }
  }
}
