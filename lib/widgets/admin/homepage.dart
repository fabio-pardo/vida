import 'package:flutter/material.dart';
import 'package:vida/models/meal.dart';
import 'package:vida/services/firebase_firestore.dart';
import 'package:vida/widgets/admin/navbar.dart' show NavBar;

class AdminHomePage extends StatelessWidget {
  final VoidCallback signOutCallback;

  const AdminHomePage({super.key, required this.signOutCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Screen'),
        backgroundColor: Colors.green[400],
      ),
      body: FutureBuilder<List<Meal>>(
        future: getMeals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Meal>? meals = snapshot.data;
            if (meals != null && meals.isNotEmpty) {
              return ListView.builder(
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  Meal meal = meals[index];
                  return ListTile(
                    title: Text(meal.name),
                    subtitle: Text(meal.description),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(meal.imageUrl),
                    ),
                    trailing: Text('\$${meal.price.toStringAsFixed(2)}'),
                  );
                },
              );
            } else {
              return const Center(child: Text('No meals available.'));
            }
          }
        },
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: const [
                  SizedBox(
                    height: 115,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.red,
                      ),
                      margin: EdgeInsets.all(0.0),
                      padding: EdgeInsets.all(0.0),
                      child: null,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                signOutCallback();
              },
            ),
            const SizedBox(height: 26),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
