import 'package:ganlink/core/services/secure_storage_service.dart';
import 'package:ganlink/features/auth/data/login_service.dart';
import 'package:ganlink/features/auth/data/register_service.dart';
import 'package:ganlink/features/auth/domain/user_login.dart';

/// Repositorio central para toda la lógica de autenticación.
/// Coordina los servicios de HTTP y almacenamiento seguro.
class AuthRepository {
  final LoginService _loginService;
  final RegisterService _registerService;
  final SecureStorageService _storageService;

  AuthRepository({
    required LoginService loginService,
    required RegisterService registerService,
    required SecureStorageService storageService,
  })  : _loginService = loginService,
        _registerService = registerService,
        _storageService = storageService;

  /// Realiza el login del usuario
  /// Guarda automáticamente el token y datos del usuario en storage seguro
  /// Retorna el UserLogin si es exitoso
  /// Lanza excepción si falla
  Future<UserLogin> login({
    required String username,
    required String password,
  }) async {
    try {
      // Llamar al servicio de login
      final user = await _loginService.login(username, password);
      

      // Guardar los datos en storage seguro
      await _storageService.saveToken(user.token);
      await _storageService.saveUserId(user.id);
      await _storageService.saveUsername(user.username);

      return user;
    } catch (e) {
      // Si algo falla, asegurar que no queden datos parciales
      await _storageService.clearAll();
      rethrow;
    }
  }

  /// Registra un nuevo usuario
  /// NO guarda datos porque el backend no devuelve token en el registro
  /// Retorna el mensaje de éxito del backend
  /// Lanza excepción si falla
  Future<String> register({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String ruc,
    required String password,
  }) async {
    return await _registerService.register(
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email,
      ruc: ruc,
      password: password,
    );
  }

  /// Cierra la sesión del usuario
  /// Elimina TODOS los datos guardados en storage seguro
  Future<void> logout() async {
    try {
      await _storageService.clearAll();
      // TODO: Notificar al backend del logout (opcional)
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  /// Recupera el usuario actual desde el storage seguro
  /// Retorna UserLogin si hay una sesión guardada válida
  /// Retorna null si no hay sesión o faltan datos
  Future<UserLogin?> getCurrentUser() async {
    try {
      final token = await _storageService.getToken();
      final id = await _storageService.getUserId();
      final username = await _storageService.getUsername();

      // Validar que existan todos los datos necesarios
      if (token == null || id == null || username == null) {
        return null;
      }

      // Reconstruir el objeto UserLogin
      return UserLogin(
        id: id,
        username: username,
        token: token,
      );
    } catch (e) {
      // Si hay error al recuperar datos, limpiar todo por seguridad
      await _storageService.clearAll();
      return null;
    }
  }

  /// Verifica si hay una sesión activa
  /// Retorna true si existe un token guardado, false en caso contrario
  Future<bool> isAuthenticated() async {
    return await _storageService.hasToken();
  }

  /// Obtiene solo el token sin reconstruir el objeto completo
  /// Útil para el HTTP interceptor
  Future<String?> getToken() async {
    return await _storageService.getToken();
  }
}
