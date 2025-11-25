import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ganlink/core/blocs/auth_bloc.dart';
import 'package:ganlink/core/blocs/auth_event.dart';
import 'package:ganlink/core/blocs/auth_state.dart';
import 'package:ganlink/features/auth/presentation/blocs/login_bloc.dart';
import 'package:ganlink/features/auth/presentation/blocs/login_event.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener datos del usuario del AuthBloc
    final authState = context.watch<AuthBloc>().state;
    final username = authState is Authenticated ? authState.username : 'Usuario';

    return Scaffold(
      appBar: AppBar(
        title: const Text('GanLink - Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Resetear el estado del LoginBloc antes de hacer logout
              context.read<LoginBloc>().add(const ResetLogin());
              
              // Notificar al AuthBloc que el usuario hizo logout
              context.read<AuthBloc>().add(const UserLoggedOut());
              // GoRouter redirigirá automáticamente a /login
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              '¡Bienvenido $username!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Has iniciado sesión correctamente',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Esta funcionalidad estará disponible pronto'),
                  ),
                );
              },
              icon: const Icon(Icons.explore),
              label: const Text('Explorar'),
            ),
          ],
        ),
      ),
    );
  }
}
