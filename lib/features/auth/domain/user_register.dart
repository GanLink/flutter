class UserRegister {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String ruc;
  final String password;

  const UserRegister({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.ruc,
    required this.password,
  });

  factory UserRegister.fromJson(Map<String, dynamic> json) {
    return UserRegister(
      username: json['username'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      email: json['email'],
      ruc: json['ruc'],
      password: json['password'],
    );
  }
}
