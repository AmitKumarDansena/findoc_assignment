import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/picsum_image.dart';

class PicsumRepository {
  final http.Client client;

  PicsumRepository({http.Client? client})
      : client = client ?? http.Client();

  Future<List<PicsumImage>> fetchImages({int page = 1, int limit = 10}) async {
    try {
      final uri = Uri.parse(
          'https://picsum.photos/v2/list?page=$page&limit=$limit');
      final res = await client.get(uri);

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body) as List;
        return data.map((e) => PicsumImage.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch images. Status code: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching images: $e');
    }
  }

  void dispose() {
    client.close();
  }
}
