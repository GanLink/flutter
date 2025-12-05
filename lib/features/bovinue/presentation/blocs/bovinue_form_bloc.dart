import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/status.dart';
import '../../domain/create_bovinue_metric.dart';
import '../../domain/metric_field.dart';
import '../../repositories/bovinue_repository.dart';
import 'bovinue_form_event.dart';
import 'bovinue_form_state.dart';

class BovinueFormBloc extends Bloc<BovinueFormEvent, BovinueFormState> {
  final BovinueRepository _bovinueRepository;

  BovinueFormBloc({required BovinueRepository bovinueRepository})
      : _bovinueRepository = bovinueRepository,
        super(const BovinueFormState()) {
    on<InitializeForm>(_onInitializeForm);
    on<ChangeBovinueType>(_onChangeBovinueType);
    on<ToggleMetric>(_onToggleMetric);
    on<UpdateMetricValue>(_onUpdateMetricValue);
    on<SubmitBovinueForm>(_onSubmitForm);
    on<ResetForm>(_onResetForm);
  }

  void _onInitializeForm(
    InitializeForm event,
    Emitter<BovinueFormState> emit,
  ) {
    final metrics = PredefinedMetrics.getDefaultMetrics();
    emit(state.copyWith(
      status: Status.initial,
      metrics: metrics,
      clearBovinueType: true,
    ));
  }

  void _onChangeBovinueType(
    ChangeBovinueType event,
    Emitter<BovinueFormState> emit,
  ) {
    emit(state.copyWith(bovinueType: event.type));
  }

  void _onToggleMetric(
    ToggleMetric event,
    Emitter<BovinueFormState> emit,
  ) {
    final updatedMetrics = List<MetricField>.from(state.metrics);
    final metric = updatedMetrics[event.index];
    updatedMetrics[event.index] = metric.copyWith(checked: !metric.checked);
    emit(state.copyWith(metrics: updatedMetrics));
  }

  void _onUpdateMetricValue(
    UpdateMetricValue event,
    Emitter<BovinueFormState> emit,
  ) {
    final updatedMetrics = List<MetricField>.from(state.metrics);
    final metric = updatedMetrics[event.index];
    updatedMetrics[event.index] = metric.copyWith(value: event.value);
    emit(state.copyWith(metrics: updatedMetrics));
  }

  Future<void> _onSubmitForm(
    SubmitBovinueForm event,
    Emitter<BovinueFormState> emit,
  ) async {
    if (!state.isValid) {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'Por favor, complete todos los campos seleccionados',
      ));
      return;
    }

    emit(state.copyWith(status: Status.loading));

    try {
      // Obtener fecha actual en formato ISO
      final now = DateTime.now().toUtc().toIso8601String();

      // Crear lista de métricas a partir de los campos seleccionados
      final metricsToCreate = state.metrics
          .where((m) => m.checked && m.value.isNotEmpty)
          .map((m) => CreateBovinueMetric(
                bovinueId: 0, // Se actualizará después de crear el bovino
                bovinueMPId: m.bovinueMPId,
                date: now,
                quantity: int.parse(m.value),
              ))
          .toList();

      // Crear bovino con métricas
      final bovinue = await _bovinueRepository.createBovinueWithMetrics(
        farmId: event.farmId,
        token: event.token,
        metrics: metricsToCreate,
      );

      emit(state.copyWith(
        status: Status.success,
        createdBovinue: bovinue,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onResetForm(
    ResetForm event,
    Emitter<BovinueFormState> emit,
  ) {
    final metrics = PredefinedMetrics.getDefaultMetrics();
    emit(BovinueFormState(metrics: metrics));
  }
}
