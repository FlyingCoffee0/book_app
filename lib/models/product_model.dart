import 'package:dio/dio.dart';

class Product {
  final int id;
  final String name;
  final double price;
  final String fileName;
  final String? description; // Eklenen alan
  String? _coverImage;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.fileName,
    this.description, // Eklenen alan
  });

  Future<String?> get coverImage async {
    if (_coverImage == null) {
      _coverImage = await fetchImageUrl(fileName);
    }
    return _coverImage;
  }

  static Future<String?> fetchImageUrl(String fileName) async {
    try {
      final response = await Dio().post(
        "https://assign-api.piton.com.tr/api/rest/cover_image",
        data: {"fileName": fileName},
      );
      if (response.statusCode == 200 && response.data["action_product_image"] != null) {
        return response.data["action_product_image"]["url"];
      } else {
        return null;
      }
    } catch (e) {
      print("Failed to fetch image URL for $fileName: $e");
      return null;
    }
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      fileName: json['cover'],
      description: json['description'], // API'den gelen "description" alanını alıyoruz
    );
  }
}
