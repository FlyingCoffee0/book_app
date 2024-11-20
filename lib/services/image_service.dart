import 'package:dio/dio.dart';

class ImageService {
  final Dio dio;

  ImageService(this.dio);

  Future<String?> fetchImageUrl(String fileName) async {
  try {
    final response = await Dio().post(
      "https://assign-api.piton.com.tr/api/rest/cover_image",
      data: {"fileName": fileName},
    );
    if (response.statusCode == 200 && response.data["action_product_image"] != null) {
      return response.data["action_product_image"]["url"];
    } else {
      return null;
    }
  } catch (e) {
    print("Failed to fetch image URL for $fileName: $e");
    return null;
  }
}

}
