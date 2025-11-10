import 'package:ganlink/core/enums/status.dart';

class LoginState {
  final String username;
  final String password;
  final bool isPasswordVisible;
  final Status status;
  final String message;

  LoginState({
    this.username = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.status = Status.initial,
    this.message = '',
  });

  LoginState copyWith({
    String? username,
    String? password,
    bool? isPasswordVisible,
    Status? status,
    String? message,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}