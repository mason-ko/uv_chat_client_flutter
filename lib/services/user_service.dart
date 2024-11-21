import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  static const String apiBaseUrl = 'http://localhost:8080/api';

  // 유저 목록을 가져오는 함수
  static Future<List<Map<String, dynamic>>> getUserList() async {
    final response = await http.get(Uri.parse('$apiBaseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => {"id": json['id'], "name": json['name']}).toList();
    } else {
      throw Exception('Failed to load user list');
    }
  }
}
