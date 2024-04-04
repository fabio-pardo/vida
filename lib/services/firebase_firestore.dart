import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vida/models/meal.dart';

Future<void> addMeal(Meal meal) async {
  CollectionReference meals = FirebaseFirestore.instance.collection('meals');
  // Add a new document with a generated id.
  await meals.add({
    'description': meal.description,
    'imageUrl': meal.imageUrl,
    'name': meal.name,
    'price': meal.price,
  });
}

Future<List<Meal>> getMeals() async {
  CollectionReference meals = FirebaseFirestore.instance.collection('meals');
  QuerySnapshot querySnapshot = await meals.get();
  List<Meal> mealsList = querySnapshot.docs.map((DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return Meal(
      description: data['description'],
      imageUrl: data['imageUrl'],
      name: data['name'],
      price: data['price'],
    );
  }).toList();
  return mealsList;
}
