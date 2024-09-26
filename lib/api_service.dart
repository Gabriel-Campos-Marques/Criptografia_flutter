import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000';

  static Future<Map<String, dynamic>> criptImage(String file64) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cript_image'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'content': {'file64': file64}
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> descriptImage(
      String file64, String key) async {
    final response = await http.post(
      Uri.parse('$baseUrl/descript_image'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'content': {'file64': file64, 'key': key}
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> steganographyFile(
      String file64, String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/steganography_file'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'content': {'file64': file64, 'message': message}
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> steganographyReveal(String file64) async {
    final response = await http.post(
      Uri.parse('$baseUrl/steganography_reveal'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'content': {'file64': file64}
      }),
    );
    return jsonDecode(response.body);
  }
}
