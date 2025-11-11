import 'package:ganlink/core/enums/status.dart';
import 'package:ganlink/features/auth/domain/user_login.dart';

class LoginState {
  final String username;
  final String password;
  final bool isPasswordVisible;
  final Status status;
  final String message;
  final UserLogin? user;

  LoginState({
    this.username = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.status = Status.initial,
    this.message = '',
    this.user,
  });

  LoginState copyWith({
    String? username,
    String? password,
    bool? isPasswordVisible,
    Status? status,
    String? message,
    UserLogin? user,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      status: status ?? this.status,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }
}