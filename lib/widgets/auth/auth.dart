import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vida/services/firebase_firestore.dart';
import 'package:vida/widgets/admin/homepage.dart';
import 'package:vida/widgets/auth/signin.dart';
import 'package:vida/widgets/auth/signout.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  User? _user;
  String? _userRole;

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(signInCallback: _signIn);
    }
    switch (_userRole) {
      case "admin":
        return AdminHomePage(signOutCallback: _signOut);
      default:
    }
    return SignOutPage(signOutCallback: _signOut);
  }

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    await _checkCurrentUser();
    if (_user != null) {
      await getUserRole(_user!.uid, _checkUserRole);
    }
  }

  Future<void> _checkCurrentUser() async {
    setState(() {
      _user = FirebaseAuth.instance.currentUser;
    });
  }

  void _checkUserRole(userRole) {
    setState(() {
      _userRole = userRole;
    });
  }

  void _signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test_admin@vida.com',
        password: 'test1234',
      );
      _initializePage();
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    await _checkCurrentUser();
    _userRole = null;
  }
}
