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

Future<Map<String, dynamic>> getMeal(String mealId) async {
  DocumentSnapshot mealDoc =
      await FirebaseFirestore.instance.collection('meals').doc(mealId).get();
  if (mealDoc.exists) {
    Map<String, dynamic> mealData = mealDoc.data() as Map<String, dynamic>;
    return mealData;
  }
  return {};
}

Future<List<Map<String, dynamic>>> getMenus() async {
  CollectionReference menus = FirebaseFirestore.instance.collection("menus");
  QuerySnapshot menusSnapshot = await menus.get();

  Map<String, Map<String, dynamic>> mealCache = {};
  List<Map<String, dynamic>> menusList = [];

  for (QueryDocumentSnapshot menuDoc in menusSnapshot.docs) {
    Map<String, dynamic> menuData = menuDoc.data() as Map<String, dynamic>;
    List<String> mealIDs = List<String>.from(
        menuData['meals']); // Ensure mealIDs is a list of strings

    List<Future<Map<String, dynamic>>> mealFutures =
        mealIDs.map((mealID) async {
      if (mealCache.containsKey(mealID)) {
        return mealCache[mealID]!;
      }
      Map<String, dynamic> mealData = await getMeal(mealID);
      mealCache[mealID] = mealData;
      return mealData;
    }).toList();

    List<Map<String, dynamic>> mealsData = await Future.wait(mealFutures);

    // Replace the meal IDs with the actual meal data
    menuData['meals'] = mealsData;
    menusList.add(menuData);
  }

  return menusList;
}
