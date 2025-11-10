class User {
  final int id;
  final String username;
  final String token;

  const User({
    required this.id,
    required this.username,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      token: json['token'],
    );
  }
}