import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = FlutterSecureStorage();

  // Veriyi sakla
  Future<void> saveData(String key, dynamic data) async {
    final jsonData = jsonEncode(data);
    await _storage.write(key: key, value: jsonData);
  }

  // Veriyi oku
  Future<dynamic> readData(String key) async {
    final jsonData = await _storage.read(key: key);
    if (jsonData == null) return null;
    return jsonDecode(jsonData);
  }

  // Veriyi sil
  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }
}
