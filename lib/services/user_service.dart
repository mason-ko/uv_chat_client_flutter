import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:uv_chat_client_flutter/models/user.dart';

class UserService {
  static const String apiBaseUrl = 'http://localhost:8080/api';

  // 유저 목록을 가져오는 함수
  static Future<List<User>> getUserList() async {
    final response = await http.get(Uri.parse('$apiBaseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final ret = data.map((json) => User.fromJson(json)).toList();
      print("user list $ret");
      return ret;
    } else {
      print("user list errrr");
      throw Exception('Failed to load user list');
    }
  }
}
