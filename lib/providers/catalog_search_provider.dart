import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../services/catalog_service.dart';
import 'providers.dart';

// Arama sorgusu için StateProvider
final searchQueryProvider = StateProvider<String>((ref) => "");

// Kategorilerde arama için FutureProvider
final filteredCategoriesProvider = FutureProvider<List<Category>>((ref) {
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final catalogService = ref.watch(catalogServiceProvider);

  return catalogService.getCategories().then(
    (categories) => categories
        .where((category) => category.name.toLowerCase().contains(searchQuery))
        .toList(),
  );
});

// Ürünlerde arama için FutureProvider
final filteredProductsProvider = FutureProvider.autoDispose.family<List<Product>, int>((ref, categoryId) {
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final catalogService = ref.watch(catalogServiceProvider);

  return catalogService.getProductsByCategory(categoryId).then(
    (products) => products
        .where((product) => product.name.toLowerCase().contains(searchQuery))
        .toList(),
  );
});
