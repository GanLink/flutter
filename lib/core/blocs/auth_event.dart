/// Eventos para el AuthBloc global
/// Este BLoC maneja el estado de autenticación de toda la aplicación
abstract class AuthEvent {
  const AuthEvent();
}

/// Evento que verifica si hay una sesión guardada al iniciar la app
class AppStarted extends AuthEvent {
  const AppStarted();
}

/// Evento cuando el usuario hace login exitosamente
class UserLoggedIn extends AuthEvent {
  final int userId;
  final String username;
  final String token;

  const UserLoggedIn({
    required this.userId,
    required this.username,
    required this.token,
  });
}

/// Evento cuando el usuario hace logout
class UserLoggedOut extends AuthEvent {
  const UserLoggedOut();
}

/// Evento para refrescar el token (futuro)
class TokenRefreshRequested extends AuthEvent {
  const TokenRefreshRequested();
}
