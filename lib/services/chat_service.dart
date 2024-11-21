import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/channel.dart';
import '../models/message.dart';

class ChatService {
  static const String apiBaseUrl = 'http://localhost:8080/api';

  // 채널 목록을 가져오는 함수
  static Future<List<Channel>> getChannelList(String userId) async {
    final response = await http.get(Uri.parse('$apiBaseUrl/channels?userId=$userId'));

    print('CHANNEL LIST$response');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('CHANNEL LIST$data.length');

      if (data.isEmpty) {
        print('RETURN');
        return [];
      }

      return data.map((json) => Channel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load channel list');
    }
  }

// 채널에 새로운 메시지를 보내는 함수
  static Future<void> createChannel() async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/channels'),
      headers: {"Content-Type": "application/json"},
      // body: json.encode({"channelId": channelId, "content": content}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }

  // 새로운 채널을 생성하는 함수
  static Future<String> startNewChat(String userId) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/channels'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"userId": userId}),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return data['channelId'];
    } else {
      throw Exception('Failed to create new channel');
    }
  }

  // 특정 채널의 메시지 목록을 가져오는 함수
  static Future<List<Message>> getMessages(String channelId) async {
    final response = await http.get(Uri.parse('$apiBaseUrl/messages?channelId=$channelId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  // 채널에 새로운 메시지를 보내는 함수
  static Future<void> sendMessage(String channelId, String content) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/messages'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"channelId": channelId, "content": content}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }
}
