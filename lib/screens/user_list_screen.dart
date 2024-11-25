import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../services/chat_service.dart'; // 채널 생성 API 호출용
import 'message_screen.dart';

class UserListScreen extends StatelessWidget {
  final int userId;

  const UserListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
      ),
      body: FutureBuilder<List<User>>(
        future: UserService.getUserList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          print(snapshot);
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.id.toString()),
                subtitle: Text(user.name),
                onTap: () async {
                  try {
                    // 채널 생성 API 호출
                    await ChatService.createChannel(userId, user.id);

                    // MessageScreen으로 이동 (MessageService 호출 포함)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageScreen(channelId: user.id),
                      ),
                    );
                  } catch (e) {
                    // 에러 처리
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error creating channel: $e')),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
