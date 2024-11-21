import 'package:flutter/material.dart';
import '../models/channel.dart';
import '../services/chat_service.dart';
import 'message_screen.dart';

class ChatListScreen extends StatelessWidget {
  final String userId;

  const ChatListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat List"),
      ),
      body: FutureBuilder<List<Channel>>(
        future: ChatService.getChannelList(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final channels = snapshot.data!;
          return ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channel = channels[index];
              return ListTile(
                title: Text(channel.name),
                subtitle: Text(channel.lastContent),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessageScreen(channelId: channel.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
