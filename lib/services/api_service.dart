import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/image_model.dart';

/// Service class responsible for fetching data from the Picsum API.
class ApiService {
  /// Base URL for the Picsum API list endpoint.
  static const String _baseUrl = 'https://picsum.photos/v2/list';

  /// Fetches a list of images from the Picsum API.
  ///
  /// [limit] specifies the maximum number of images to fetch (default is 10).
  ///
  /// Returns a [Future] that resolves to a list of [ImageModel] objects.
  /// Throws an [Exception] if the API request fails.
  Future<List<ImageModel>> fetchImages({int limit = 10}) async {
    final Uri uri = Uri.parse('$_baseUrl?limit=$limit');

    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      // Decode the JSON response body.
      List<dynamic> body = jsonDecode(response.body);

      // Map each JSON item to an ImageModel object.
      List<ImageModel> images = body
          .map((dynamic item) =>
              ImageModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return images;
    } else {
      // Throw an exception if the request was not successful.
      throw Exception(
          'Failed to load images. Status code: ${response.statusCode}');
    }
  }
}