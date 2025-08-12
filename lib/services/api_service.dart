// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/image_model.dart'; // Adjust path if needed

class ApiService {
  // Correct base URL - no extra spaces
  static const String _baseUrl = 'https://picsum.photos/v2/list'; // <-- FIXED

  Future<List<ImageModel>> fetchImages({int limit = 10}) async {
    // Correctly form the URL with the limit parameter
    final Uri uri = Uri.parse('$_baseUrl?limit=$limit');
    print('Fetching images from: $uri'); // Debugging line

    try {
      final http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<ImageModel> images = body
            .map((dynamic item) =>
                ImageModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return images;
      } else {
        throw Exception(
            'Failed to load images. Status code: ${response.statusCode}, Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('ApiService.fetchImages error: $e'); // Log the error
      // Re-throw to let calling code (Bloc) handle it
      throw Exception('Image fetch failed: $e');
    }
  }
}