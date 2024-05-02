import 'package:flutter/material.dart';
import 'package:vida/models/meal.dart';
import 'package:vida/services/firebase_firestore.dart';
import 'package:vida/widgets/admin/navbar.dart' show NavBar;

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key, required this.signOutCallback});
  final VoidCallback signOutCallback;
  @override
  State<StatefulWidget> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  Set<String> selectedMeals = {};
  void toggleSelectedMeals(String mealID) {
    setState(() {
      if (selectedMeals.contains(mealID)) {
        selectedMeals.remove(mealID);
      } else {
        selectedMeals.add(mealID);
      }
    });
  }

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
                    onTap: () => toggleSelectedMeals(meal.id),
                  );
                },
              );
            } else {
              return const Center(child: Text('No meals available.'));
            }
          }
        },
      ),
      drawer: MyDrawer(widget: widget),
      bottomNavigationBar: const NavBar(),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
    required this.widget,
  });

  final AdminHomePage widget;

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              widget.signOutCallback();
            },
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }
}
