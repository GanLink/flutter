import 'package:ganlink/core/services/database_service.dart';

import '../data/bovinue_service.dart';
import '../domain/bovinue.dart';
import '../domain/bovinue_metric.dart';
import '../domain/create_bovinue_metric.dart';
import '../domain/update_bovinue_metric.dart';

class BovinueRepository {
  final BovinueService _bovinueService;
  final DatabaseService _databaseService;

  BovinueRepository({
    required BovinueService bovinueService,
    required DatabaseService databaseService,
  })  : _bovinueService = bovinueService,
        _databaseService = databaseService;

  /// Obtiene todos los bovinos de una granja
  Future<List<Bovinue>> getBovinuesByFarmId(int farmId, String token) async {
    try {
      final bovinues = await _bovinueService.getBovinuesByFarmId(farmId, token);
      if (bovinues.isEmpty) {
        await _databaseService.clearBovinues(farmId);
      } else {
        for (var bovinue in bovinues) {
          await _databaseService.addBovinue(bovinue);
        }
      }
      return bovinues;
    } catch (e) {
      return _databaseService.getBovinues(farmId);
    }
  }

  /// Crea un nuevo bovino en una granja
  Future<Bovinue> createBovinue(int farmId, String token) async {
    final newBovinue = await _bovinueService.createBovinue(farmId, token);
    await _databaseService.addBovinue(newBovinue);
    return newBovinue;
  }

  /// Elimina un bovino
  Future<void> deleteBovinue(int id, String token) async {
    // Nota: El servicio API para eliminar bovino no parece estar en la lista.
    // Asumiendo que existirá un `_bovinueService.deleteBovinue(id, token)`.
    // Si no existe, esta parte fallará.
    // await _bovinueService.deleteBovinue(id, token);
    await _databaseService.deleteBovinue(id);
  }

  /// Obtiene las métricas de un bovino
  Future<List<BovinueMetric>> getMetricsByBovinueId(
    int bovinueId,
    String token,
  ) async {
    return await _bovinueService.getMetricsByBovinueId(bovinueId, token);
  }

  /// Crea una nueva métrica para un bovino
  Future<BovinueMetric> createMetric(
    CreateBovinueMetric metric,
    String token,
  ) async {
    return await _bovinueService.createMetric(metric, token);
  }

  /// Actualiza una métrica existente
  Future<BovinueMetric> updateMetric(
    UpdateBovinueMetric metric,
    String token,
  ) async {
    return await _bovinueService.updateMetric(metric, token);
  }

  /// Crea un bovino con múltiples métricas iniciales
  Future<Bovinue> createBovinueWithMetrics({
    required int farmId,
    required String token,
    required List<CreateBovinueMetric> metrics,
  }) async {
    // Primero crear el bovino
    final bovinue = await createBovinue(farmId, token);

    // Luego crear cada métrica asociada al bovino
    for (final metricData in metrics) {
      final metricWithBovinueId = CreateBovinueMetric(
        bovinueId: bovinue.id,
        bovinueMPId: metricData.bovinueMPId,
        date: metricData.date,
        quantity: metricData.quantity,
      );
      await createMetric(metricWithBovinueId, token);
    }

    // Finalmente, agregar el bovino creado a la base de datos local
    await _databaseService.addBovinue(bovinue);

    return bovinue;
  }
}
