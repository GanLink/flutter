import 'dart:io';

import 'package:ganlink/core/constants/api_constants.dart';

import 'package:http/http.dart' as http;

class LogoutService {
  Future<void> logout(String token) async {
    final Uri uri = Uri.parse(
      ApiConstants.baseUrl,
    ).replace(path: ApiConstants.logoutEndpoint);

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        // Logout successful
        return;
      }

      // For logout, we might not want to throw errors since it's optional
      // Just log the issue but don't fail the logout process
      print('Warning: Backend logout failed: ${response.statusCode} - ${response.reasonPhrase}');
    } catch (e) {
      // For logout, we might not want to throw errors since it's optional
      // Just log the issue but don't fail the logout process
      print('Warning: Error notifying backend of logout: ${e.toString()}');
    }
  }
}