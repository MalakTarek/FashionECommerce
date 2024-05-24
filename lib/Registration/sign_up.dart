<<<<<<< Updated upstream:lib/sign_up.dart
import 'dart:io';
=======
import 'package:fashion_ecommerce/main.dart';
>>>>>>> Stashed changes:lib/Registration/sign_up.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Add this import
import 'product.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage();

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final ProductRepository _productRepository;
  late Future<List<Product>> _allProductsFuture;

  @override
  void initState() {
    super.initState();
    _productRepository = ProductRepository();
    _refreshProducts();
  }

  void _refreshProducts() {
    setState(() {
      _allProductsFuture = _productRepository.getAllProducts();
    });
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
                  return InkWell(
                    onTap: () {
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => AnotherPage()));
                    },
                    child: GridTile(
                      child: Image.network(products[index].imageUrl),
                      footer: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 0.1), // Adjust the vertical padding as needed
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(products[index].name),
                            Text('Price: ${products[index].price.toString()}'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );


            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateProductBottomSheet(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showCreateProductBottomSheet(BuildContext context) async {
    final TextEditingController _productName = TextEditingController();
    final TextEditingController _vendorName = TextEditingController();
    final TextEditingController _price = TextEditingController();
    final TextEditingController _category = TextEditingController();
    final ImagePicker _picker = ImagePicker();
    String? _imagePath;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Product',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _productName,
                  decoration: InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: _vendorName,
                  decoration: InputDecoration(labelText: 'Vendor Name'),
                ),
                TextField(
                  controller: _price,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _category,
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final XFile? pickedImage = await _picker.pickImage(
                        source: ImageSource.gallery);
                    if (pickedImage != null) {
                      _imagePath = pickedImage.path;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Image selected: $_imagePath'),
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('No image selected.'),
                        duration: Duration(seconds: 2),
                      ));
                    }
                  },
                  child: Text('Select Image'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_imagePath != null && _productName.text.isNotEmpty &&
                        _vendorName.text.isNotEmpty && _price.text.isNotEmpty &&
                        _category.text.isNotEmpty) {
                      // Upload image to Firebase Storage
                      final imageUrl = await _uploadImageToStorage(_imagePath!);
                      await _createProduct(
                        context,
                        _productName.text.trim(),
                        _vendorName.text.trim(),
                        double.parse(_price.text.trim()),
                        _category.text.trim(),
                        imageUrl,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Please fill all fields and select an image.'),
                        duration: Duration(seconds: 2),
                      ));
                    }
                  },
                  child: Text('Create'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> _uploadImageToStorage(String imagePath) async {
    final file = File(imagePath);
    final fileName = imagePath
        .split('/')
        .last;
    final storageRef = FirebaseStorage.instance.ref().child(
        'product_images/$fileName');
    final uploadTask = storageRef.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _createProduct(BuildContext context, String productName,
      String vendorName, double price, String category, String imageUrl) async {
    if (imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to upload image. Please try again.'),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    Product newProduct = Product(
      name: productName,
      vendorName: vendorName,
      imageUrl: imageUrl,
      price: price,
      comments: [],
      overallRating: 0.0,
      category: category,
      ratings: [],
      description: '',
    );

    try {
      await _productRepository.createProduct(newProduct);
      _refreshProducts(); // Refresh products after creating a new one
      Navigator.pop(context); // Close the bottom sheet after creating a product
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Product created successfully!'),
        duration: Duration(seconds: 2),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to create product: $error'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}


