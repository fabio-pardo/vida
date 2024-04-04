class Meal {
  Meal({
    this.description,
    required this.imageUrl,
    required this.name,
    required this.price,
  });

  final String? description;
  final String imageUrl;
  final String name;
  final double price;
}
