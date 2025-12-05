import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/status.dart';
import '../../repositories/bovinue_repository.dart';
import 'bovinue_details_event.dart';
import 'bovinue_details_state.dart';

class BovinueDetailsBloc
    extends Bloc<BovinueDetailsEvent, BovinueDetailsState> {
  final BovinueRepository _bovinueRepository;

  BovinueDetailsBloc({required BovinueRepository bovinueRepository})
      : _bovinueRepository = bovinueRepository,
        super(const BovinueDetailsState()) {
    on<LoadBovinueDetails>(_onLoadDetails);
    on<UpdateMetric>(_onUpdateMetric);
    on<RefreshMetrics>(_onRefreshMetrics);
  }

  Future<void> _onLoadDetails(
    LoadBovinueDetails event,
    Emitter<BovinueDetailsState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, bovinueId: event.bovinueId));
    try {
      final metrics = await _bovinueRepository.getMetricsByBovinueId(
        event.bovinueId,
        event.token,
      );
      emit(state.copyWith(
        status: Status.success,
        metrics: metrics,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateMetric(
    UpdateMetric event,
    Emitter<BovinueDetailsState> emit,
  ) async {
    emit(state.copyWith(isUpdating: true));
    try {
      final updatedMetric = await _bovinueRepository.updateMetric(
        event.metric,
        event.token,
      );

      // Actualizar la métrica en la lista
      final updatedMetrics = state.metrics.map((m) {
        if (m.id == updatedMetric.id) {
          return updatedMetric;
        }
        return m;
      }).toList();

      emit(state.copyWith(
        metrics: updatedMetrics,
        isUpdating: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isUpdating: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshMetrics(
    RefreshMetrics event,
    Emitter<BovinueDetailsState> emit,
  ) async {
    try {
      final metrics = await _bovinueRepository.getMetricsByBovinueId(
        event.bovinueId,
        event.token,
      );
      emit(state.copyWith(metrics: metrics));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
