import 'package:cloud_firestore/cloud_firestore.dart';

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
  });

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return User(
      uid: snapshot.id,
      email: data['email'],
      name: data['name'],
      role: data['role'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
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
      // Handle errors (e.g., print error message)
      throw Exception('Failed to get user: $error');
    }
  }
}
