import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://inventaris.posumkm.id/api';

  Future<http.Response> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to fetch data from API. Status code: ${response.statusCode}');
      }

      return response;
    } catch (e) {
      throw Exception('Error in API request: $e');
    }
  }
}
