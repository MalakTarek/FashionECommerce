import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< Updated upstream:lib/users.dart
=======
import '../Products/product.dart';
import '../Order/order.dart' as orders;
>>>>>>> Stashed changes:lib/Registration/users.dart
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String uid;
  final String email;
  final String name;
  final String role;

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
<<<<<<< Updated upstream:lib/users.dart
  });

=======

  });





>>>>>>> Stashed changes:lib/Registration/users.dart
  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return User(
      uid: snapshot.id,
      email: data['email'],
      name: data['name'],
      role: data['role'],
<<<<<<< Updated upstream:lib/users.dart
=======

>>>>>>> Stashed changes:lib/Registration/users.dart
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
<<<<<<< Updated upstream:lib/users.dart
=======

>>>>>>> Stashed changes:lib/Registration/users.dart
    };
  }
}

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'users';

  Future<void> createUser(User user) async {
    try {
      await _firestore.collection(_collectionPath).doc(user.uid).set(user.toFirestore());
    } catch (error) {
      // Handle errors (e.g., print error message)
      throw Exception('Failed to create user: $error');
    }
  }

  Future<User?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(_collectionPath).doc(uid).get();
      if (doc.exists) {
        return User.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (error) {
<<<<<<< Updated upstream:lib/users.dart
=======
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
  Future<User?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(_collectionPath).doc(uid).get();
      if (doc.exists) {
        return User.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (error) {
>>>>>>> Stashed changes:lib/Registration/users.dart
      // Handle errors (e.g., print error message)
      throw Exception('Failed to get user: $error');
    }
  }
<<<<<<< Updated upstream:lib/users.dart
}
=======
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
}
>>>>>>> Stashed changes:lib/Registration/users.dart
