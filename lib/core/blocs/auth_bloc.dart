import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ganlink/core/blocs/auth_event.dart';
import 'package:ganlink/core/blocs/auth_state.dart';
import 'package:ganlink/features/auth/repositories/auth_repository.dart';

/// AuthBloc global que maneja el estado de autenticación de toda la app
/// 
/// Responsabilidades:
/// - Verificar si hay sesión guardada al iniciar la app (auto-login)
/// - Mantener el estado de autenticación global
/// - Coordinar login/logout desde cualquier parte de la app
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial()) {
    
    // Al iniciar la app, verificar si hay sesión guardada
    on<AppStarted>(_onAppStarted);
    
    // Cuando el usuario hace login
    on<UserLoggedIn>(_onUserLoggedIn);
    
    // Cuando el usuario hace logout
    on<UserLoggedOut>(_onUserLoggedOut);
    
    // Refresh token (futuro)
    on<TokenRefreshRequested>(_onTokenRefreshRequested);
  }

  /// Verifica si hay una sesión guardada al iniciar la app
  /// Si existe, auto-login. Si no, mostrar pantalla de login.
  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Verificar si hay un usuario guardado
      final user = await _authRepository.getCurrentUser();

      if (user != null) {
        // Auto-login exitoso
        emit(Authenticated(
          userId: user.id,
          username: user.username,
          token: user.token,
        ));
      } else {
        // No hay sesión guardada
        emit(const Unauthenticated());
      }
    } catch (e) {
      // Error al verificar sesión, ir a login
      emit(const Unauthenticated());
    }
  }

  /// Marca al usuario como autenticado después de login exitoso
  Future<void> _onUserLoggedIn(
    UserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(Authenticated(
      userId: event.userId,
      username: event.username,
      token: event.token,
    ));
  }

  /// Cierra la sesión del usuario
  Future<void> _onUserLoggedOut(
    UserLoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _authRepository.logout();
      emit(const Unauthenticated());
    } catch (e) {
      // Aunque falle el logout, marcar como no autenticado
      emit(const Unauthenticated());
    }
  }

  /// Refresh del token (para implementar después)
  Future<void> _onTokenRefreshRequested(
    TokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    // TODO: Implementar refresh token cuando el backend lo soporte
  }
}
