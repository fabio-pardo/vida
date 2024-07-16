import 'package:vida/utils/logger.dart';

class Meal {
  Meal({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.name,
    required this.price,
  });

  final String id;
  final String description;
  final String imageUrl;
  final String name;
  final double price;

  void printDetails() {
    log.i("""
      ID: $id, 
      Name: $name, 
      Description: $description, 
      Price: $price, 
      Image Url: $imageUrl
      """);
  }
}
