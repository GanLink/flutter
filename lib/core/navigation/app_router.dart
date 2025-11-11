import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ganlink/core/blocs/auth_bloc.dart';
import 'package:ganlink/core/blocs/auth_state.dart';
import 'package:ganlink/core/navigation/app_routes.dart';
import 'package:ganlink/features/auth/presentation/pages/login_page.dart';
import 'package:ganlink/features/auth/presentation/pages/register_page.dart';
import 'package:ganlink/features/auth/presentation/blocs/register_bloc.dart';
import 'package:ganlink/features/auth/repositories/auth_repository.dart';
import 'package:ganlink/features/main/main_page.dart';

/// Notifier para que GoRouter escuche cambios en el AuthBloc
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (_) => notifyListeners(),
    );
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Configuración del router de la aplicación
/// Maneja la navegación y redirecciones basadas en el estado de autenticación
class AppRouter {
  final AuthRepository authRepository;
  final AuthBloc authBloc;
  
  AppRouter({
    required this.authRepository,
    required this.authBloc,
  });

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    
    // Escuchar cambios en el AuthBloc para redirigir automáticamente
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    
    // Redirect basado en el estado de autenticación
    redirect: (BuildContext context, GoRouterState state) {
      // Usar authBloc.state directamente en lugar de context.read()
      // para evitar problemas de timing con el contexto de GoRouter
      final authState = authBloc.state;
      final isAuthenticated = authState is Authenticated;
      final isAuthLoading = authState is AuthLoading;
      
      // Rutas de autenticación
      final isLoginRoute = state.matchedLocation == AppRoutes.login;
      final isRegisterRoute = state.matchedLocation == AppRoutes.register;
      final isAuthRoute = isLoginRoute || isRegisterRoute;

      // Si está cargando, esperar (no redirigir)
      if (isAuthLoading) {
        return null;
      }

      // Si NO está autenticado y trata de acceder a rutas protegidas
      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutes.login;
      }

      // Si YA está autenticado y trata de acceder a login/register
      if (isAuthenticated && isAuthRoute) {
        return AppRoutes.main;
      }

      // No redirigir
      return null;
    },

    routes: [
      // Ruta de Login
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Ruta de Register
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => BlocProvider(
          create: (context) => RegisterBloc(
            authRepository: authRepository,
          ),
          child: const RegisterPage(),
        ),
      ),

      // Ruta principal (protegida)
      GoRoute(
        path: AppRoutes.main,
        name: 'main',
        builder: (context, state) => const MainPage(),
      ),
    ],

    // Página de error
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.error}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(AppRoutes.login),
              child: const Text('Ir a Login'),
            ),
          ],
        ),
      ),
    ),
  );
}
