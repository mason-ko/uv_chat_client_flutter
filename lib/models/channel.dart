class Channel {
  final int id;
  final String name;
  final String lastContent;

  Channel({required this.id, required this.name, required this.lastContent});

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'],
      name: json['name'],
      lastContent: json['lastContent'],
    );
  }
}
