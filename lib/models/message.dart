class Message {
  final int id;
  final String content;

  Message({required this.id, required this.content});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
    );
  }
}
