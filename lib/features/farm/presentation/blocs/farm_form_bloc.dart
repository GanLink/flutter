import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ganlink/core/enums/status.dart';
import 'package:ganlink/features/farm/presentation/blocs/farm_form_event.dart';
import 'package:ganlink/features/farm/presentation/blocs/farm_form_state.dart';
import 'package:ganlink/features/farm/repositories/farm_repository.dart';

class FarmFormBloc extends Bloc<FarmFormEvent, FarmFormState> {
  final FarmRepository farmRepository;

  FarmFormBloc({required this.farmRepository})
      : super(const FarmFormState()) {
    on<AliasChanged>(
      (event, emit) => emit(state.copyWith(alias: event.alias)),
    );
    on<DescriptionChanged>(
      (event, emit) => emit(state.copyWith(description: event.description)),
    );
    on<ActivityChanged>(
      (event, emit) => emit(state.copyWith(mainActivity: event.activity)),
    );
    on<OwnerDniChanged>(
      (event, emit) => emit(state.copyWith(ownerDni: event.ownerDni)),
    );
    on<ResetFarmForm>(_onReset);
    on<SubmitFarm>(_onSubmitFarm);
  }

  FutureOr<void> _onReset(
    ResetFarmForm event,
    Emitter<FarmFormState> emit,
  ) {
    emit(const FarmFormState());
  }

  bool _isValidOwnerDni(String dni) => dni.length == 8;

  FutureOr<void> _onSubmitFarm(
    SubmitFarm event,
    Emitter<FarmFormState> emit,
  ) async {
    // Validaciones simples
    if (state.alias.trim().isEmpty ||
        state.description.trim().isEmpty ||
        state.mainActivity == null ||
        state.ownerDni.trim().isEmpty) {
      emit(state.copyWith(
        status: Status.failure,
        message: 'Todos los campos son obligatorios.',
      ));
      return;
    }

    if (!_isValidOwnerDni(state.ownerDni.trim())) {
      emit(state.copyWith(
        status: Status.failure,
        message: 'El DNI debe tener 8 dígitos.',
      ));
      return;
    }

    emit(state.copyWith(status: Status.loading, message: '', createdFarm: null));

    try {
      final farm = await farmRepository.createFarm(
        alias: state.alias.trim(),
        description: state.description.trim(),
        mainActivity: state.mainActivity!,
        ownerDni: state.ownerDni.trim(),
        userId: event.userId,
      );

      emit(state.copyWith(
        status: Status.success,
        createdFarm: farm,
        message: 'Farm creada correctamente',
      ));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }
}
