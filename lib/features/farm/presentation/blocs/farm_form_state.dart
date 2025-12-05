import 'package:ganlink/core/enums/status.dart';
import 'package:ganlink/features/farm/domain/farm.dart';

class FarmFormState {
  final String alias;
  final String description;
  final int? mainActivity; // 0=CARNE, 1=LECHE, 2=GENERICA
  final String ownerDni;
  final Status status;
  final String message;
  final Farm? createdFarm;

  const FarmFormState({
    this.alias = '',
    this.description = '',
    this.mainActivity,
    this.ownerDni = '',
    this.status = Status.initial,
    this.message = '',
    this.createdFarm,
  });

  FarmFormState copyWith({
    String? alias,
    String? description,
    int? mainActivity,
    bool clearActivity = false,
    String? ownerDni,
    Status? status,
    String? message,
    Farm? createdFarm,
  }) {
    return FarmFormState(
      alias: alias ?? this.alias,
      description: description ?? this.description,
      mainActivity: clearActivity ? null : (mainActivity ?? this.mainActivity),
      ownerDni: ownerDni ?? this.ownerDni,
      status: status ?? this.status,
      message: message ?? this.message,
      createdFarm: createdFarm ?? this.createdFarm,
    );
  }
}
