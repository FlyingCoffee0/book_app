import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:piton_books/services/auth_service.dart';
import 'package:piton_books/services/catalog_service.dart';
import 'package:piton_books/services/image_service.dart';
import 'package:piton_books/services/storage_service.dart';
import '../services/api_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => ApiService(getIt<Dio>()));
  getIt.registerLazySingleton(() => AuthService(getIt<ApiService>()));
  getIt.registerLazySingleton(() => StorageService()); 
  getIt.registerLazySingleton(() => CatalogService(getIt<ApiService>(), getIt<StorageService>()));
  getIt.registerLazySingleton(() => ImageService(getIt<Dio>()));
}
