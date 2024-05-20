import 'package:cloud_firestore/cloud_firestore.dart';
import 'order.dart' as orders;

class User {
  final String uid;
  final String email;
  final String name;
  final String role;
  List<orders.Order> ordersList = [];
  List<String> wishlist = [];

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
