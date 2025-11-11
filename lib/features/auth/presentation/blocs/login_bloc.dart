import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ganlink/core/enums/status.dart';
import 'package:ganlink/features/auth/repositories/auth_repository.dart';
import 'package:ganlink/features/auth/presentation/blocs/login_event.dart';
import 'package:ganlink/features/auth/presentation/blocs/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  LoginBloc({required this.authRepository}) : super(LoginState()) {
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
      // El repository guardará automáticamente el token y datos del usuario
      final user = await authRepository.login(
        username: state.username,
        password: state.password,
      );
      
      // Emitir success con el usuario para que LoginPage pueda notificar al AuthBloc
      emit(state.copyWith(status: Status.success, user: user));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  
}