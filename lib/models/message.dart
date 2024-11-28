class Message {
  final int id;
  final int userId;
  final String content;
  final String translatedContent;
  final String createdAt;

  Message({required this.id, required this.userId, required this.content, required this.translatedContent, required this.createdAt});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      userId: json['userID'],
      content: json['content'],
      translatedContent: json['translatedContent'],
      createdAt: json['createdAt'],
    );
  }
}
