import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio) {
    _dio.options.baseUrl = "https://assign-api.piton.com.tr/api/rest/";
    _dio.options.headers = {
      "Content-Type": "application/json",
    };
  }

  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    try {
      return await _dio.post(endpoint, data: data);
    } on DioError catch (e) {
      throw e.response?.data["message"] ?? "An error occurred";
    }
  }

  Future<Response> get(String endpoint) async {
    try {
      return await _dio.get(endpoint);
    } on DioError catch (e) {
      throw e.response?.data["message"] ?? "An error occurred";
    }
  }
}