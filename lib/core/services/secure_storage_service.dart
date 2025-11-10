import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Servicio para manejar almacenamiento seguro de datos sensibles
/// como tokens de autenticación y datos del usuario.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  // Keys constantes para evitar typos
  static const String _keyToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUsername = 'username';

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Guarda el token JWT de autenticación
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _keyToken, value: token);
    } catch (e) {
      throw Exception('Error al guardar el token: $e');
    }
  }

  /// Recupera el token JWT guardado
  /// Retorna null si no existe
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _keyToken);
    } catch (e) {
      return null;
    }
  }

  /// Elimina el token guardado
  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _keyToken);
    } catch (e) {
      throw Exception('Error al eliminar el token: $e');
    }
  }

  /// Guarda el ID del usuario
  Future<void> saveUserId(int id) async {
    try {
      await _storage.write(key: _keyUserId, value: id.toString());
    } catch (e) {
      throw Exception('Error al guardar el ID del usuario: $e');
    }
  }

  /// Recupera el ID del usuario guardado
  /// Retorna null si no existe o no se puede parsear
  Future<int?> getUserId() async {
    try {
      final idString = await _storage.read(key: _keyUserId);
      if (idString == null) return null;
      return int.tryParse(idString);
    } catch (e) {
      return null;
    }
  }

  /// Guarda el username del usuario
  Future<void> saveUsername(String username) async {
    try {
      await _storage.write(key: _keyUsername, value: username);
    } catch (e) {
      throw Exception('Error al guardar el username: $e');
    }
  }

  /// Recupera el username guardado
  /// Retorna null si no existe
  Future<String?> getUsername() async {
    try {
      return await _storage.read(key: _keyUsername);
    } catch (e) {
      return null;
    }
  }

  /// Elimina TODOS los datos guardados
  /// Se usa principalmente en logout
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw Exception('Error al limpiar el almacenamiento: $e');
    }
  }

  /// Verifica si existe un token guardado
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
