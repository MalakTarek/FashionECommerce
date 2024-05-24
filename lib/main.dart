<<<<<<< Updated upstream
import 'package:fashion_ecommerce/products_page.dart';
=======
import 'package:fashion_ecommerce/Products/products_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
>>>>>>> Stashed changes
import 'package:flutter/material.dart';
import 'package:fashion_ecommerce/Registration/sign_up.dart';
import 'package:fashion_ecommerce/Registration/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
<<<<<<< Updated upstream
import 'Allproducts.dart';
import 'homepageDesign.dart';
=======
import 'Products/ViewProductsForNotLoggedInUsers.dart';
import 'Design/homepageDesign.dart';
>>>>>>> Stashed changes

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();

    // Initialize Firebase Messaging
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    print("FCM Token: $token");

    // Check token expiration and run the app accordingly
    bool isSignedIn = await checkTokenExpiration();
    runApp(MyApp(isSignedIn: isSignedIn));
  } catch (e) {
    // Handle initialization error
    print('Error initializing Firebase: $e');
    runApp(MyApp(isSignedIn: false));
  }
}

Future<bool> checkTokenExpiration() async {
  final prefs = await SharedPreferences.getInstance();
  String? expirationTimeString = prefs.getString('expirationTime');

  if (expirationTimeString != null) {
    DateTime expirationTime = DateTime.parse(expirationTimeString);

    if (expirationTime.isAfter(DateTime.now())) {
      return true;
<<<<<<< Updated upstream
=======
    }else {
      await FirebaseAuth.instance.signOut();

>>>>>>> Stashed changes
    }
  }
  return false;
}

class MyApp extends StatelessWidget {
  final bool isSignedIn;

  MyApp({required this.isSignedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isSignedIn ? const ProductsPage() : HomePage(), // Conditional initial route
      routes: {
        '/signUp': (context) => SignUpPage(),
        '/signIn': (context) => SignInPage(),
<<<<<<< Updated upstream
        '/viewProducts': (context) => ProductListScreen(),
=======
        '/viewProducts': (context) => ProductListScreenDesign(),
>>>>>>> Stashed changes
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< Updated upstream
        title: Text('A7a'),
=======
        title: Text('Fashion E-Commerece'),
>>>>>>> Stashed changes
      ),
      body: CustomDesign(),
    );
  }
}



