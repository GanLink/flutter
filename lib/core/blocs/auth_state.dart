import 'package:equatable/equatable.dart';

/// Estados del AuthBloc global
/// Representa el estado de autenticación de la aplicación
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial: verificando si hay sesión guardada
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Estado: usuario autenticado
class Authenticated extends AuthState {
  final int userId;
  final String username;
  final String token;

  const Authenticated({
    required this.userId,
    required this.username,
    required this.token,
  });

  @override
  List<Object?> get props => [userId, username, token];
}

/// Estado: usuario NO autenticado
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Estado: verificando autenticación (loading)
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Estado: error en la autenticación
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
