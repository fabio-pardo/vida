import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vida/services/firebase_firestore.dart';
import 'package:vida/utils/logger.dart';
import 'package:vida/widgets/admin/navbar.dart';
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
  void initState() {
    super.initState();
    _initializePage();
  }

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

  Future<void> _initializePage() async {
    await _initializeCurrentUser();
  }

  Future<void> _initializeCurrentUser() async {
    setState(() {
      _user = FirebaseAuth.instance.currentUser;
    });
    await getUserRole(_user!.uid, _setUserRole);
  }

  void _setUserRole(dynamic userRole) {
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
      log.i("Logged User In");
    } catch (e) {
      log.e("Error occurred: $e");
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    await _initializeCurrentUser();
  }
}
