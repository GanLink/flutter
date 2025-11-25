import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ganlink/core/blocs/auth_bloc.dart';
import 'package:ganlink/core/blocs/auth_event.dart';
import 'package:ganlink/core/blocs/auth_state.dart';
import 'package:ganlink/core/enums/status.dart';
import 'package:go_router/go_router.dart';
import 'package:ganlink/features/auth/presentation/blocs/login_bloc.dart';
import 'package:ganlink/features/auth/presentation/blocs/login_event.dart';
import 'package:ganlink/features/farm/domain/farm.dart';
import 'package:ganlink/features/farm/presentation/blocs/farm_bloc.dart';
import 'package:ganlink/features/farm/presentation/blocs/farm_event.dart';
import 'package:ganlink/features/farm/presentation/blocs/farm_state.dart';
import 'package:ganlink/core/navigation/app_routes.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchFarms());
  }

  void _fetchFarms() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<FarmBloc>().add(FetchFarms(userId: authState.userId));
    }
  }

  void _onAddFarm() {
    context.push(AppRoutes.createFarm).then((created) {
      if (created == true) {
        _fetchFarms();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final username = authState is Authenticated ? authState.username : 'Usuario';

    return Scaffold(
      appBar: AppBar(
        title: const Text('GanLink'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<LoginBloc>().add(const ResetLogin());
              context.read<AuthBloc>().add(const UserLoggedOut());
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WelcomeBanner(username: username),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<FarmBloc, FarmState>(
                  builder: (context, state) {
                    final farmCount = state.farms.length;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Farms',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            _FarmCountBadge(count: farmCount),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(child: _buildFarmsContent(state)),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddFarm,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFarmsContent(FarmState state) {
    switch (state.status) {
      case Status.loading:
        return const Center(child: CircularProgressIndicator());
      case Status.failure:
        return _ErrorView(
          message: state.message.isEmpty ? 'No se pudieron cargar las farms' : state.message,
          onRetry: _fetchFarms,
        );
      case Status.success:
        if (state.farms.isEmpty) {
          return const SizedBox.shrink();
        }
        return ListView.separated(
          itemCount: state.farms.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _FarmCard(
              farm: state.farms[index],
              onTap: () {
                context.push(
                  AppRoutes.farmDetail.replaceFirst(':id', '${state.farms[index].id}'),
                  extra: state.farms[index],
                ).then((deleted) {
                  if (deleted == true) {
                    _fetchFarms();
                  }
                });
              },
            );
          },
        );
      case Status.initial:
        return const SizedBox.shrink();
    }
  }
}

class _WelcomeBanner extends StatelessWidget {
  final String username;

  const _WelcomeBanner({required this.username});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Center(
        child: Text(
          'Welcome, $username 👋',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimaryContainer,
              ),
        ),
      ),
    );
  }
}

class _FarmCountBadge extends StatelessWidget {
  final int count;

  const _FarmCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$count',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _FarmCard extends StatelessWidget {
  final Farm farm;
  final VoidCallback? onTap;

  const _FarmCard({required this.farm, this.onTap});

  String _formatActivity(String value) {
    if (value.isEmpty) return 'N/A';
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    height: 90,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.agriculture,
                            size: 60,
                            color: colorScheme.primary,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    farm.alias,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.grey.shade800,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    farm.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 40, color: Colors.red),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
