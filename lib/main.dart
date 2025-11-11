import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/blocs/auth_bloc.dart';
import 'core/blocs/auth_event.dart';
import 'core/navigation/app_router.dart';
import 'core/services/secure_storage_service.dart';
import 'core/ui/theme.dart';
import 'core/ui/type.dart';
import 'features/auth/data/login_service.dart';
import 'features/auth/data/register_service.dart';
import 'features/auth/repositories/auth_repository.dart';
import 'features/auth/presentation/blocs/login_bloc.dart';

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
    final authRepository = AuthRepository(
      loginService: loginService,
      registerService: registerService,
      storageService: secureStorage,
    );

    // Crear el AuthBloc
    final authBloc = AuthBloc(authRepository: authRepository);

    // Crear el router con el AuthBloc
    final appRouter = AppRouter(
      authRepository: authRepository,
      authBloc: authBloc,
    );

    return MultiBlocProvider(
      providers: [
        // AuthBloc global - maneja el estado de autenticación de toda la app
        BlocProvider.value(
          value: authBloc..add(const AppStarted()), // Verificar sesión al iniciar
        ),
        // LoginBloc - maneja el formulario de login
        BlocProvider(
          create: (context) => LoginBloc(authRepository: authRepository),
        ),
      ],
      child: DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          ColorScheme lightColorScheme;
          ColorScheme darkColorScheme;

          if (lightDynamic != null && darkDynamic != null) {
            lightColorScheme = lightDynamic.harmonized();
            darkColorScheme = darkDynamic.harmonized();
          } else {
            lightColorScheme = lightTheme.colorScheme;
            darkColorScheme = darkTheme.colorScheme;
          }

          return MaterialApp.router(
            title: 'GanLink',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightColorScheme,
              textTheme: textTheme,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkColorScheme,
              textTheme: textTheme,
            ),
            routerConfig: appRouter.router,
          );
        },
      ),
    );
  }
}
