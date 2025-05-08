import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vida/utils/logger.dart';
import 'package:vida/widgets/admin/navbar.dart';
import 'package:vida/widgets/auth/signin.dart';
import 'package:vida/widgets/auth/signout.dart';
import 'package:vida/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends ConsumerState<AuthPage> {
  bool _isAuthenticated = false;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return SignInPage(signInCallback: _signIn);
    }

    // For now, we'll just assume all authenticated users are admins
    // This can be expanded later with proper role management
    return AdminHomePage(signOutCallback: _signOut);
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasToken = prefs.containsKey('session_token');
    
    setState(() {
      _isAuthenticated = hasToken;
      // For now, we'll assume all authenticated users are admins
      _userRole = hasToken ? 'admin' : null;
    });
  }

  void _signIn() async {
    try {
      final apiService = ref.read(apiServiceProvider);
      // In a real app, this would open a web browser for OAuth
      // and handle the callback URL
      final authUrl = await apiService.getGoogleAuthUrl();
      log.i("Got auth URL: $authUrl");
      
      // Simulate successful authentication
      // In a real app, you would use the authUrl to redirect the user
      // and then process the callback
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('session_token', 'temp_session_token');
      await _checkAuthStatus();
      log.i("Logged User In");
    } catch (e) {
      log.e("Error occurred during sign in: $e");
    }
  }

  void _signOut() async {
    try {
      final apiService = ref.read(apiServiceProvider);
      await apiService.logout();
      await _checkAuthStatus();
      log.i("Logged User Out");
    } catch (e) {
      log.e("Error occurred during sign out: $e");
    }
  }
}
