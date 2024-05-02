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
    print('ID: $id');
    print('Name: $name');
    print('Description: $description');
    print('Price: $price');
    print('Image URL: $imageUrl');
  }
}
