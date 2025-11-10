import 'package:ganlink/core/enums/status.dart';

class RegisterState {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String ruc;
  final String password;
  final bool isPasswordVisible;
  final Status status;
  final String message;

  RegisterState({
    this.username = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.ruc = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.status = Status.initial,
    this.message = '',
  });

  RegisterState copyWith({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? ruc,
    String? password,
    bool? isPasswordVisible,
    Status? status,
    String? message,
  }) {
    return RegisterState(
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      ruc: ruc ?? this.ruc,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
