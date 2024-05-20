import 'package:cloud_firestore/cloud_firestore.dart';
import 'product.dart';
import 'users.dart';
import 'order.dart' as orders;  

class Cart {
  List<Product> products = [];

  void addProductToCart(Product product) {
    products.add(product);
  }

  double calculateTotalPrice() {
    double totalPrice = products.fold(0, (previousValue, product) => previousValue + product.price);
    return totalPrice + 3.99 + 2.00; // Add shipping of 3.99 and taxes of 2.00
  }

  Map<String, dynamic> generateOrderSummary() {
    double totalPrice = calculateTotalPrice();
    double subtotal = totalPrice - 3.99 - 2.00;
    return {
      'subtotal': subtotal.toStringAsFixed(2),
      'shipping': '3.99',
      'tax': '2.00',
      'total': totalPrice.toStringAsFixed(2),
    };
  }

  List<Map<String, dynamic>> getCartContentsForDisplay() {
    List<Map<String, dynamic>> cartContents = [];
    for (var product in products) {
      cartContents.add({
        'name': product.name,
        'image': product.image,
        'price': product.price.toStringAsFixed(2),
      });
    }
    return cartContents;
  }

  Future<void> placeOrder(User user) async {
    orders.Order order = orders.Order(
      products: List<Product>.from(products),  // Create a new list to avoid issues with clearing
      date: DateTime.now(),
      totalPrice: calculateTotalPrice(),
    );

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'orders': FieldValue.arrayUnion([order.toMap()])
    });
    
    // Clear the cart after placing the order
    products.clear();
  }
}
