import 'package:ganlink/features/farm/data/farm_service.dart';
import 'package:ganlink/features/farm/domain/farm.dart';

class FarmRepository {
  final FarmService _farmService;

  FarmRepository({required FarmService farmService}) : _farmService = farmService;

  Future<List<Farm>> getFarmsByUser(int userId) {
    return _farmService.getUserFarms(userId);
  }

  Future<Farm> createFarm({
    required String alias,
    required String description,
    required int mainActivity,
    required String ownerDni,
    required int userId,
  }) {
    return _farmService.createFarm(
      alias: alias,
      description: description,
      mainActivity: mainActivity,
      ownerDni: ownerDni,
      userId: userId,
    );
  }

  Future<void> deleteFarm(int id) {
    return _farmService.deleteFarm(id);
  }
}
