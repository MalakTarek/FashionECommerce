import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_ecommerce/Order/orderpage.dart';
import 'package:fashion_ecommerce/Products/product_view.dart';
import 'package:fashion_ecommerce/Products/vendorProducts.dart';
import 'package:fashion_ecommerce/Registration/users.dart';
import 'package:firebase_auth/firebase_auth.dart' as users;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Order/cartpage.dart';
import '../WishList/wishlistpage.dart';
import '../main.dart';
import 'product.dart';
import '../clothingCategory.dart';


class ProductsPage extends StatefulWidget {
  const ProductsPage();

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final ProductRepository _productRepository;
  late final String? pid; // Add pid field
  late Future<List<Product>> _allProductsFuture;

  late final UserRepository  _userRepository;
  @override
  void initState() {
    super.initState();
    _productRepository = ProductRepository();
    _refreshProducts();
    _userRepository = UserRepository();
  }

  void _refreshProducts() {
    setState(() {
      _allProductsFuture = _productRepository.getAllProducts();
    });
  }



  @override
  Widget build(BuildContext context) {
    final userId = users.FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _refreshProducts();
            },
          ),
          if (userId != null)
            FutureBuilder<String?>(
              future: _userRepository.getUserRole(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox.shrink();
                } else if (snapshot.hasError) {
                  return SizedBox.shrink(); // Handle error appropriately in your app
                } else if (snapshot.hasData && snapshot.data == 'Shopper') {
                  return IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartPage()),
                      );
                    },
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFE1BFAA),
              ),
              child: Text('Menu'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            FutureBuilder<String?>(
              future: _userRepository.getUserRole(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox.shrink();
                } else if (snapshot.hasError) {
                  return SizedBox.shrink(); // Handle error appropriately in your app
                } else if (snapshot.hasData && snapshot.data == 'Shopper') {
                  return ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text('Wish List'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WishListPage()),
                      );
                    },
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
            FutureBuilder<String?>(
              future: _userRepository.getUserRole(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox.shrink();
                } else if (snapshot.hasError) {
                  return SizedBox.shrink(); // Handle error appropriately in your app
                } else if (snapshot.hasData && snapshot.data == 'Vendor') {
                  return ListTile(
                    leading: Icon(Icons.add_business),
                    title: Text('View Products'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VendorProductPage()),
                      );
                    },
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),

            FutureBuilder<String?>(
              future: _userRepository.getUserRole(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox.shrink();
                } else if (snapshot.hasError) {
                  return SizedBox.shrink(); // Handle error appropriately in your app
                } else if (snapshot.hasData && snapshot.data == 'Shopper') {
                  return ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text('View Orders'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderPage()),
                      );
                    },
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                Navigator.pop(context); // Close the drawer
                await users.FirebaseAuth.instance.signOut();
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('idToken');
                await prefs.remove('expirationTime');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
          ],
        ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(

                          builder: (context) => ProductViewPage(product: products[index] ,  pid: products[index].pid ),
                        ),
                      );
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded( // Wrap with Expanded
                            child: Center(
                              child: SizedBox(
                                width: double.infinity,
                                height: 150,
                                child: Image.network(
                                  products[index].imageUrl,
                                  fit: BoxFit.contain, // Change the fit property
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
                    ),
                  );
                },
              );
            }
          }
        },
      ),
      floatingActionButton: userId == null ? null : FutureBuilder<String?>(
        future: _userRepository.getUserRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return SizedBox.shrink(); // handle error appropriately in your app
          } else if (snapshot.hasData && snapshot.data == 'Vendor') {
            return FloatingActionButton(
              onPressed: () {
                _showCreateProductBottomSheet(context);
              },
              child: Icon(Icons.add),
            );
          } else {
            return SizedBox.shrink(); // return an empty widget if the user is not a Vendor
          }
        },
      ),
    );
  }

  void _showCreateProductBottomSheet(BuildContext context ) async {
    users.User? user = users.FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection(
          'users').doc(user.uid).get();
      bool isVendor = doc['role'] ==
          'Vendor'; // Assuming 'role' field in user document
      if (isVendor) {
        final TextEditingController productName = TextEditingController();
        final TextEditingController price = TextEditingController();
        final TextEditingController category = TextEditingController();
        final TextEditingController description = TextEditingController();
        final ImagePicker picker = ImagePicker();
        String? imagePath;
        String vendorName = doc['name'];
        String vendorID = doc['uid'];
        //final Map<String, Map<String, int>> unitsByColorAndSize = {};
        /*void addColorRow() {
          setState(() {
            unitsByColorAndSize['New Color'] = {};
          });
        }*/
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
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: productName,
                      decoration: InputDecoration(labelText: 'Product Name'),
                    ),
                    TextField(
                      controller: price,
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: category,
                      decoration: InputDecoration(labelText: 'Category'),
                    ),
                    TextField(
                      controller: description,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    SizedBox(height: 20),
                    /*Text('Units by Color and Size:'),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: unitsByColorAndSize.length,
                      itemBuilder: (context, index) {
                        final color = unitsByColorAndSize.keys.elementAt(index);
                        final sizes = unitsByColorAndSize[color]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Color: $color'),
                            for (var size in sizes.keys)
                              TextField(
                                decoration: InputDecoration(labelText: '$size units'),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    unitsByColorAndSize[color]![size] = int.tryParse(value) ?? 0;
                                  });
                                },
                              ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  sizes['New Size'] = 0;
                                });
                              },
                              child: Text('Add Size'),
                            ),
                            SizedBox(height: 20),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(onPressed: addColorRow, child: Text('Add Color')),

                     */
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final XFile? pickedImage = await picker.pickImage(
                            source: ImageSource.gallery);
                        if (pickedImage != null) {
                          imagePath = pickedImage.path;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Image selected: $imagePath'),
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
                        if (imagePath != null &&
                            productName.text.isNotEmpty &&
                            price.text.isNotEmpty &&
                           category.text.isNotEmpty  && description.text.isNotEmpty) {
                          // Debugging: Print category input and enum value
                          print('_category.text.trim(): ${category.text.trim()}');
                          try {
                           clothingCategoryFromString(category.text.trim());
                            //print('Category enum value: $category');
                          } catch (e) {
                            print('Error creating category enum: $e');
                          }
                          // Upload image to Firebase Storage
                          final imageUrl = await _uploadImageToStorage(
                              imagePath!);
                          await _createProduct(
                            context,
                            productName.text.trim(),
                            vendorName,
                            double.parse(price.text.trim()),
                            CategoryExtension.fromString(category.text.trim()),
                            description.text.trim(),
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Only vendors can create products.'),
          duration: Duration(seconds: 2),
        ));
      }
    }
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
      String vendorName, double price, ClothingCategory category,
      String description, String imageUrl  ) async {
    if (imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to upload image. Please try again.'),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    final ProductRepository _productRepository = ProductRepository();
    // Get current user
    final user1 = FirebaseAuth.instance.currentUser;
    if (user1 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User not logged in. Please log in and try again.'),
          duration: Duration(seconds: 2),
        ),
      );
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
      description:description,
      sizes: [],
      unitsByColorAndSize: {},
      vendorId: user1.uid, pid: '',
    );

    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final String _collectionPath = 'products';
      DocumentReference docRef =
      await _firestore.collection(_collectionPath).add(newProduct.toFirestore());
      String productId = docRef.id; // Get the generated document ID
      newProduct.pid = productId; // Set the product ID in the product object

      // Directly add the product to Firestore without using ProductRepository
      await _firestore.collection(_collectionPath).doc(productId).set(newProduct.toFirestore());
      _refreshProducts(); // Refresh products after creating a new one
      Navigator.pop(context); // Close the bottom sheet after creating a product

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Product created successfully!'),
        duration: Duration(seconds: 2),
      ));
      print('Product created successfully.');
    } catch (error) {
      // Check if the context is still valid before showing the SnackBar
      if (ScaffoldMessenger
          .of(context)
          .mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to create product: $error'),
          duration: Duration(seconds: 2),
        ));
        print(user1.uid);
      }
    }
  }

  ClothingCategory clothingCategoryFromString(String categoryString) {
    switch (categoryString.toLowerCase()) {
      case 'Dresses':
        return ClothingCategory.dresses;
      case 'Shirts':
        return ClothingCategory.shirts;
      case 'Pants':
        return ClothingCategory.pants;
      case 'Bags':
        return ClothingCategory.bags;
      case 'Accessories':
        return ClothingCategory.accessories;
      case 'Shoes':
        return ClothingCategory.shoes;
      default:
        return ClothingCategory.pants;
    }
  }
}

