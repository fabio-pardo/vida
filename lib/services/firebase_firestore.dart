import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vida/models/meals.dart';

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

