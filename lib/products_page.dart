import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'product.dart'; // Import ProductService



class ProductsPage extends StatefulWidget {
  const ProductsPage();

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final ProductRepository _productService;
  late Future<List<Product>> _allProductsFuture;

  @override
  void initState() {
    super.initState();
    _productService = ProductRepository(); // Initialize ProductService here
    _refreshProducts(); // Refresh products initially
  }

  // Add this method to refresh products
  void _refreshProducts() {
    setState(() {
      _allProductsFuture = _productService.getAllProducts();
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
            return ListView.builder(
              itemCount: products!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(products[index].name),
                  subtitle: Text('Price: ${products[index].price.toString()}'),
                  // Add more product attributes as needed
                );
              },
            );
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
                    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      _imagePath = pickedImage.path;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Image selected: $_imagePath'),
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      print('No image selected.');
                    }
                  },
                  child: Text('Select Image'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_imagePath != null) {
                      await createProduct(
                        context,
                        _productName.text.trim(),
                        _vendorName.text.trim(),
                        _category.text.trim(),
                        _imagePath!, // Use the path of the image file as a String
                      );
                    } else {
                      print('No image selected.');
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

  Future<void> createProduct(BuildContext context, String productName, String vendorName,
      String category, String path) async {
    print(vendorName);


    Product newProduct = Product(
      name: productName,
      vendorName: vendorName,
      image: path, // Use the path of the image file as a String
      price: 0, // No default price
      comments: [],
      overallRating: 0.0,
<<<<<<< HEAD
      category: category, 
       description: '', sizes: [], unitsByColorAndSize: {},
=======
      category: category, ratings: [],
>>>>>>> 65646c45db8e97d19ac58d34e4b5e86be1e66776
    );

    try {
      await _productService.createProduct(newProduct);
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

