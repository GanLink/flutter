class UserLogin {
  final int id;
  final String username;
  final String token;
  
  const UserLogin({
    required this.id,
    required this.username,
    required this.token,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      id: json['id'],
      username: json['username'],
      token: json['token'],
    );
  }
}