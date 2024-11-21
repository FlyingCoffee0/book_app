import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:piton_books/models/category_model.dart';
import 'package:piton_books/services/api_service.dart';
import 'package:piton_books/services/catalog_service.dart';
import 'package:piton_books/services/storage_service.dart';
import 'catalog_service_test.mocks.dart';

@GenerateMocks([ApiService, StorageService])
void main() {
  late MockApiService mockApiService;
  late MockStorageService mockStorageService;
  late CatalogService catalogService;

  setUp(() {
    mockApiService = MockApiService();
    mockStorageService = MockStorageService();
    catalogService = CatalogService(mockApiService, mockStorageService);
  });

  group("CatalogService", () {
    test("getCategories: should fetch categories from API when no cache exists", () async {
      // Mock Cache Yanıtı (readData boş dönecek)
      when(mockStorageService.readData('categories')).thenAnswer((_) async => null);
      when(mockStorageService.readData('categories_timestamp')).thenAnswer((_) async => null);

      // Mock API Yanıtı
      final mockResponse = Response(
        data: {
          "category": [
            {"id": 1, "name": "Category 1"},
            {"id": 2, "name": "Category 2"},
          ],
        },
        requestOptions: RequestOptions(path: 'categories'),
      );

      when(mockApiService.get("categories"))
          .thenAnswer((_) async => Future.value(mockResponse));

      final result = await catalogService.getCategories();

      // Doğrulamalar
      expect(result.length, 2);
      expect(result[0].name, "Category 1");
      verify(mockApiService.get("categories")).called(1);
      verify(mockStorageService.saveData(any, any)).called(2); // Cache için çağrılar
    });

    test("getCategories: should fetch categories from cache when available", () async {
      // Mock Cache Yanıtı
      final mockCache = [
        {"id": 1, "name": "Cached Category 1"},
        {"id": 2, "name": "Cached Category 2"},
      ];

      final mockTimestamp = DateTime.now().toIso8601String();

      when(mockStorageService.readData('categories')).thenAnswer((_) async => mockCache);
      when(mockStorageService.readData('categories_timestamp')).thenAnswer((_) async => mockTimestamp);

      final result = await catalogService.getCategories();

      // Doğrulamalar
      expect(result.length, 2);
      expect(result[0].name, "Cached Category 1");
      verifyNever(mockApiService.get("categories")); // API çağrısı yapılmamalı
    });
  });
}
