import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../domain/bovinue.dart';
import '../domain/bovinue_metric.dart';
import '../domain/create_bovinue_metric.dart';
import '../domain/update_bovinue_metric.dart';

class BovinueService {
  final http.Client _client;

  BovinueService({http.Client? client}) : _client = client ?? http.Client();

  /// Obtiene todos los bovinos de una granja
  Future<List<Bovinue>> getBovinuesByFarmId(int farmId, String token) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.bovinuesByFarmEndpoint(farmId)}',
    );

    final response = await _client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Bovinue.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener bovinos: ${response.statusCode}');
    }
  }

  /// Crea un nuevo bovino en una granja
  Future<Bovinue> createBovinue(int farmId, String token) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.bovinueEndpoint}',
    );

    final response = await _client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'farmId': farmId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Bovinue.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear bovino: ${response.statusCode}');
    }
  }

  /// Obtiene las métricas de un bovino
  Future<List<BovinueMetric>> getMetricsByBovinueId(
    int bovinueId,
    String token,
  ) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.metricsByBovinueEndpoint(bovinueId)}',
    );

    final response = await _client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => BovinueMetric.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener métricas: ${response.statusCode}');
    }
  }

  /// Crea una nueva métrica para un bovino
  Future<BovinueMetric> createMetric(
    CreateBovinueMetric metric,
    String token,
  ) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.bovinueMetricEndpoint}',
    );

    final response = await _client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(metric.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return BovinueMetric.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear métrica: ${response.statusCode}');
    }
  }

  /// Actualiza una métrica existente
  Future<BovinueMetric> updateMetric(
    UpdateBovinueMetric metric,
    String token,
  ) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.updateMetricEndpoint(metric.id)}',
    );

    final response = await _client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(metric.toJson()),
    );

    if (response.statusCode == 200) {
      return BovinueMetric.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar métrica: ${response.statusCode}');
    }
  }
}
