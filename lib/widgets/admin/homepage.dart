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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No meals available. Want to create Some?'));
          } else {
            List<Meal>? meals = snapshot.data;
            return ListView.builder(
              itemCount: meals!.length,
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            showAddMealModal(context, () {
              setState(() {}); // Trigger a refresh of the FutureBuilder
            });
          },
          child: const Text('Make a new meal'),
        ),
      ),
    );
  }
}

void showAddMealModal(BuildContext context, VoidCallback onAddMeal) {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add New Meal',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Meal Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a meal name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Meal Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a meal description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Meal Price',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a meal price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Handle the submission of the new meal
                    addMeal(
                      Meal(
                        id: 'null',
                        name: nameController.text,
                        description: descriptionController.text,
                        imageUrl:
                            'https://firebasestorage.googleapis.com/v0/b/vida-meals.appspot.com/o/lasagna?alt=media&token=4fb7d92d-5b87-4dae-84b5-26dcb7868e32',
                        price: double.parse(priceController.text),
                      ),
                    ).then((_) {
                      Navigator.pop(context); // Close the modal
                      onAddMeal(); // Trigger the callback to refresh data
                    });
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  @override
  Widget build(BuildContext context) {
    var menus = getMenus();
    return FutureBuilder(
      future: menus,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Future<Map<String, Object>>>? menuFutures = snapshot.data;
          return ListView.builder(
            itemCount: menuFutures?.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: menuFutures?[index],
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, Object>? menuData = snapshot.data;
                    List<Meal> meals = menuData?['meals'] as List<Meal>;
                    return ExpansionTile(
                      title: Text('Menu ${index + 1}'),
                      children: [
                        MenuMealsWidget(meals: meals),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              );
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class MenuMealsWidget extends StatelessWidget {
  final List<Meal> meals;
  const MenuMealsWidget({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: meals.length * 100.0, // Assuming each item has a height of 50.0
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
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
      ),
    );
  }
}
