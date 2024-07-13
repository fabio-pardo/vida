import 'package:vida/models/meal.dart';
import 'package:vida/utils/logger.dart';

class Menu {
  Menu({this.meals = const <Meal>[]});

  final List<Meal> meals;

  void printMenu() {
    log.i('Menu: Bon Appétit!');
    for (final Meal meal in meals) {
      log.i('-----------------------');
      meal.printDetails();
    }
  }
}
