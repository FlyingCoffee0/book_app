class Product {
  final int id;
  final String name;
  final double price;
  final String coverImage;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.coverImage,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      price: double.parse(json["price"].toString()),
      coverImage: json["cover_image"],
    );
  }
}
