import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piton_books/providers/providers.dart';
import '../services/api_service.dart';

// Riverpod provider tanımı
final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.read(apiServiceProvider)),
);

class AuthService {
  final ApiService _apiService;
  final _storage = FlutterSecureStorage();

  AuthService(this._apiService);

  // Kullanıcı kayıt olma
  Future<void> register(String name, String email, String password) async {
    try {
      final response = await _apiService.post(
        "register",
        {
          "name": name,
          "email": email,
          "password": password,
        },
      );
      print("Register Response: ${response.data}");
    } catch (e) {
      print("Register error: $e");
      throw "Registration failed: $e";
    }
  }

  // Kullanıcı giriş yapma
  Future<void> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        "login",
        {
          "email": email,
          "password": password,
        },
      );
      final token = response.data["action_login"]?["token"];
      if (token != null) {
        await _storage.write(key: "auth_token", value: token);
        print("Login successful, token saved!");
      } else {
        throw "Login failed, no token received!";
      }
    } catch (e) {
      print("Login error: $e");
      throw "Login failed: $e";
    }
  }

  // Token'ı almak
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: "auth_token");
    } catch (e) {
      print("Error fetching token: $e");
      throw "Could not fetch token: $e";
    }
  }

  // Token'ı silmek (Çıkış işlemi için)
  Future<void> logout() async {
    try {
      await _storage.delete(key: "auth_token");
      print("Logout successful, token removed!");
    } catch (e) {
      print("Logout error: $e");
      throw "Logout failed: $e";
    }
  }

  // Kullanıcının giriş yapıp yapmadığını kontrol etme
  Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      return token != null;
    } catch (e) {
      print("Error checking login status: $e");
      return false;
    }
  }
}
