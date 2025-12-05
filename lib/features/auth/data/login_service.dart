import 'dart:convert';
import 'dart:io';

import 'package:ganlink/core/constants/api_constants.dart';
import 'package:ganlink/features/auth/domain/user_login.dart';

import 'package:http/http.dart' as http;


class LoginService {
  Future<UserLogin> login(String username, String password) async {
    final Uri uri = Uri.parse(
      ApiConstants.baseUrl,
    ).replace(path: ApiConstants.loginEndpoint);

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return UserLogin.fromJson(json);
      }

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
      if (json is Map) {
        if (json.containsKey('message')) return json['message'];
        if (json.containsKey('error')) return json['error'];
        if (json.containsKey('title')) {
          final title = json['title'] ?? '';
          final detail = json['detail'] ?? '';
          return detail.isNotEmpty ? '$title: $detail' : title;
        }
      }
      if (json is String) return json;
    } catch (_) {
      if (response.body.isNotEmpty && response.body.length < 200) {
        return response.body;
      }
    }

    switch (response.statusCode) {
      case 400:
        return 'Datos inválidos';
      case 401:
        return 'Usuario o contraseña incorrectos';
      case 403:
        return 'Acceso denegado';
      case 404:
        return 'Usuario no encontrado';
      case 500:
        return 'Error interno del servidor';
      default:
        return 'Error ${response.statusCode}: ${response.reasonPhrase}';
    }
  }
}