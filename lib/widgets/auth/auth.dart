import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vida/widgets/auth/signin.dart';
import 'package:vida/widgets/auth/signout.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  User? _user;

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(signInCallback: _signIn);
    } else {
      return SignOutPage(signOutCallback: _signOut);
    }
  }

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
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test_customer@vida.com',
        password: 'test1234',
      );
      _checkCurrentUser();
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    _checkCurrentUser();
  }
}
