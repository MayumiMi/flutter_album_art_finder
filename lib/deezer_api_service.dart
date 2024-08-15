import 'dart:convert';
import 'package:http/http.dart' as http;

class DeezerApiService {
  static const String baseUrl = 'https://api.deezer.com';

  Future<List<Map<String, dynamic>>> searchArtistsByName(
      String artistName) async {
    final url = '$baseUrl/search/artist?q=$artistName';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data['data'] != null) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> searchAlbumsByName(
      String albumName) async {
    final url = '$baseUrl/search/album?q=$albumName';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data['data'] != null) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> fetchArtistAlbums(int artistId) async {
    final url = '$baseUrl/artist/$artistId/albums';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data['data'] != null) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    }
    return [];
  }
}
