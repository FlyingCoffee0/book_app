import 'package:dio/dio.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

class CatalogService {
  final ApiService _apiService;
  final StorageService _storageService;

  CatalogService(this._apiService, this._storageService);

  // Kategorileri çek ve cache'e kaydet
  Future<List<Category>> getCategories() async {
    final cacheKey = "categories";
    final cacheTimestampKey = "categories_timestamp";

    // Cache kontrolü
    final cachedData = await _storageService.readData(cacheKey);
    final cachedTimestamp = await _storageService.readData(cacheTimestampKey);

    if (cachedData != null && cachedTimestamp != null) {
      final cacheTime = DateTime.parse(cachedTimestamp);
      final now = DateTime.now();

      if (now.difference(cacheTime).inHours < 24) {
        // Cache geçerli
        return (cachedData as List).map((json) => Category.fromJson(json)).toList();
      }
    }

    // API'den çek ve cache'e kaydet
    final response = await _apiService.get("categories");
    final List data = response.data["categories"];
    await _storageService.saveData(cacheKey, data);
    await _storageService.saveData(cacheTimestampKey, DateTime.now().toIso8601String());

    return data.map((json) => Category.fromJson(json)).toList();
  }

  // Kategoriye göre ürünleri çek ve cache'e kaydet
  Future<List<Product>> getProductsByCategory(int categoryId) async {
    final cacheKey = "products_$categoryId";
    final cacheTimestampKey = "products_${categoryId}_timestamp";

    // Cache kontrolü
    final cachedData = await _storageService.readData(cacheKey);
    final cachedTimestamp = await _storageService.readData(cacheTimestampKey);

    if (cachedData != null && cachedTimestamp != null) {
      final cacheTime = DateTime.parse(cachedTimestamp);
      final now = DateTime.now();

      if (now.difference(cacheTime).inHours < 24) {
        // Cache geçerli
        return (cachedData as List).map((json) => Product.fromJson(json)).toList();
      }
    }

    // API'den çek ve cache'e kaydet
    final response = await _apiService.get("products/$categoryId");
    final List data = response.data["products"];
    await _storageService.saveData(cacheKey, data);
    await _storageService.saveData(cacheTimestampKey, DateTime.now().toIso8601String());

    return data.map((json) => Product.fromJson(json)).toList();
  }

  // Favorilere ekle
  Future<void> addToFavorites(int userId, int productId) async {
    await _apiService.post(
      "like",
      {
        "user_id": userId,
        "product_id": productId,
      },
    );
  }

  // Favorilerden çıkar
  Future<void> removeFromFavorites(int userId, int productId) async {
    await _apiService.post(
      "unlike",
      {
        "user_id": userId,
        "product_id": productId,
      },
    );
  }
     // Favorileri alma
  Future<List<Product>> getFavorites() async {
  final response = await _apiService.get("favorites");
  final List data = response.data["favorites"];
  return data.map((json) => Product.fromJson(json)).toList();
}
}
