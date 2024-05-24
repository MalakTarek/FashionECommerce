import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}
class _CartPageState extends State<CartPage> {
  late Stream<QuerySnapshot> _cartStream;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    _cartStream = FirebaseFirestore.instance
        .collection('cart')
        .where('uid', isEqualTo: uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _cartStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.data?.docs.isEmpty ?? true) {
            return Center(
              child: Text('Your cart is empty.'),
            );
          }

          double totalPrice = calculateTotalPrice(snapshot.data!);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Expanded ListView for products
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.5, // Adjust height as needed
                  child: ListView(
                    children: snapshot.data!.docs.map((document) {
                      return ListTile(
                        title: Text(document['name']),
                        subtitle: Text('\$${document['price']}'),
                        leading: Image.network(document['imageUrl']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Remove item from cart
                            FirebaseFirestore.instance
                                .collection('cart')
                                .doc(document.id)
                                .delete()
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                    Text('Item removed from cart')),
                              );
                            }).catchError((error) {
                              print(
                                  "Failed to remove item from cart: $error");
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // No Spacer() here
                Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFDACABF),
                    borderRadius: BorderRadius.circular(
                        15.0), // Rounded edges
                    border: Border.all(
                        color: Colors.black,
                        width: 2.0), // Border color and width
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Price: \$${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 20.0),
                      const Text(
                        'Tax: \$50.00', // Assuming fixed tax amount
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 20.0),
                      const Text(
                        'Shipping: \$50.00', // Assuming fixed shipping cost
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 20.0),
                      const Divider(
                        color: Colors.black,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Total Price: \$${(totalPrice + 50 + 50).toStringAsFixed(2)}', // Adding tax and shipping
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => checkOutOrder(totalPrice),
                  child: const Text('Checkout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  //Functions Here!
  double calculateTotalPrice(QuerySnapshot snapshot) {
    totalPrice = 0;
    for (var document in snapshot.docs) {
      totalPrice += document['price'];
    }
    return totalPrice;
  }
  Future<void> checkOutOrder(double totalPrice) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;

      try {
        // Get the current timestamp
        Timestamp timestamp = Timestamp.now();

        // Collect information about the products in the cart
        List<Map<String, dynamic>> products = [];
        await FirebaseFirestore.instance
            .collection('cart')
            .where('uid', isEqualTo: uid)
            .get()
            .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            Map<String, dynamic> productData = {
              'imageUrl': doc['imageUrl'],
              'totalPrice': doc['price'],
              'name': doc['name'],
            };
            products.add(productData);
          }
        });

        // Add the order to the 'orders' collection
        await FirebaseFirestore.instance.collection('orders').add({
          'uid': uid,
          'timestamp': timestamp,
          'products': products,
          'totalPrice': totalPrice,
        });

        // Clear the cart after placing the order
        await FirebaseFirestore.instance
            .collection('cart')
            .where('uid', isEqualTo: uid)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });

        // Show a SnackBar to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order Completed')),
        );
      } catch (error) {
        // Handle errors
        print("Failed to place your order: $error");
      }
    }
  }

}
