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
      id: document.id,
      description: data['description'],
      imageUrl: data['imageUrl'],
      name: data['name'],
      price: data['price'],
    );
  }).toList();
  return mealsList;
}

Future<void> getUserRole(String uid, Function(String) callback) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    DocumentSnapshot documentSnapshot = await users.doc(uid).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> userData =
          documentSnapshot.data() as Map<String, dynamic>;
      callback(userData["role"]);
    } else {
      print('No user found with the specified UID: $uid');
    }
  } catch (e) {
    print('Error retrieving user data: $e');
  }
}

Future<void> addMenu(Set<String> meals) async {
  // Add a set of meal ids to a menu
  CollectionReference menus = FirebaseFirestore.instance.collection('menus');

  await menus.add({
    'meals': meals,
  });
}
