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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create Account',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 32),
                      
                      // Username
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) => context.read<RegisterBloc>().add(
                            OnUsernameChanged(username: value),
                          ),
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Username",
                            hintText: "Enter your username",
                          ),
                        ),
                      ),

                      // First Name
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) => context.read<RegisterBloc>().add(
                            OnFirstNameChanged(firstName: value),
                          ),
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "First Name",
                            hintText: "Enter your first name",
                          ),
                        ),
                      ),

                      // Last Name
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) => context.read<RegisterBloc>().add(
                            OnLastNameChanged(lastName: value),
                          ),
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Last Name",
                            hintText: "Enter your last name",
                          ),
                        ),
                      ),

                      // Email
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) => context.read<RegisterBloc>().add(
                            OnEmailChanged(email: value),
                          ),
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Email",
                            hintText: "Enter your email",
                          ),
                        ),
                      ),

                      // RUC
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) => context.read<RegisterBloc>().add(
                            OnRucChanged(ruc: value),
                          ),
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "RUC",
                            hintText: "Enter your RUC",
                          ),
                        ),
                      ),

                      // Password
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocSelector<RegisterBloc, RegisterState, bool>(
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
                      ),

                      // Register Button
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => context.read<RegisterBloc>().add(
                              const Register(),
                            ),
                            child: const Text('Register'),
                          ),
                        ),
                      ),

                      // Back to Login
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Already have an account? Login"),
                      ),
                    ],
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