class User {
  final int id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    final x = User(
      id:  json['id'],
      name: json['name'],
    );
    print("user $x");

    return User(
      id: json['id'],
      name: json['name'],
    );
  }
}
