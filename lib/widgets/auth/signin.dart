import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  final VoidCallback signInCallback;

  const SignInPage({super.key, required this.signInCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignInPage Widget'),
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
