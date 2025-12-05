import 'package:ganlink/core/services/database_service.dart';
import 'package:ganlink/features/farm/data/farm_service.dart';
import 'package:ganlink/features/farm/domain/farm.dart';

class FarmRepository {
  final FarmService _farmService;
  final DatabaseService _databaseService;

  FarmRepository({
    required FarmService farmService,
    required DatabaseService databaseService,
  })  : _farmService = farmService,
        _databaseService = databaseService;

  Future<List<Farm>> getFarmsByUser(int userId) async {
    // Always return local database farms for immediate display
    final localFarms = await _databaseService.getFarms(userId);

    // Sync with API in background without blocking the UI
    _syncWithApi(userId);

    return localFarms;
  }

  Future<void> _syncWithApi(int userId) async {
    try {
      final apiFarms = await _farmService.getUserFarms(userId);
      // Sync API farms to local database
      for (var farm in apiFarms) {
        await _databaseService.addFarm(farm);
      }
    } catch (e) {
      // Ignore API errors to avoid blocking local data display
    }
  }

  Future<Farm> createFarm({
    required String alias,
    required String description,
    required int mainActivity,
    required String ownerDni,
    required int userId,
  }) async {
    final newFarm = await _farmService.createFarm(
      alias: alias,
      description: description,
      mainActivity: mainActivity,
      ownerDni: ownerDni,
      userId: userId,
    );
    await _databaseService.addFarm(newFarm);
    return newFarm;
  }

  Future<void> deleteFarm(int id) async {
    await _farmService.deleteFarm(id);
    await _databaseService.deleteFarm(id);
  }
}
