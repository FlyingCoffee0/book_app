import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:piton_books/services/api_service.dart';

class AuthService {
  final ApiService _apiService;
  final FlutterSecureStorage _storage;

  AuthService(this._apiService, this._storage);

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
  Future<void> login(String email, String password, bool rememberMe) async {
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
        if (rememberMe) {
          await _storage.write(key: "remember_me", value: "true"); // Remember me bilgisi kaydetme
        }
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

  // Remember me kontrolü
  Future<bool> isRememberMe() async {
    try {
      final rememberMe = await _storage.read(key: "remember_me");
      return rememberMe == "true";
    } catch (e) {
      return false;
    }
  }

  // Token'ı silmek (Çıkış işlemi için)
  Future<void> logout() async {
    try {
      await _storage.delete(key: "auth_token");
      await _storage.delete(key: "remember_me"); // Remember me bilgisini de siliyoruz
      print("Logout successful, token removed!");
    } catch (e) {
      print("Logout error: $e");
      throw "Logout failed: $e";
    }
  }
}
