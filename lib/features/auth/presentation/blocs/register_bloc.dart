import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ganlink/core/enums/status.dart';
import 'package:ganlink/features/auth/data/register_service.dart';
import 'package:ganlink/features/auth/presentation/blocs/register_event.dart';
import 'package:ganlink/features/auth/presentation/blocs/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterService service;
  
  RegisterBloc({required this.service}) : super(RegisterState()) {
    on<OnUsernameChanged>(
      (event, emit) => emit(state.copyWith(username: event.username)),
    );
    
    on<OnFirstNameChanged>(
      (event, emit) => emit(state.copyWith(firstName: event.firstName)),
    );
    
    on<OnLastNameChanged>(
      (event, emit) => emit(state.copyWith(lastName: event.lastName)),
    );
    
    on<OnEmailChanged>(
      (event, emit) => emit(state.copyWith(email: event.email)),
    );
    
    on<OnRucChanged>(
      (event, emit) => emit(state.copyWith(ruc: event.ruc)),
    );
    
    on<OnPasswordChanged>(
      (event, emit) => emit(state.copyWith(password: event.password)),
    );

    on<TogglePasswordVisibility>(
      (event, emit) =>
          emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible)),
    );

    on<Register>(_register);
  }

  FutureOr<void> _register(Register event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: Status.loading));

    try {
      final message = await service.register(
        username: state.username,
        firstName: state.firstName,
        lastName: state.lastName,
        email: state.email,
        ruc: state.ruc,
        password: state.password,
      );
      emit(state.copyWith(status: Status.success, message: message));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }
}
