import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ganlink/core/blocs/auth_bloc.dart';
import 'package:ganlink/core/blocs/auth_state.dart';
import 'package:ganlink/core/navigation/app_routes.dart';
import 'package:ganlink/features/auth/presentation/pages/login_page.dart';
import 'package:ganlink/features/auth/presentation/pages/register_page.dart';
import 'package:ganlink/features/auth/presentation/pages/confirm_register_page.dart';
import 'package:ganlink/features/auth/presentation/blocs/register_bloc.dart';
import 'package:ganlink/features/auth/repositories/auth_repository.dart';
import 'package:ganlink/features/main/main_page.dart';
import 'package:ganlink/features/farm/presentation/pages/create_farm_page.dart';
import 'package:ganlink/features/farm/presentation/pages/farm_detail_page.dart';
import 'package:ganlink/features/farm/presentation/pages/farm_settings_page.dart';
import 'package:ganlink/features/farm/presentation/pages/terms_and_conditions_page.dart';
import 'package:ganlink/features/farm/presentation/pages/privacy_policy_page.dart';
import 'package:ganlink/features/farm/domain/farm.dart';
import 'package:ganlink/features/main/splash_page.dart';
import 'package:ganlink/features/bovinue/presentation/pages/bovinue_form_page.dart';
import 'package:ganlink/features/bovinue/presentation/pages/bovinue_details_page.dart';
import 'package:ganlink/features/bovinue/presentation/pages/bovinue_metrics_info_page.dart';
import 'package:ganlink/features/bovinue/presentation/pages/bovinue_success_page.dart';
import 'package:ganlink/features/bovinue/presentation/blocs/bovinue_form_bloc.dart';
import 'package:ganlink/features/bovinue/presentation/blocs/bovinue_details_bloc.dart';
import 'package:ganlink/features/bovinue/repositories/bovinue_repository.dart';

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
  final BovinueRepository bovinueRepository;

  AppRouter({
    required this.authRepository,
    required this.authBloc,
    required this.bovinueRepository,
  });

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    
    // Escuchar cambios en el AuthBloc para redirigir automáticamente
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    
    // Redirect basado en el estado de autenticación
    redirect: (BuildContext context, GoRouterState state) {
      // Usar authBloc.state directamente en lugar de context.read()
      // para evitar problemas de timing con el contexto de GoRouter
      final authState = authBloc.state;
      final isAuthenticated = authState is Authenticated;
      final isAuthLoading = authState is AuthLoading || authState is AuthInitial;
      
      // Rutas de autenticación
      final isLoginRoute = state.matchedLocation == AppRoutes.login;
      final isRegisterRoute = state.matchedLocation == AppRoutes.register;
      final isConfirmRegisterRoute = state.matchedLocation == AppRoutes.confirmRegister;
      final isAuthRoute = isLoginRoute || isRegisterRoute || isConfirmRegisterRoute;
      final isSplash = state.matchedLocation == AppRoutes.home;

      // Mientras se verifica la sesión, ir/seguir en splash
      if (isAuthLoading) {
        return isSplash ? null : AppRoutes.home;
      }

      // Si está autenticado
      if (isAuthenticated) {
        if (isAuthRoute || isSplash) {
          return AppRoutes.main;
        }
        return null;
      }

      // Si NO está autenticado y trata de acceder a rutas protegidas
      if (!isAuthenticated) {
        if (isAuthRoute) return null;
        return AppRoutes.login;
      }

      // No redirigir
      return null;
    },

    routes: [
      // Splash / carga inicial
      GoRoute(
        path: AppRoutes.home,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

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

      // Ruta de Confirmación de Registro
      GoRoute(
        path: AppRoutes.confirmRegister,
        name: 'confirmRegister',
        builder: (context, state) => const ConfirmRegisterPage(),
      ),

      // Ruta principal (protegida)
      GoRoute(
        path: AppRoutes.main,
        name: 'main',
        builder: (context, state) => const MainPage(),
      ),

      // Ruta para crear farm
      GoRoute(
        path: AppRoutes.createFarm,
        name: 'createFarm',
        builder: (context, state) => const CreateFarmPage(),
      ),

      // Configuración (debe ir ANTES de /farm/:id)
      GoRoute(
        path: AppRoutes.farmSettings,
        name: 'farmSettings',
        builder: (context, state) => const FarmSettingsPage(),
      ),

      // Detalle de farm
      GoRoute(
        path: AppRoutes.farmDetail,
        name: 'farmDetail',
        builder: (context, state) {
          final farmExtra = state.extra as Farm?;
          if (farmExtra == null) {
            return const Scaffold(
              body: Center(child: Text('Farm no encontrada')),
            );
          }
          return FarmDetailPage(farm: farmExtra);
        },
      ),

      // Formulario para crear bovino
      GoRoute(
        path: AppRoutes.bovinueForm,
        name: 'bovinueForm',
        builder: (context, state) {
          final farmId = int.tryParse(state.pathParameters['farmId'] ?? '0') ?? 0;
          final token = state.extra as String? ?? '';
          return BlocProvider(
            create: (context) => BovinueFormBloc(
              bovinueRepository: bovinueRepository,
            ),
            child: BovinueFormPage(farmId: farmId, token: token),
          );
        },
      ),

      // Detalles de bovino
      GoRoute(
        path: AppRoutes.bovinueDetails,
        name: 'bovinueDetails',
        builder: (context, state) {
          final bovinueId = int.tryParse(state.pathParameters['bovinueId'] ?? '0') ?? 0;
          final token = state.extra as String? ?? '';
          return BlocProvider(
            create: (context) => BovinueDetailsBloc(
              bovinueRepository: bovinueRepository,
            ),
            child: BovinueDetailsPage(bovinueId: bovinueId, token: token),
          );
        },
      ),

      // Información sobre métricas
      GoRoute(
        path: AppRoutes.bovinueMetricsInfo,
        name: 'bovinueMetricsInfo',
        builder: (context, state) => const BovinueMetricsInfoPage(),
      ),

      // Éxito al crear bovino
      GoRoute(
        path: AppRoutes.bovinueSuccess,
        name: 'bovinueSuccess',
        builder: (context, state) {
          final farmId = int.tryParse(state.pathParameters['farmId'] ?? '0') ?? 0;
          return BovinueSuccessPage(farmId: farmId);
        },
      ),

      // Términos y Condiciones
      GoRoute(
        path: AppRoutes.termsAndConditions,
        name: 'termsAndConditions',
        builder: (context, state) => const TermsAndConditionsPage(),
      ),

      // Política de Privacidad
      GoRoute(
        path: AppRoutes.privacyPolicy,
        name: 'privacyPolicy',
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
    ],

    // Página de error
    errorBuilder: (context, state) {
      final theme = Theme.of(context);
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(
                'Error: ${state.error}',
                style: TextStyle(fontSize: 18, color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go(AppRoutes.login),
                child: const Text('Ir a Login'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
