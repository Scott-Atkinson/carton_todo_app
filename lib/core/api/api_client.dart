import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = dotenv.env['BASE_URL'] ?? 'https://my.api.mockaroo.com';
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  
  // GET Request
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      final Uri uri = Uri.parse('$baseUrl/$endpoint').replace(
        queryParameters: queryParams
      );
      
      final response = await http.get(
        uri,
        headers: {'X-API-Key': apiKey},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
  
  // POST Request
  Future<dynamic> post(String endpoint, {required Map<String, dynamic> body}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'X-API-Key': apiKey,
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return response.body.isNotEmpty ? json.decode(response.body) : true;
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error posting data: $e');
    }
  }
}