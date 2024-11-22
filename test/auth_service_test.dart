import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:piton_books/services/auth_service.dart';
import 'package:piton_books/services/api_service.dart';
import 'auth_service_test.mocks.dart';

@GenerateMocks([ApiService, FlutterSecureStorage])
void main() {
  late MockApiService mockApiService;
  late MockFlutterSecureStorage mockStorage;
  late AuthService authService;

  setUp(() {
    mockApiService = MockApiService();
    mockStorage = MockFlutterSecureStorage();
    authService = AuthService(mockApiService, mockStorage);
  });

  group("AuthService", () {
    test("login: should save token on successful login", () async {
      // Mock API Yanıtı
      final mockResponse = Response(
        data: {
          "action_login": {
            "token": "test_token",
          },
        },
        requestOptions: RequestOptions(path: 'login'),
      );

      when(mockApiService.post("login", any)).thenAnswer((_) async => mockResponse);
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async => null);

      await authService.login("test@example.com", "password123", false);

      // Doğru API çağrısı yapıldığını doğrula
      verify(mockApiService.post("login", {
        "email": "test@example.com",
        "password": "password123",
      })).called(1);

      // Token kaydedildi mi kontrol et
      verify(mockStorage.write(key: "auth_token", value: "test_token")).called(1);
    });

    test("register: should call API with correct parameters", () async {
      when(mockApiService.post("register", any))
          .thenAnswer((_) async => Response(data: {}, requestOptions: RequestOptions(path: 'register')));

      await authService.register("Test User", "test@example.com", "password123");

      verify(mockApiService.post("register", {
        "name": "Test User",
        "email": "test@example.com",
        "password": "password123",
      })).called(1);
    });

    test("logout: should delete token", () async {
      when(mockStorage.delete(key: anyNamed('key'))).thenAnswer((_) async => null);

      await authService.logout();

      verify(mockStorage.delete(key: "auth_token")).called(1);
    });

    test("login: should throw error if API call fails", () async {
      when(mockApiService.post("login", any)).thenThrow(DioError(
        requestOptions: RequestOptions(path: 'login'),
        error: "Invalid credentials",
      ));

      expect(
        () => authService.login("wrong@example.com", "wrongpassword",false),
        throwsA(predicate((e) => e.toString().contains("Invalid credentials"))),
      );
    });

    test("register: should throw error if API call fails", () async {
      when(mockApiService.post("register", any)).thenThrow(DioError(
        requestOptions: RequestOptions(path: 'register'),
        error: "User already exists",
      ));

      expect(
        () => authService.register("Existing User", "existing@example.com", "password123"),
        throwsA(predicate((e) => e.toString().contains("User already exists"))),
      );
    });
  });
}
