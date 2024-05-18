import 'package:flutter/material.dart';
import 'package:fashion_ecommerce/product.dart'; // Import Product model

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductRepository _productRepository = ProductRepository(); // Create an instance of ProductRepository
  late Future<List<Product>> _allProductsFuture = Future.value([]); // Initialize _allProductsFuture

  @override
  void initState() {
    super.initState();
    _loadProducts(); // Call method to load products when the screen initializes
  }

  Future<void> _loadProducts() async {
    try {
      final List<Product> products = await _productRepository.getAllProducts(); // Fetch products from ProductRepository
      setState(() {
        _allProductsFuture = Future.value(products); // Update products list
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
      body: FutureBuilder<List<Product>>(
        future: _allProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display loading indicator if products list is empty
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Handle error
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            // Display list of products
            List<Product>? products = snapshot.data;
            if (products == null || products.isEmpty) {
              return Center(
                child: Text('No products available.'),
              );
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return GridTile(
                    child: Image.network(products[index].imageUrl),
                    footer: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(products[index].name),
                          Text('Price: \$${products[index].price.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
