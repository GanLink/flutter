import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ganlink/core/enums/status.dart';
import 'package:ganlink/features/auth/presentation/blocs/register_bloc.dart';
import 'package:ganlink/features/auth/presentation/blocs/register_event.dart';
import 'package:ganlink/features/auth/presentation/blocs/register_state.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case Status.success:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message.isEmpty
                      ? 'Registration successful! Please login.'
                      : state.message,
                ),
                backgroundColor: Colors.green,
              ),
            );
            // Navegar de vuelta al login
            Navigator.pop(context);
            break;
          case Status.failure:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message.isEmpty ? 'Registration failed' : state.message,
                ),
                backgroundColor: Colors.red,
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
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo circular
                        Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primaryContainer,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.business,
                                    size: 50,
                                    color: Theme.of(context).colorScheme.primary,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        Text(
                          'Create Account',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 32),
                      
                        // Username
                        TextField(
                          onChanged: (value) => context.read<RegisterBloc>().add(
                            OnUsernameChanged(username: value),
                          ),
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Username",
                            hintText: "Enter your username",
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // First Name
                        TextField(
                          onChanged: (value) => context.read<RegisterBloc>().add(
                            OnFirstNameChanged(firstName: value),
                          ),
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "First Name",
                            hintText: "Enter your first name",
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Last Name
                        TextField(
                          onChanged: (value) => context.read<RegisterBloc>().add(
                            OnLastNameChanged(lastName: value),
                          ),
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Last Name",
                            hintText: "Enter your last name",
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Email
                        TextField(
                          onChanged: (value) => context.read<RegisterBloc>().add(
                            OnEmailChanged(email: value),
                          ),
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Email",
                            hintText: "Enter your email",
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // RUC
                        TextField(
                          onChanged: (value) => context.read<RegisterBloc>().add(
                            OnRucChanged(ruc: value),
                          ),
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "RUC",
                            hintText: "Enter your RUC",
                            prefixIcon: Icon(Icons.business_outlined),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Password
                        BlocSelector<RegisterBloc, RegisterState, bool>(
                          selector: (state) => state.isPasswordVisible,
                          builder: (context, isPasswordVisible) => TextField(
                            onChanged: (value) => context.read<RegisterBloc>().add(
                              OnPasswordChanged(password: value),
                            ),
                            autocorrect: false,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "Password",
                              hintText: "Enter your password",
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () => context.read<RegisterBloc>().add(
                                  const TogglePasswordVisibility(),
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

                        // Register Button
                        SizedBox(
                          height: 48,
                          child: FilledButton(
                            onPressed: () => context.read<RegisterBloc>().add(
                              const Register(),
                            ),
                            child: const Text('Register'),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Back to Login
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                children: [
                                  const TextSpan(text: "Already have an account? "),
                                  TextSpan(
                                    text: "Login",
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

            // Loading Indicator
            BlocSelector<RegisterBloc, RegisterState, bool>(
              selector: (state) => state.status == Status.loading,
              builder: (context, isLoading) {
                if (isLoading) {
                  return Container(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.5),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}