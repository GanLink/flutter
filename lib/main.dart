import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/blocs/auth_bloc.dart';
import 'core/blocs/auth_event.dart';
import 'core/navigation/app_router.dart';
import 'core/services/secure_storage_service.dart';
import 'core/ui/theme.dart';
import 'features/auth/data/login_service.dart';
import 'features/auth/data/register_service.dart';
import 'features/auth/repositories/auth_repository.dart';
import 'features/auth/presentation/blocs/login_bloc.dart';
import 'features/farm/data/farm_service.dart';
import 'features/farm/presentation/blocs/farm_bloc.dart';
import 'features/farm/repositories/farm_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Crear las dependencias una sola vez
    final secureStorage = SecureStorageService();
    final loginService = LoginService();
    final registerService = RegisterService();
    final farmService = FarmService();
    final authRepository = AuthRepository(
      loginService: loginService,
      registerService: registerService,
      storageService: secureStorage,
    );
    final farmRepository = FarmRepository(farmService: farmService);

    // Crear el AuthBloc
    final authBloc = AuthBloc(authRepository: authRepository);

    // Crear el router con el AuthBloc
    final appRouter = AppRouter(
      authRepository: authRepository,
      authBloc: authBloc,
    );

    return RepositoryProvider.value(
      value: farmRepository,
      child: MultiBlocProvider(
        providers: [
          // AuthBloc global - maneja el estado de autenticación de toda la app
          BlocProvider.value(
            value: authBloc..add(const AppStarted()), // Verificar sesión al iniciar
          ),
          // LoginBloc - maneja el formulario de login
          BlocProvider(
            create: (context) => LoginBloc(authRepository: authRepository),
          ),
          // FarmBloc - maneja el listado de granjas del usuario
          BlocProvider(
            create: (context) => FarmBloc(farmRepository: farmRepository),
          ),
        ],
        child: MaterialApp.router(
          title: 'GanLink',
          theme: lightTheme,
          darkTheme: darkTheme,
          routerConfig: appRouter.router,
        ),
      ),
    );
  }
}
