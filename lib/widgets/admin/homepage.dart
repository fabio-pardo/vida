import 'package:flutter/material.dart';
import 'package:vida/models/meal.dart';
import 'package:vida/services/firebase_firestore.dart';

class AdminMealsPage extends StatefulWidget {
  const AdminMealsPage({super.key});
  @override
  State<StatefulWidget> createState() => _AdminMealsPageState();
}

class _AdminMealsPageState extends State<AdminMealsPage> {
  Set<String> selectedMeals = {};
  void toggleSelectedMeals(String mealID) {
    setState(() {
      if (selectedMeals.contains(mealID)) {
        selectedMeals.remove(mealID);
      } else {
        if (selectedMeals.length < 5) {
          selectedMeals.add(mealID);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Meal>>(
        future: getMeals(),
        builder: (context, snapshot) {
          List<Meal>? meals = snapshot.data;
          if (meals != null && meals.isNotEmpty) {
            return ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                Meal meal = meals[index];
                return ListTile(
                  title: Text(meal.name),
                  subtitle: Text(meal.description),
                  leading: selectedMeals.contains(meal.id)
                      ? const Icon(Icons.check_circle)
                      : CircleAvatar(
                          backgroundImage: NetworkImage(meal.imageUrl),
                        ),
                  trailing: Text('\$${meal.price.toStringAsFixed(2)}'),
                  onTap: () => toggleSelectedMeals(meal.id),
                );
              },
            );
          } else {
            return const Center(
                child: Text('No meals available. Want to create Some?'));
          }
        },
      ),
      floatingActionButton: Visibility(
        visible: selectedMeals.isNotEmpty,
        child: FloatingActionButton(
          onPressed: () {
            addMenu(selectedMeals);
          },
          child: const Icon(Icons.check),
        ),
      ),
    );
  }
}

class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('No meals available. Want to create Some?'),
    ));
  }
}
