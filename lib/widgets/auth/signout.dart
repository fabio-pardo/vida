import 'package:flutter/material.dart';

class SignOutPage extends StatelessWidget {
  final VoidCallback signOutCallback;

  const SignOutPage({super.key, required this.signOutCallback});

  @override
  Widget build(BuildContext context) {
    const String appBarTitle = 'SignOutPage Widget';
    return Scaffold(
      appBar: AppBar(
        title: const Text(appBarTitle),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: signOutCallback,
          child: const Text('Sign Out'),
        ),
      ),
    );
  }
}
