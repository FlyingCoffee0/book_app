import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/catalog_service.dart';
import '../services/storage_service.dart';
import '../services/image_service.dart';

// Dio Provider
final dioProvider = Provider<Dio>((ref) => Dio());

// ApiService Provider
final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.read(dioProvider);
  return ApiService(dio);
});

// AuthService Provider
final authServiceProvider = Provider<AuthService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return AuthService(apiService);
});

// StorageService Provider
final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

// CatalogService Provider
final catalogServiceProvider = Provider<CatalogService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  final storageService = ref.read(storageServiceProvider);
  return CatalogService(apiService, storageService);
});

// ImageService Provider
final imageServiceProvider = Provider<ImageService>((ref) {
  final dio = ref.read(dioProvider);
  return ImageService(dio);
});
