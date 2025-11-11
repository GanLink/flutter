
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ganlink/core/blocs/auth_bloc.dart';
import 'package:ganlink/core/blocs/auth_event.dart';
import 'package:ganlink/core/enums/status.dart';
import 'package:ganlink/core/navigation/app_routes.dart';
import 'package:ganlink/features/auth/presentation/blocs/login_bloc.dart';
import 'package:ganlink/features/auth/presentation/blocs/login_event.dart';
import 'package:ganlink/features/auth/presentation/blocs/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case Status.success:
            // Notificar al AuthBloc global que el usuario hizo login
            if (state.user != null) {
              context.read<AuthBloc>().add(UserLoggedIn(
                userId: state.user!.id,
                username: state.user!.username,
                token: state.user!.token,
              ));
              // GoRouter redirigirá automáticamente a /main
            }
            break;
          case Status.failure:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message.isEmpty ? 'Login failed' : state.message,
                ),
              ),
            );
            break;
          default:
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo circular
                        Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primaryContainer,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Placeholder mientras no haya imagen
                                  return Icon(
                                    Icons.business,
                                    size: 60,
                                    color: Theme.of(context).colorScheme.primary,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 48),
                        
                        // Username field
                        TextField(
                          onChanged: (value) => context.read<LoginBloc>().add(
                            OnUsernameChanged(username: value),
                          ),
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Username",
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Password field
                        BlocSelector<LoginBloc, LoginState, bool>(
                          selector: (state) => state.isPasswordVisible,
                          builder: (context, isPasswordVisible) => TextField(
                            onChanged: (value) => context.read<LoginBloc>().add(
                              OnPasswordChanged(password: value),
                            ),
                            autocorrect: false,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () => context.read<LoginBloc>().add(
                                  TogglePasswordVisibility(),
                                ),
                                icon: Icon(
                                  !isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            obscureText: !isPasswordVisible,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Login button
                        SizedBox(
                          height: 48,
                          child: FilledButton(
                            onPressed: () => context.read<LoginBloc>().add(Login()),
                            child: const Text('Login'),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Register link
                        Center(
                          child: TextButton(
                            onPressed: () {
                              context.go(AppRoutes.register);
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                children: [
                                  const TextSpan(text: "Don't have an account? "),
                                  TextSpan(
                                    text: "Register",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            BlocSelector<LoginBloc, LoginState, bool>(
              selector: (state) => state.status == Status.loading,
              builder: (context, isLoading) {
                if (isLoading) {
                  return Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withValues(alpha: 0.5),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}