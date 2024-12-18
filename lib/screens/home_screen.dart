import 'package:flutter/material.dart';
import 'package:uv_chat_client_flutter/screens/user_list_screen.dart';
import '../models/channel.dart';
import '../services/chat_service.dart';
import 'message_screen.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  final String userName;
  final String country;

  const HomeScreen({Key? key, required this.userId, required this.userName, required this.country}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Channel> chatList = [];
  bool isLoading = true; // 로딩 상태 추가

  @override
  void initState() {
    super.initState();
    _loadChatList();
  }

  // Chat List 데이터를 불러오는 함수
  Future<void> _loadChatList() async {
    try {
      List<Channel> channels = await ChatService.getChannelList(widget.userId);
      setState(() {
        chatList = channels;
        isLoading = false; // 로딩 완료
      });
    } catch (e) {
      print('Error loading chat list: $e');
      setState(() {
        isLoading = false; // 에러 발생 시 로딩 완료 상태로 변경
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('User ID: ${widget.userId}, Country: ${widget.country}'),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator()) // 로딩 중
                : chatList.isEmpty
                ? const Center(child: Text('No chat channels available')) // 빈 목록일 때 표시
                : ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                final channel = chatList[index];
                return ListTile(
                  title: Text(channel.id.toString()),
                  subtitle: Text(channel.lastContent ?? 'No messages yet'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageScreen(channelId: channel.id, userId: widget.userId),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserListScreen(userId: widget.userId),
            ),
          );
        }, // + 버튼 클릭 시 새로운 채널 생성
        child: const Icon(Icons.add),
        tooltip: 'Create New Channel',
      ),
    );
  }
}
