import 'package:equatable/equatable.dart';
import 'bovinue_form_state.dart';

abstract class BovinueFormEvent extends Equatable {
  const BovinueFormEvent();

  @override
  List<Object?> get props => [];
}

/// Inicializar formulario con métricas predefinidas
class InitializeForm extends BovinueFormEvent {
  const InitializeForm();
}

/// Cambiar tipo de bovino
class ChangeBovinueType extends BovinueFormEvent {
  final BovinueType type;

  const ChangeBovinueType(this.type);

  @override
  List<Object?> get props => [type];
}

/// Toggle de una métrica (seleccionar/deseleccionar)
class ToggleMetric extends BovinueFormEvent {
  final int index;

  const ToggleMetric(this.index);

  @override
  List<Object?> get props => [index];
}

/// Actualizar valor de una métrica
class UpdateMetricValue extends BovinueFormEvent {
  final int index;
  final String value;

  const UpdateMetricValue({required this.index, required this.value});

  @override
  List<Object?> get props => [index, value];
}

/// Enviar formulario para crear bovino
class SubmitBovinueForm extends BovinueFormEvent {
  final int farmId;
  final String token;

  const SubmitBovinueForm({required this.farmId, required this.token});

  @override
  List<Object?> get props => [farmId, token];
}

/// Resetear formulario
class ResetForm extends BovinueFormEvent {
  const ResetForm();
}
