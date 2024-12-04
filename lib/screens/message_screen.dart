import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위한 패키지
import '../services/chat_service.dart';
import '../models/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessageScreen extends StatefulWidget {
  final int channelId;
  final int userId;

  const MessageScreen({super.key, required this.channelId, required this.userId});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // ScrollController 추가
  late Future<List<Message>> _messages;
  List<Message> _messageList = [];

  @override
  void initState() {
    super.initState();
    _messages = ChatService.getMessages(widget.channelId);
    _messages.then((initialMessages) {
      setState(() {
        _messageList = initialMessages;
      });
    });
    connectToServer();
  }

  @override
  void dispose() {
    socket.dispose(); // 소켓 연결 해제
    _messageController.dispose(); // 컨트롤러 해제
    _scrollController.dispose(); // 스크롤 컨트롤러 해제
    super.dispose();
  }

  void connectToServer() {
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.on('connect', (_) {
      print('Connected to server');
      socket.emit('join_channel', {'channelId': widget.channelId});
    });

    socket.on('disconnect', (_) {
      print('Disconnected from server');
    });

    socket.on('create_message', (data) {
      final newMessage = Message(
        id: data['id'],
        userId: data['userId'],
        content: data['content'],
        translatedContent: data['translatedContent'],
        createdAt: formatDate(List<int>.from(data['createdAt'] ?? [])),
      );

      setState(() {
        _messageList.add(newMessage);
      });

      // 메시지 추가 후 스크롤을 최하단으로 이동
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  String _formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // ScrollController 연결
              itemCount: _messageList.length,
              itemBuilder: (context, index) {
                final message = _messageList[index];
                final isUserMessage = message.userId == widget.userId;

                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 10.0),
                    child: Card(
                      color: isUserMessage ? Colors.teal[100] : Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isUserMessage
                                  ? "${message.userId}: ${message.content}"
                                  : "${message.userId}: ${message.translatedContent}",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              isUserMessage
                                  ? "번역된 메시지: ${message.translatedContent}"
                                  : "번역된 메시지: ${message.content}",
                              style: const TextStyle(
                                color: Colors.black54,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                _formatTimestamp(message.createdAt),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Enter message",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: () async {
                    final messageContent = _messageController.text;
                    if (messageContent.isEmpty) return;

                    await ChatService.sendMessage(
                      widget.channelId,
                      widget.userId,
                      messageContent,
                    );
                    _messageController.clear();
                    _scrollToBottom(); // 메시지 전송 후 스크롤 이동
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
