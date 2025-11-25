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
        print('Register response JSON: $json'); // Debug print
        return json['message'] ?? 'User created successfully';
      }
      return Future.error('Error: ${response.statusCode} - ${response.reasonPhrase}');
    } catch (e) {
      return Future.error('Error: ${e.toString()}');
    }
  }
}
