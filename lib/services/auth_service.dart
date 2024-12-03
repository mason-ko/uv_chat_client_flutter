import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String apiBaseUrl = 'http://localhost:8080/api';

  static Future<int> createUser(String userName, String country) async {
    final url = Uri.parse('$apiBaseUrl/users');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': userName, 'country': country}),
      );

      if (response.statusCode == 200) {
        print('User created successfully');
        final data = json.decode(response.body);
        return data['id'];
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
