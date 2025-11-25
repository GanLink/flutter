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
        print('Login response JSON: $json'); // Debug print
        return UserLogin.fromJson(json);
      }
      return Future.error('Error: ${response.statusCode} - ${response.reasonPhrase}');
    } catch (e) {
      return Future.error('Error: ${e.toString()}');
    }
  }
}