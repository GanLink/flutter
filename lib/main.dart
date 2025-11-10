import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/secure_storage_service.dart';
import 'core/ui/theme.dart';
import 'core/ui/type.dart';
import 'features/auth/data/login_service.dart';
import 'features/auth/data/register_service.dart';
import 'features/auth/repositories/auth_repository.dart';
import 'features/auth/presentation/blocs/login_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';

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

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          // Usa el color dinámico del sistema si está disponible
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          // Usa tus colores predefinidos
          lightColorScheme = lightTheme.colorScheme;
          darkColorScheme = darkTheme.colorScheme;
        }

        return MaterialApp(
          title: 'GanLink Demo',
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
          // themeMode: ThemeMode.dark, // Opcional: fuerza un modo
          home: BlocProvider(
            create: (context) => LoginBloc(authRepository: authRepository),
            child: const LoginPage(),
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GanLink'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Migrando a Flutter!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            FilledButton(onPressed: () {}, child: const Text('Botón de Ejemplo'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
