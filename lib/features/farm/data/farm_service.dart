import 'dart:convert';

import 'package:ganlink/core/constants/api_constants.dart';
import 'package:ganlink/core/services/secure_storage_service.dart';
import 'package:ganlink/features/farm/domain/farm.dart';
import 'package:http/http.dart' as http;

class FarmService {
  Future<Farm> createFarm({
    required String alias,
    required String description,
    required int mainActivity,
    required String ownerDni,
    required int userId,
  }) async {
    final Uri uri = Uri.parse(
      ApiConstants.baseUrl
    ).replace(path: ApiConstants.farmEndpoint);

    try {
      final token = await SecureStorageService().getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No auth token found');
      }
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'alias': alias,
          'description': description,
          'userId': userId,
          'mainActivity': mainActivity,
          'ownerDni': ownerDni,
        }),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Farm.fromJson(json);
      }

      // Propagar mensaje del backend si existe
      final errorBody = response.body;
      final message = errorBody.isNotEmpty ? ': $errorBody' : '';
      throw Exception(
        'Failed to create farm (${response.statusCode})$message',
      );
    } catch (e) {
      throw Exception('Failed to create farm: $e');
    }
  }

  Future<List<Farm>> getUserFarms(int userId) async {
    final Uri uri = Uri.parse(
      ApiConstants.baseUrl,
    ).replace(path: ApiConstants.userFarmsEndpoint(userId));

    try {
      final token = await SecureStorageService().getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No auth token found');
      }
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => Farm.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch farms: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch farms: $e');
    }
  }

  Future<void> deleteFarm(int id) async {
    final Uri uri = Uri.parse(
      ApiConstants.baseUrl,
    ).replace(path: '${ApiConstants.farmEndpoint}/$id');

    try {
      final token = await SecureStorageService().getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No auth token found');
      }

      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      }

      final errorBody = response.body;
      final message = errorBody.isNotEmpty ? ': $errorBody' : '';
      throw Exception('Failed to delete farm (${response.statusCode})$message');
    } catch (e) {
      throw Exception('Failed to delete farm: $e');
    }
  }
}
