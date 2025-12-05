import 'package:equatable/equatable.dart';
import '../../domain/update_bovinue_metric.dart';

abstract class BovinueDetailsEvent extends Equatable {
  const BovinueDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// Cargar detalles y métricas de un bovino
class LoadBovinueDetails extends BovinueDetailsEvent {
  final int bovinueId;
  final String token;

  const LoadBovinueDetails({required this.bovinueId, required this.token});

  @override
  List<Object?> get props => [bovinueId, token];
}

/// Actualizar una métrica
class UpdateMetric extends BovinueDetailsEvent {
  final UpdateBovinueMetric metric;
  final String token;

  const UpdateMetric({required this.metric, required this.token});

  @override
  List<Object?> get props => [metric, token];
}

/// Refrescar métricas
class RefreshMetrics extends BovinueDetailsEvent {
  final int bovinueId;
  final String token;

  const RefreshMetrics({required this.bovinueId, required this.token});

  @override
  List<Object?> get props => [bovinueId, token];
}
