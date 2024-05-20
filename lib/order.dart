import 'product.dart';
import 'shipping.dart';

class Order {
  final List<Product> products;
  final DateTime date;
  final double totalPrice;
  final Shipping shipping;

  Order({
    required this.products,
    required this.date,
    required this.totalPrice,
    required this.shipping,
  });

  Map<String, dynamic> toMap() {
    return {
      'products': products.map((product) => productToMap(product)).toList(),
      'date': date.toIso8601String(),
      'totalPrice': totalPrice,
      'shipping': shipping.toMap(),
    };
  }

  static Order fromMap(Map<String, dynamic> map) {
    return Order(
      products: List<Product>.from(map['products']?.map((productMap) => productFromMap(productMap)) ?? []),
      date: DateTime.parse(map['date']),
      totalPrice: map['totalPrice'],
      shipping: Shipping.fromMap(map['shipping']),
    );
  }

  Map<String, dynamic> productToMap(Product product) {
    return {
      'name': product.name,
      'vendorName': product.vendorName,
      'image': product.image,
      'price': product.price,
      'newPrice': product.newPrice,
      'category': product.category,
      'description': product.description,
      'comments': product.comments,
      'ratings': product.ratings,
      'overallRating': product.overallRating,
      'sizes': product.sizes,
      'unitsByColorAndSize': product.unitsByColorAndSize,
    };
  }

  static Product productFromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'],
      vendorName: map['vendorName'],
      image: map['image'],
      price: map['price'],
      comments: List<String>.from(map['comments']),
      category: map['category'],
      description: map['description'],
      overallRating: map['overallRating'],
      sizes: List<String>.from(map['sizes']),
      unitsByColorAndSize: Map<String, Map<String, int>>.from(map['unitsByColorAndSize']),
    );
  }
}
