import 'package:vida/models/meal.dart';

class Menu {
  Menu({this.meals = const <Meal>[]});

  final List<Meal> meals;

  void printMenu() {
    print('Menu: Bon Appétit!');
    for (final Meal meal in meals) {
      print('-----------------------');
      meal.printDetails();
    }
  }
}
