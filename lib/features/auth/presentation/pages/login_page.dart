
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ganlink/core/enums/status.dart';
import 'package:ganlink/features/auth/data/register_service.dart';
import 'package:ganlink/features/auth/presentation/blocs/login_bloc.dart';
import 'package:ganlink/features/auth/presentation/blocs/login_event.dart';
import 'package:ganlink/features/auth/presentation/blocs/login_state.dart';
import 'package:ganlink/features/auth/presentation/blocs/register_bloc.dart';
import 'package:ganlink/features/auth/presentation/pages/register_page.dart';
import 'package:ganlink/features/main/main_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case Status.success:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) => context.read<LoginBloc>().add(
                        OnUsernameChanged(username: value),
                      ),
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Username",
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: BlocSelector<LoginBloc, LoginState, bool>(
                      selector: (state) => state.isPasswordVisible,
                      builder: (context, isPasswordVisible) => TextField(
                        onChanged: (value) => context.read<LoginBloc>().add(
                          OnPasswordChanged(password: value),
                        ),
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Password",
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
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => context.read<LoginBloc>().add(Login()),
                        child: Text('Login'),
                      ),
                    ),
                  ),
                  
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => RegisterBloc(
                            service: RegisterService(),
                          ),
                          child: const RegisterPage(),
                        ),
                      ),
                    ),
                    child: const Text("Register"),
                  ),
                ],
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