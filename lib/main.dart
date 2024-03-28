import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'vida-meals',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vida Meals',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    setState(() {
      _user = FirebaseAuth.instance.currentUser;
    });
  }

  void _signIn() async {
    // Perform sign in with Firebase
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test_customer@vida.com',
        password: 'test1234',
      );
      _checkCurrentUser();
    } catch (e) {
      log("Error signing in: $e");
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    _checkCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(signInCallback: _signIn);
    } else {
      return HomePage(signOutCallback: _signOut);
    }
  }
}

class SignInPage extends StatelessWidget {
  final VoidCallback signInCallback;

  const SignInPage({super.key, required this.signInCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: signInCallback,
          child: const Text('Sign In'),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback signOutCallback;

  const HomePage({super.key, required this.signOutCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vida Meals'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: signOutCallback,
          child: Text('Sign Out'),
        ),
      ),
    );
  }
}
