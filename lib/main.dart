import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vida/widgets/auth/auth.dart';
import 'package:vida/services/api_service.dart';

// Provider for the API service
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Vida Meals',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const AuthPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
