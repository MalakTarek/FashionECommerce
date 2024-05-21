import 'package:fashion_ecommerce/products_page.dart';
import 'package:flutter/material.dart';
import 'package:fashion_ecommerce/sign_up.dart';
import 'package:fashion_ecommerce/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Allproducts.dart';
import 'homepageDesign.dart';

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
        '/viewProducts': (context) => ProductListScreen(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('A7a'),
      ),
      body: CustomDesign(),
    );
  }
}
