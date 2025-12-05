import 'package:equatable/equatable.dart';
import '../../../../core/enums/status.dart';
import '../../domain/bovinue.dart';
import '../../domain/metric_field.dart';

/// Tipos de bovino disponibles
enum BovinueType {
  vaca('Vaca'),
  toro('Toro'),
  novillo('Novillo'),
  ternero('Ternero'),
  ternera('Ternera'),
  vaquilla('Vaquilla');

  final String displayName;
  const BovinueType(this.displayName);
}

class BovinueFormState extends Equatable {
  final Status status;
  final BovinueType? bovinueType;
  final List<MetricField> metrics;
  final Bovinue? createdBovinue;
  final String? errorMessage;

  const BovinueFormState({
    this.status = Status.initial,
    this.bovinueType,
    this.metrics = const [],
    this.createdBovinue,
    this.errorMessage,
  });

  bool get hasSelectedMetrics => metrics.any((m) => m.checked);

  bool get isValid {
    if (bovinueType == null) return false;
    final selectedMetrics = metrics.where((m) => m.checked);
    if (selectedMetrics.isEmpty) return false;
    return selectedMetrics.every(
      (m) => m.value.isNotEmpty && int.tryParse(m.value) != null,
    );
  }

  /// Obtiene las métricas seleccionadas con sus valores
  List<MetricField> get selectedMetrics =>
      metrics.where((m) => m.checked).toList();

  BovinueFormState copyWith({
    Status? status,
    BovinueType? bovinueType,
    bool clearBovinueType = false,
    List<MetricField>? metrics,
    Bovinue? createdBovinue,
    String? errorMessage,
  }) {
    return BovinueFormState(
      status: status ?? this.status,
      bovinueType: clearBovinueType ? null : (bovinueType ?? this.bovinueType),
      metrics: metrics ?? this.metrics,
      createdBovinue: createdBovinue ?? this.createdBovinue,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bovinueType, metrics, createdBovinue, errorMessage];
}
