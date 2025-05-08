import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vida/models/meal.dart';
import 'package:vida/models/menu.dart';
import 'package:vida/main.dart';
import 'package:vida/services/api_service.dart';

class AdminMealsPage extends ConsumerStatefulWidget {
  const AdminMealsPage({super.key});
  @override
  ConsumerState<AdminMealsPage> createState() => _AdminMealsPageState();
}

class _AdminMealsPageState extends ConsumerState<AdminMealsPage> {
  Set<int> selectedMeals = {};

  void toggleSelectedMeals(int mealID) {
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
    final apiService = ref.watch(apiServiceProvider);
    
    return Scaffold(
      body: FutureBuilder<List<Meal>>(
        future: apiService.getMeals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No meals available. Want to create Some?',
              ),
            );
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
            final apiService = ref.read(apiServiceProvider);
            // Create a new menu with the selected meals
            final now = DateTime.now();
            final newMenu = Menu(
              id: 0, // Backend will assign an actual ID
              name: 'Menu ${now.day}/${now.month}/${now.year}',
              description: 'Created on ${now.day}/${now.month}/${now.year}',
              weekStartDate: now,
              weekEndDate: now.add(const Duration(days: 7)),
              mealIds: selectedMeals.toList(),
            );
            apiService.createMenu(newMenu);
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
  final apiService = ProviderScope.containerOf(context).read(apiServiceProvider);
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
                    // Handle the submission of the new meal using our API service
                    apiService.createMeal(
                      Meal(
                        id: 0, // Backend will assign an actual ID
                        name: nameController.text,
                        description: descriptionController.text,
                        imageUrl: 'https://example.com/placeholder-meal-image.jpg',
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

class AdminMenuPage extends ConsumerStatefulWidget {
  const AdminMenuPage({super.key});

  @override
  ConsumerState<AdminMenuPage> createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends ConsumerState<AdminMenuPage> {
  @override
  Widget build(BuildContext context) {
    final apiService = ref.watch(apiServiceProvider);
    
    return FutureBuilder<List<Menu>>(
      future: apiService.getMenus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading menus: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No menus available'));
        }
        
        final menus = snapshot.data!;
        return ListView.builder(
          itemCount: menus.length,
          itemBuilder: (context, index) {
            final menu = menus[index];
            return ExpansionTile(
              title: Text(menu.name),
              subtitle: Text('${menu.weekStartDate.toLocal().toString().split(' ')[0]} to ${menu.weekEndDate.toLocal().toString().split(' ')[0]}'),
              children: [
                Text(menu.description),
                MenuMealsWidget(meals: menu.meals),
              ],
            );
          },
        );
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
