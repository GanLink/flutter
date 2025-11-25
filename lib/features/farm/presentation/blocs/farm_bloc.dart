import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ganlink/core/enums/status.dart';
import 'package:ganlink/features/farm/presentation/blocs/farm_event.dart';
import 'package:ganlink/features/farm/presentation/blocs/farm_state.dart';
import 'package:ganlink/features/farm/repositories/farm_repository.dart';

class FarmBloc extends Bloc<FarmEvent, FarmState> {
  final FarmRepository farmRepository;

  FarmBloc({required this.farmRepository}) : super(const FarmState()) {
    on<FetchFarms>(_onFetchFarms);
  }

  FutureOr<void> _onFetchFarms(
    FetchFarms event,
    Emitter<FarmState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, message: ''));

    try {
      final farms = await farmRepository.getFarmsByUser(event.userId);
      emit(state.copyWith(status: Status.success, farms: farms));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }
}
