import 'package:equatable/equatable.dart';

abstract class BovinueEvent extends Equatable {
  const BovinueEvent();

  @override
  List<Object?> get props => [];
}

/// Cargar bovinos de una granja
class LoadBovinues extends BovinueEvent {
  final int farmId;
  final String token;

  const LoadBovinues({required this.farmId, required this.token});

  @override
  List<Object?> get props => [farmId, token];
}

/// Refrescar lista de bovinos
class RefreshBovinues extends BovinueEvent {
  final int farmId;
  final String token;

  const RefreshBovinues({required this.farmId, required this.token});

  @override
  List<Object?> get props => [farmId, token];
}
