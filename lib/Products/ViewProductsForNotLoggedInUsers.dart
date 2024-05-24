import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fashion_ecommerce/Products/product.dart';

class ProductListScreenDesign extends StatefulWidget {
  const ProductListScreenDesign();

  @override
  _ProductListScreenDesignState createState() => _ProductListScreenDesignState();
}

class _ProductListScreenDesignState extends State<ProductListScreenDesign> {
  late final ProductRepository _productRepository;
  late Future<List<Product>> _allProductsFuture;

  @override
  void initState() {
    super.initState();
    _productRepository = ProductRepository(); // Assuming you have a ProductRepository class
    _allProductsFuture = _productRepository.getAllProducts(); // Fetch all products on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _allProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
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
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: Image.network(
                                products[index].imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(products[index].name),
                              Text('Price: ${products[index].price.toString()}'),
                            ],
                          ),
                        ),
                      ],
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
