import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/status.dart';
import '../../repositories/bovinue_repository.dart';
import 'bovinue_event.dart';
import 'bovinue_state.dart';

class BovinueBloc extends Bloc<BovinueEvent, BovinueState> {
  final BovinueRepository _bovinueRepository;

  BovinueBloc({required BovinueRepository bovinueRepository})
      : _bovinueRepository = bovinueRepository,
        super(const BovinueState()) {
    on<LoadBovinues>(_onLoadBovinues);
    on<RefreshBovinues>(_onRefreshBovinues);
  }

  Future<void> _onLoadBovinues(
    LoadBovinues event,
    Emitter<BovinueState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final bovinues = await _bovinueRepository.getBovinuesByFarmId(
        event.farmId,
        event.token,
      );
      emit(state.copyWith(
        status: Status.success,
        bovinues: bovinues,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshBovinues(
    RefreshBovinues event,
    Emitter<BovinueState> emit,
  ) async {
    try {
      final bovinues = await _bovinueRepository.getBovinuesByFarmId(
        event.farmId,
        event.token,
      );
      emit(state.copyWith(
        status: Status.success,
        bovinues: bovinues,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
