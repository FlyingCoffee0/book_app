import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/catalog_service.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'package:dio/dio.dart';

// Dio provider
final dioProvider = Provider((ref) => Dio());

// ApiService provider
final apiServiceProvider = Provider((ref) => ApiService(ref.read(dioProvider)));

// StorageService provider
final storageServiceProvider = Provider((ref) => StorageService());

// CatalogService provider
final catalogServiceProvider = Provider((ref) {
  final apiService = ref.read(apiServiceProvider);
  final storageService = ref.read(storageServiceProvider);
  return CatalogService(apiService, storageService);
});
