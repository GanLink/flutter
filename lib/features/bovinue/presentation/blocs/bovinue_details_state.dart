import 'package:equatable/equatable.dart';
import '../../../../core/enums/status.dart';
import '../../domain/bovinue_metric.dart';

class BovinueDetailsState extends Equatable {
  final Status status;
  final int? bovinueId;
  final List<BovinueMetric> metrics;
  final String? errorMessage;
  final bool isUpdating;

  const BovinueDetailsState({
    this.status = Status.initial,
    this.bovinueId,
    this.metrics = const [],
    this.errorMessage,
    this.isUpdating = false,
  });

  BovinueDetailsState copyWith({
    Status? status,
    int? bovinueId,
    List<BovinueMetric>? metrics,
    String? errorMessage,
    bool? isUpdating,
  }) {
    return BovinueDetailsState(
      status: status ?? this.status,
      bovinueId: bovinueId ?? this.bovinueId,
      metrics: metrics ?? this.metrics,
      errorMessage: errorMessage,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  List<Object?> get props => [status, bovinueId, metrics, errorMessage, isUpdating];
}
