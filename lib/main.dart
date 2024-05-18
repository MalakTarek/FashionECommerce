import 'package:flutter/material.dart';
import 'package:fashion_ecommerce/sign_up.dart';
import 'package:fashion_ecommerce/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Allproducts.dart';
import 'homepageDesign.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Handle initialization error
    print('Error initializing Firebase: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
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
        title: Text('Welcome'),
      ),
      body: CustomDesign(),
    );
  }
}
