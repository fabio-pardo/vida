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
    return makeMeal(document, data);
  }).toList();
  return mealsList;
}

Meal makeMeal(DocumentSnapshot<Object?> document, Map<String, dynamic> data) {
  return Meal(
    id: document.id,
    description: data['description'],
    imageUrl: data['imageUrl'],
    name: data['name'],
    price: data['price'],
  );
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

Future<Meal> getMeal(String mealId) async {
  DocumentSnapshot mealDoc =
      await FirebaseFirestore.instance.collection('meals').doc(mealId).get();
  if (mealDoc.exists) {
    Map<String, dynamic> mealData = mealDoc.data() as Map<String, dynamic>;
    return makeMeal(mealDoc, mealData);
  }
  throw Exception('Meal not found');
}

// Get menus from Firestore and return them with their list of meals
Future<List<Future<Map<String, Object>>>> getMenus() async {
  CollectionReference menus = FirebaseFirestore.instance.collection('menus');
  QuerySnapshot querySnapshot = await menus.get();
  // Get the list of menus
  // For each menu, get the list of meals
  // Return the list of menus with their list of meals
  List<Future<Map<String, Object>>> menusList =
      querySnapshot.docs.map((DocumentSnapshot document) async {
    Map<String, dynamic> menuData = document.data() as Map<String, dynamic>;
    List<Meal> meals = [];
    for (String mealId in menuData['meals']) {
      meals.add(await getMeal(mealId));
    }
    return {
      'id': document.id,
      'meals': meals,
    };
  }).toList();
  return menusList;
}
