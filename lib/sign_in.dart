import 'package:fashion_ecommerce/products_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signIn(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      IdTokenResult? idTokenResult = await userCredential.user?.getIdTokenResult();
      if (idTokenResult != null) {
        String? token = idTokenResult.token;
        DateTime? issueTime = idTokenResult.issuedAtTime;
        DateTime? customExpirationTime = issueTime?.add(Duration(hours: 2));

        if (token != null && customExpirationTime != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('idToken', token);
          await prefs.setString('expirationTime', customExpirationTime.toIso8601String());

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Sign in successful!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProductsPage()),
                      );
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          _showErrorDialog(context, 'Failed to retrieve token information.');
        }
      } else {
        _showErrorDialog(context, 'Failed to retrieve token information.');
      }
    } catch (error) {
      String errorMessage = 'Failed to sign in. Please try again.';
      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          errorMessage = 'No user found with this email.';
        } else if (error.code == 'wrong-password') {
          errorMessage = 'Incorrect password.';
        }
      }
      _showErrorDialog(context, errorMessage);
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: SignInForm(signIn: signIn),
    );
  }
}

class SignInForm extends StatefulWidget {
  final Future<void> Function(BuildContext context, String email, String password) signIn;

  SignInForm({required this.signIn});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              final email = _emailController.text.trim();
              final password = _passwordController.text;
              await widget.signIn(context, email, password);
            },
            child: Text('Sign In'),
          ),
        ],
      ),
    );
  }
}

