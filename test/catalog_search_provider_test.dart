import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piton_books/models/category_model.dart';
import 'package:piton_books/models/product_model.dart';
import 'package:piton_books/providers/catalog_search_provider.dart';
import 'package:piton_books/providers/providers.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:piton_books/services/catalog_service.dart';

import 'catalog_search_provider_test.mocks.dart';


@GenerateMocks([CatalogService])
void main() {
  late MockCatalogService mockCatalogService;

  setUp(() {
    mockCatalogService = MockCatalogService();
  });

  group('Search Query Provider', () {
    test('searchQueryProvider updates correctly', () {
      final container = ProviderContainer();
      expect(container.read(searchQueryProvider), "");

      container.read(searchQueryProvider.notifier).state = "Flutter";
      expect(container.read(searchQueryProvider), "Flutter");
    });
  });

  group('Filtered Categories Provider', () {
    test('filteredCategoriesProvider filters categories correctly', () async {
      final categories = [
        Category(id: 1, name: "Best Seller"),
        Category(id: 2, name: "Classics"),
        Category(id: 3, name: "Photography"),
      ];

      when(mockCatalogService.getCategories()).thenAnswer((_) async => categories);

      final container = ProviderContainer(overrides: [
        catalogServiceProvider.overrideWithValue(mockCatalogService),
      ]);

      container.read(searchQueryProvider.notifier).state = "Pro";
      final result = await container.read(filteredCategoriesProvider.future);

      expect(result.length, 1);
      expect(result[0].name, "Programming");
    });
  });

  group('Filtered Products Provider', () {
    test('filteredProductsProvider filters products correctly by query', () async {
      final products = [
        Product(id: 1, name: "Flutter Guide", price: 20.0, fileName: "flutter.jpg"),
        Product(id: 2, name: "Dart Tips", price: 15.0, fileName: "dart.jpg"),
        Product(id: 3, name: "React Handbook", price: 25.0, fileName: "react.jpg"),
      ];

      when(mockCatalogService.getProductsByCategory(1)).thenAnswer((_) async => products);

      final container = ProviderContainer(overrides: [
        catalogServiceProvider.overrideWithValue(mockCatalogService),
      ]);

      container.read(searchQueryProvider.notifier).state = "Flutter";
      final result = await container.read(filteredProductsProvider(1).future);

      expect(result.length, 1);
      expect(result[0].name, "Flutter Guide");
    });

    test('filteredProductsProvider returns empty list for no match', () async {
      final products = [
        Product(id: 1, name: "Flutter Guide", price: 20.0, fileName: "flutter.jpg"),
        Product(id: 2, name: "Dart Tips", price: 15.0, fileName: "dart.jpg"),
      ];

      when(mockCatalogService.getProductsByCategory(1)).thenAnswer((_) async => products);

      final container = ProviderContainer(overrides: [
        catalogServiceProvider.overrideWithValue(mockCatalogService),
      ]);

      container.read(searchQueryProvider.notifier).state = "Python";
      final result = await container.read(filteredProductsProvider(1).future);

      expect(result.length, 0);
    });
  });
}
