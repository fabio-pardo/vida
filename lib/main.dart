import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vida/models/meal.dart';
import 'package:vida/models/menu.dart';
import 'package:vida/services/firebase_firestore.dart';
import 'package:vida/services/firebase_options.dart';
import 'package:vida/services/firebase_storage.dart'
    show uploadImageToFirebaseStorage;
import 'package:vida/utils/utils.dart' show prepareImageFile;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with the default options
  // before using the Firebase services
  await Firebase.initializeApp(
    name: 'vida-meals',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vida Meals',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const _AuthPage(),
    );
  }
}

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

class SignOutPage extends StatelessWidget {
  final VoidCallback signOutCallback;

  const SignOutPage({super.key, required this.signOutCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignOutPage Widget'),
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

class _AuthPage extends StatefulWidget {
  const _AuthPage();

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<_AuthPage> {
  User? _user;

  @override
  Widget build(BuildContext context) {
    //_testAddingMeal();
    _testGettingMeals();
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

  void _testAddingMeal() async {
    File imageFile = await prepareImageFile('assets/chicken_parm.png');
    String downloadUrl = await uploadImageToFirebaseStorage(
      imageFile,
      "lasagna",
    );
    print(downloadUrl);
    Meal meal = Meal(
      description: 'A delicious meal',
      imageUrl: downloadUrl,
      name: 'Lasagna',
      price: 15.99,
    );
    await addMeal(meal);
    print("Added meal");
  }

  void _testGettingMeals() async {
    List<Meal> meals = await getMeals();
    Menu menu = Menu(meals: meals);
    menu.printMenu();
  }
}
