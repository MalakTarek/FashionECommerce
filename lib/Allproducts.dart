import 'package:fashion_ecommerce/product.dart';
import 'package:flutter/material.dart';
import 'product.dart'; // Import ProductService


class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductRepository _productService = ProductRepository(); // Create an instance of ProductService
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts(); // Call method to load products when the screen initializes
  }

  Future<void> _loadProducts() async {
    try {
      final List<Product> products = await _productService.getAllProducts(); // Fetch products from ProductService
      setState(() {
        _products = products; // Update products list
      });
    } catch (error) {
      // Handle error
      print('Failed to load products: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: _buildProductList(),
    );
  }

  Widget _buildProductList() {
    if (_products.isEmpty) {
      // Display loading indicator if products list is empty
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // Display list of products
      return ListView.builder(
        itemCount: _products.length,
        itemBuilder: (BuildContext context, int index) {
          final Product product = _products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
            onTap: () {
              // Navigate to product detail screen
              // You can implement this as needed
            },
          );
        },
      );
    }
  }
}
