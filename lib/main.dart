import 'package:fashion_ecommerce/products_page.dart';
import 'package:fashion_ecommerce/Products/products_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fashion_ecommerce/Registration/sign_up.dart';
import 'package:fashion_ecommerce/Registration/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'Products/ViewProductsForNotLoggedInUsers.dart';
import 'Design/homepageDesign.dart';

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
    } else {
      await FirebaseAuth.instance.signOut();
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
      home: ConnectivityHandler(
        child: isSignedIn ? const ProductsPage() : HomePage(),
      ), // Conditional initial route
      routes: {
        '/signUp': (context) => SignUpPage(),
        '/signIn': (context) => SignInPage(),
        '/viewProducts': (context) => ProductListScreenDesign(),
      },
    );
  }
}

class ConnectivityHandler extends StatefulWidget {
  final Widget child;

  ConnectivityHandler({required this.child});

  @override
  _ConnectivityHandlerState createState() => _ConnectivityHandlerState();
}

class _ConnectivityHandlerState extends State<ConnectivityHandler> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        _showConnectionAlert();
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _showConnectionAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connection Error'),
        content: Text('Unable to connect to the server. Please check your internet connection.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fashion E-Commerce'),
      ),
      body: CustomDesign(),
    );
  }
}
