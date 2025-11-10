import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ganlink/core/enums/status.dart';
import 'package:ganlink/features/auth/data/login_service.dart';
import 'package:ganlink/features/auth/presentation/blocs/login_event.dart';
import 'package:ganlink/features/auth/presentation/blocs/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginService service;
  LoginBloc({required this.service}) : super(LoginState()) {
    on<OnUsernameChanged>(
      (event, emit) => emit(state.copyWith(username: event.username)),
    );
    on<OnPasswordChanged>(
      (event, emit) => emit(state.copyWith(password: event.password)),
    );

    on<TogglePasswordVisibility>(
      (event, emit) =>
          emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible)),
    );

    on<Login>(_login);
  }
  FutureOr<void> _login(Login event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: Status.loading));
  
    try {
      await service.login(state.username, state.password);
      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  
}