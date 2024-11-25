import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String apiBaseUrl = 'http://localhost:8080/api';

  static Future<void> createUser(int userId, String country) async {
    final url = Uri.parse('$apiBaseUrl/users');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': userId, 'country': country}),
      );

      if (response.statusCode == 200) {
        print('User created successfully');
      } else {
        print('Failed to create user: ${response.statusCode}');
        throw Exception('Failed to create user');
      }
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }
}
