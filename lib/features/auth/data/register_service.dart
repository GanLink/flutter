import 'dart:convert';
import 'dart:io';

import 'package:ganlink/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  Future<String> register({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String ruc,
    required String password,
  }) async {
    final Uri uri = Uri.parse(
      ApiConstants.baseUrl,
    ).replace(path: ApiConstants.registerEndpoint);

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'firstname': firstName,
          'lastname': lastName,
          'email': email,
          'ruc': ruc,
          'password': password,
        }),
      );
      
      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
        final json = jsonDecode(response.body);
        return json['message'] ?? 'Usuario creado exitosamente';
      }

      // Extraer mensaje de error del body de la respuesta
      String errorMessage = _parseErrorMessage(response);
      return Future.error(errorMessage);
    } on SocketException {
      return Future.error('Sin conexión a internet');
    } on FormatException {
      return Future.error('Error en el formato de respuesta del servidor');
    } catch (e) {
      return Future.error('Error inesperado: ${e.toString()}');
    }
  }

  String _parseErrorMessage(http.Response response) {
    try {
      final json = jsonDecode(response.body);
      // Intentar diferentes formatos de error comunes
      if (json is Map) {
        // Formato: {"message": "error"}
        if (json.containsKey('message')) {
          return json['message'];
        }
        // Formato: {"error": "error"}
        if (json.containsKey('error')) {
          return json['error'];
        }
        // Formato: {"errors": ["error1", "error2"]}
        if (json.containsKey('errors')) {
          final errors = json['errors'];
          if (errors is List && errors.isNotEmpty) {
            return errors.join(', ');
          }
          if (errors is Map) {
            return errors.values.join(', ');
          }
        }
        // Formato: {"title": "error", "detail": "detalle"}
        if (json.containsKey('title')) {
          final title = json['title'] ?? '';
          final detail = json['detail'] ?? '';
          return detail.isNotEmpty ? '$title: $detail' : title;
        }
      }
      // Si es un string directo
      if (json is String) {
        return json;
      }
    } catch (_) {
      // Si no se puede parsear el JSON, usar el body directamente si tiene contenido
      if (response.body.isNotEmpty && response.body.length < 200) {
        return response.body;
      }
    }

    // Mensaje por defecto según el código de estado
    switch (response.statusCode) {
      case 400:
        return 'Datos inválidos. Verifica los campos ingresados.';
      case 401:
        return 'No autorizado. Verifica tus credenciales.';
      case 403:
        return 'Acceso denegado.';
      case 404:
        return 'Recurso no encontrado.';
      case 409:
        return 'El usuario ya existe.';
      case 422:
        return 'Error de validación en los datos.';
      case 500:
        return 'Error interno del servidor.';
      default:
        return 'Error ${response.statusCode}: ${response.reasonPhrase}';
    }
  }
}
