import 'package:vida/models/meal.dart';

class Menu {
  Menu({this.meals = const <Meal>[]});

  final List<Meal> meals;

  void printDetails() {
    for (final Meal meal in meals) {
      meal.printDetails();
    }
  }
}
