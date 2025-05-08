import 'package:vida/utils/logger.dart';

class Meal {
  Meal({
    required this.id,
    required this.name,
    required this.price,
    this.description = '',
    this.imageUrl = '',
    this.createdAt,
  });

  final int id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final DateTime? createdAt;

  void printDetails() {
    log.i("""
      ID: $id, 
      Name: $name, 
      Description: $description, 
      Price: $price, 
      Image Url: $imageUrl
      """);
  }

  // Factory constructor to create a Meal from JSON data
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      price: json['price'] is int ? (json['price'] as int).toDouble() : json['price'],
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  // Convert a Meal instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  // Create a copy of this Meal with modified fields
  Meal copyWith({
    int? id,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
