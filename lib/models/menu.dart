import 'package:vida/models/meal.dart';

class Menu {
  Menu({
    required this.id,
    required this.name,
    required this.weekStartDate,
    required this.weekEndDate,
    this.description = '',
    this.meals = const <Meal>[],
    this.mealIds = const <int>[],
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String description;
  final DateTime weekStartDate;
  final DateTime weekEndDate;
  final List<Meal> meals;
  final List<int> mealIds; // Used for POST/PUT operations
  final DateTime? createdAt;
  final DateTime? updatedAt;

  void printDetails() {
    print('Menu: $name - $description');
    print('Week: ${weekStartDate.toString()} to ${weekEndDate.toString()}');
    for (final Meal meal in meals) {
      meal.printDetails();
    }
  }

  // Factory constructor to create a Menu from JSON data
  factory Menu.fromJson(Map<String, dynamic> json) {
    List<Meal> menuMeals = [];
    if (json['menu_meals'] != null) {
      menuMeals = (json['menu_meals'] as List)
          .map((mealJson) => Meal.fromJson(mealJson['meal']))
          .toList();
    }

    return Menu(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      weekStartDate: DateTime.parse(json['week_start_date']),
      weekEndDate: DateTime.parse(json['week_end_date']),
      meals: menuMeals,
      mealIds: json['meal_ids'] != null 
        ? List<int>.from(json['meal_ids'])
        : [],
      createdAt: json['created_at'] != null 
        ? DateTime.parse(json['created_at']) 
        : null,
      updatedAt: json['updated_at'] != null 
        ? DateTime.parse(json['updated_at']) 
        : null,
    );
  }

  // Convert a Menu instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'week_start_date': weekStartDate.toIso8601String(),
      'week_end_date': weekEndDate.toIso8601String(),
      'meal_ids': mealIds,
    };
  }

  // Create a copy of this Menu with modified fields
  Menu copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    List<Meal>? meals,
    List<int>? mealIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Menu(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      weekEndDate: weekEndDate ?? this.weekEndDate,
      meals: meals ?? this.meals,
      mealIds: mealIds ?? this.mealIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
