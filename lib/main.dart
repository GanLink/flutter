import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/blocs/auth_bloc.dart';
import 'core/blocs/auth_event.dart';
import 'core/blocs/theme_bloc.dart';
import 'core/navigation/app_router.dart';
import 'core/services/database_service.dart';
import 'core/services/secure_storage_service.dart';
import 'core/ui/theme.dart';
import 'features/auth/data/login_service.dart';
import 'features/auth/data/logout_service.dart';
import 'features/auth/data/register_service.dart';
import 'features/auth/repositories/auth_repository.dart';
import 'features/auth/presentation/blocs/login_bloc.dart';
import 'features/farm/data/farm_service.dart';
import 'features/farm/presentation/blocs/farm_bloc.dart';
import 'features/farm/repositories/farm_repository.dart';
import 'features/bovinue/data/bovinue_service.dart';
import 'features/bovinue/repositories/bovinue_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Crear las dependencias una sola vez
    final secureStorage = SecureStorageService();
    final databaseService = DatabaseService();
    final loginService = LoginService();
    final registerService = RegisterService();
    final logoutService = LogoutService();
    final farmService = FarmService();
    final bovinueService = BovinueService();

    final authRepository = AuthRepository(
      loginService: loginService,
      registerService: registerService,
      logoutService: logoutService,
      storageService: secureStorage,
    );
    final farmRepository = FarmRepository(
      farmService: farmService,
      databaseService: databaseService,
    );
    final bovinueRepository = BovinueRepository(
      bovinueService: bovinueService,
      databaseService: databaseService,
    );

    // Crear el AuthBloc
    final authBloc = AuthBloc(authRepository: authRepository);

    // Crear el router con el AuthBloc y BovinueRepository
    final appRouter = AppRouter(
      authRepository: authRepository,
      authBloc: authBloc,
      bovinueRepository: bovinueRepository,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: farmRepository),
        RepositoryProvider.value(value: bovinueRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          // ThemeBloc - maneja el tema de la app
          BlocProvider(
            create: (context) => ThemeBloc()..add(const LoadTheme()),
          ),
          // AuthBloc global - maneja el estado de autenticación de toda la app
          BlocProvider.value(
            value: authBloc..add(const AppStarted()),
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
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp.router(
              title: 'GanLink',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeState.themeMode,
              routerConfig: appRouter.router,
            );
          },
        ),
      ),
    );
  }
}
