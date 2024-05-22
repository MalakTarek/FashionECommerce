import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'product.dart';
import 'shipping.dart';
import 'order.dart' as orders;

class Cart {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addProductToCart(Product product) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently signed in.');
    }

    String uid = currentUser.uid;

    await _firestore.collection('users').doc(uid).update({
      'cart': FieldValue.arrayUnion([product.toFirestore()])
    });
  }

  Future<double> calculateTotalPrice() async {
    List<Product> products = await _getCartProducts();
    double totalPrice = products.fold(0, (previousValue, product) => previousValue + product.price);
    return totalPrice + 3.99 + 2.00; // Add shipping of 3.99 and taxes of 2.00
  }

  Future<Map<String, dynamic>> generateOrderSummary() async {
    double totalPrice = await calculateTotalPrice();
    double subtotal = totalPrice - 3.99 - 2.00;
    return {
      'subtotal': subtotal.toStringAsFixed(2),
      'shipping': '3.99',
      'tax': '2.00',
      'total': totalPrice.toStringAsFixed(2),
    };
  }

  Future<List<Map<String, dynamic>>> getCartContentsForDisplay() async {
    List<Product> products = await _getCartProducts();
    return products.map((product) => {
      'name': product.name,
      'image': product.image,
      'price': product.price.toStringAsFixed(2),
    }).toList();
  }

  Future<void> placeOrder(Shipping shipping) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently signed in.');
    }
    String uid = currentUser.uid;

    List<Product> products = await _getCartProducts();
    orders.Order order = orders.Order(
      products: List<Product>.from(products),
      date: DateTime.now(),
      totalPrice: await calculateTotalPrice(),
      shipping: shipping,
    );

    await _firestore.collection('users').doc(uid).update({
      'orders': FieldValue.arrayUnion([order.toMap()]),
      'cart': [] // Clear the cart
    });
  }

  Future<List<Product>> _getCartProducts() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently signed in.');
    }

    String uid = currentUser.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('users').doc(uid).get();
    List<dynamic> cartData = snapshot.data()?['cart'] ?? [];
    return cartData.map((item) => Product.fromFirestore(item)).toList();
  }
}
