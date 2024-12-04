class Message {
  final int id;
  final int userId;
  final String content;
  final String translatedContent;
  final String createdAt; // DateTime을 String으로 처리

  Message({
    required this.id,
    required this.userId,
    required this.content,
    required this.translatedContent,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {

    return Message(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      content: json['content'] ?? '',
      translatedContent: json['translatedContent'] ?? '',
      createdAt: formatDate(List<int>.from(json['createdAt'] ?? [])),
    );
  }
}

String formatDate(List<int> dateList) {
  DateTime dateTime = DateTime.utc(
      dateList[0], dateList[1], dateList[2],
      dateList[3], dateList[4], dateList[5],
      (dateList.length > 6 ? dateList[6] : 0) ~/ 1000000
  );
  return dateTime.toIso8601String();
}