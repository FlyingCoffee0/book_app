import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';

class AuthService {
  final ApiService _apiService;
  final _storage = FlutterSecureStorage();

  AuthService(this._apiService);

  // Kullanıcı kayıt olma
  Future<void> register(String name, String email, String password) async {
    final response = await _apiService.post(
      "register",
      {
        "name": name,
        "email": email,
        "password": password,
      },
    );
    print("Register Response: ${response.data}");
  }

  // Kullanıcı giriş yapma
  Future<void> login(String email, String password) async {
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
  }

  // Token'ı almak
  Future<String?> getToken() async {
    return await _storage.read(key: "auth_token");
  }

  // Token'ı silmek (Çıkış işlemi için)
  Future<void> logout() async {
    await _storage.delete(key: "auth_token");
    print("Logout successful, token removed!");
  }
}
