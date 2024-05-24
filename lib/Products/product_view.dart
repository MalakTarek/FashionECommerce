import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as mimi;
import '../Products/product.dart';
import '../Products/product_description.dart';
import '../Order/cartItems.dart';
import '../Registration/users.dart';
import '../WishList/wishlistItems.dart';

class ProductViewPage extends StatefulWidget {
  final Product product;
  final String pid;

  const ProductViewPage({Key? key, required this.product, required this.pid}) : super(key: key);

  @override
  _ProductViewPageState createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  bool isFavorite = false;
  late Product productInCart;
  late WishListItem productInwishlist;
  late TextEditingController _commentController;
  late UserRepository  _userRepository;
  late ProductRepository  _productRepository;


  @override
  void initState() {
    super.initState();
    widget.product.pid = widget.pid; // Initialize the pid field of the product
    productInCart = widget.product; // Initialize the productInCart
    checkIfFavorite(); // Check if the product is already in the wishlist
    _commentController = TextEditingController();
    _userRepository = UserRepository();
   // _productRepository = ProductRepository();

  }

  @override
  Widget build(BuildContext context) {
    _productRepository = ProductRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Container(
             margin: EdgeInsets.fromLTRB(0, 0, 0, 7),
              child: ClipRect(
                child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 2,
                sigmaY: 2,
              ),
                  child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: -12,
                      right: -12,
                      top: -4,
                      bottom: -4,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 2,
                            sigmaY: 2,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFFFFFFF)),
                              color: Color(0xFFFFFFFF),
                            ),
                            child: Container(
                              width: 360,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
                            child: SizedBox(
                              width: 70,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
           Container(
          margin: EdgeInsets.fromLTRB(11, 0, 25, 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: SizedBox(
                  width: 67,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(18, 0, 21.8, 33),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                widget.product.imageUrl,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x2B000000),
                offset: Offset(7, 4),
                blurRadius: 5,
              ),
            ],
          ),
          child: Container(
            width: 201,
            height: 304,
          ),
        ),
              Container(
                margin: EdgeInsets.fromLTRB(18, 0, 10.8, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price: \$${widget.product.price}',
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 22,
                            height: 1,
                            letterSpacing: 0.5,
                            color: Color(0xFF000000),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                              if (isFavorite) {
                                addToWishlist();
                              } else {
                                removeFromWishlist();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Product Name: ${widget.product.name}',
                      style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFF000000)
                      ),
                    ),
                    Text(
                      'Available Sizes: ${widget.product.sizes}',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(product: widget.product),
                          ),
                        );
                      },
                      child: const Text(
                        'Read Description',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue, // Example color, change as needed
                        ),
                      ),
                    ),
                    Center(
                      child: FutureBuilder<String?>(
                        future: _userRepository.getUserRole(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData && snapshot.data == 'Shopper') {
                            return ElevatedButton(
                              onPressed: addToCart,
                              child: const Text(
                                'Add to Cart',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color(0xFF3D3937),
                                ),
                              ),
                            );
                          } else {
                            return ElevatedButton(
                              onPressed: () async {
                                // Show a dialog to input discount percentage
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // TextEditingController to get user input
                                    TextEditingController discountController = TextEditingController();
                                    return AlertDialog(
                                      title: Text('Add Discount'),
                                      content: TextField(
                                        controller: discountController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(labelText: 'Discount Percentage'),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              // Get the discount percentage from the input field
                                              double discountPercentage = double.parse(discountController.text);
                                              // Call the function to apply discount
                                              await _productRepository.applyDiscountAndSetNewPrice(widget.product.pid, discountPercentage);
                                              // Close the dialog
                                              Navigator.pop(context);
                                            } catch (error) {
                                              print('Error applying discount: $error');
                                            }
                                          },
                                          child: Text('Create'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                'Add Discount',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color(0xFF3D3937),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),

                    // Comment Section
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          labelText: 'Enter your comment...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        submitComment();
                      },
                      child: Text('Submit Comment'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Functions here...
  Future<void> addToCart() async {
    // Use user.uid to specify the owner of this product
    mimi.User? user = mimi.FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Use user.uid to specify the owner of this product
      String uid = user.uid;
      // Create a CartItem object with product details
      CartItem cartItem = CartItem(
        imageUrl: widget.product.imageUrl,
        price: widget.product.price,
        name: widget.product.name,
      );
      try {
        // Post the product in the cart table
        await FirebaseFirestore.instance.collection('cart').add({
          'uid': uid,
          'imageUrl': cartItem.imageUrl,
          'price': cartItem.price,
          'name': cartItem.name,
        });
        // Show a SnackBar to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${cartItem.name} added to cart')),
        );
      } catch (error) {
        // Handle errors
        print("Failed to add item to cart: $error");
      }
    }
  }

  Future<void> checkIfFavorite() async {
    mimi.User? user = mimi.FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      // Query Firestore to check if the product is in the wishlist
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('wishlist')
          .where('uid', isEqualTo: uid)
          .where('name', isEqualTo: widget.product.name)
          .get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          isFavorite = true;
        });
      }
    }
  }

  Future<void> addToWishlist() async {
    mimi.User? user = mimi.FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      WishListItem wishItem = WishListItem(
        imageUrl: widget.product.imageUrl,
        price: widget.product.price,
        name: widget.product.name,
      );
      try {
        await FirebaseFirestore.instance.collection('wishlist').add({
          'uid': uid,
          'imageUrl': wishItem.imageUrl,
          'price': wishItem.price,
          'name': wishItem.name,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${wishItem.name} added to wishlist')),
        );
      } catch (error) {
        print("Failed to add item to wishlist: $error");
      }
    }
  }

  Future<void> removeFromWishlist() async {
    mimi.User? user = mimi.FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('wishlist')
            .where('uid', isEqualTo: uid)
            .where('name', isEqualTo: widget.product.name)
            .get();
        if (snapshot.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('wishlist')
              .doc(snapshot.docs[0].id)
              .delete();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${widget.product.name} removed from wishlist')),
          );
        }
      } catch (error) {
        print("Failed to remove item from wishlist: $error");
      }
    }
  }
  Future<void> submitComment() async {
    String comment = _commentController.text.trim();

    if (comment.isNotEmpty) {
      try {
        // Update the product document with the new comment
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.product.pid) // Using widget.product.pid to identify the product
            .update({
          'comments': FieldValue.arrayUnion([comment]),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Comment submitted successfully')),
        );

        // Clear the text field after submission
        _commentController.clear();
      } catch (error) {
        print("Failed to submit comment: $error");
        print("Document Path: ${widget.product.pid}");

      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a comment')),
      );
    }
  }







}
