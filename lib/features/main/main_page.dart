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
import 'package:ganlink/features/bovinue/repositories/bovinue_repository.dart';
import 'package:ganlink/core/navigation/app_routes.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _totalBovinues = 0;
  bool _loadingBovinues = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchFarms());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchFarms() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      // Reset bovine count to trigger reload
      setState(() {
        _totalBovinues = 0;
        _loadingBovinues = false;
      });
      context.read<FarmBloc>().add(FetchFarms(userId: authState.userId));
    }
  }

  Future<void> _loadBovinueCounts(List<Farm> farms) async {
    if (_loadingBovinues || farms.isEmpty) return;

    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return;

    setState(() => _loadingBovinues = true);

    try {
      final bovinueRepo = context.read<BovinueRepository>();
      int total = 0;

      for (final farm in farms) {
        final bovinues = await bovinueRepo.getBovinuesByFarmId(
          farm.id,
          authState.token,
        );
        total += bovinues.length;
      }

      if (mounted) {
        setState(() {
          _totalBovinues = total;
          _loadingBovinues = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingBovinues = false);
      }
    }
  }

  void _onAddFarm() {
    context.push(AppRoutes.createFarm).then((created) {
      if (created == true) {
        _fetchFarms();
      }
    });
  }

  List<Farm> _filterFarms(List<Farm> farms) {
    if (_searchQuery.isEmpty) return farms;
    return farms
        .where((farm) =>
            farm.alias.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            farm.description.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = context.watch<AuthBloc>().state;
    final username = authState is Authenticated ? authState.username : 'Usuario';

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header con logo y menú
            SliverToBoxAdapter(
              child: _buildHeader(theme, username),
            ),

            // Barra de búsqueda
            SliverToBoxAdapter(
              child: _buildSearchBar(theme),
            ),

            // Estadísticas
            SliverToBoxAdapter(
              child: BlocBuilder<FarmBloc, FarmState>(
                builder: (context, state) {
                  return _buildStatsSection(theme, state);
                },
              ),
            ),

            // Título de sección
            SliverToBoxAdapter(
              child: _buildSectionTitle(theme),
            ),

            // Lista de granjas
            BlocBuilder<FarmBloc, FarmState>(
              builder: (context, state) {
                return _buildFarmsList(theme, state);
              },
            ),

            // Espacio para FAB
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddFarm,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Granja'),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, String username) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
      child: Row(
        children: [
          // Logo y nombre
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.tertiary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.agriculture,
                    color: theme.colorScheme.onPrimary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GanLink',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Hola, $username',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Menú de opciones
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.person_outline,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            tooltip: 'Opciones',
            onSelected: (value) {
              if (value == 'settings') {
                context.push('/farm/settings');
              } else if (value == 'logout') {
                context.read<LoginBloc>().add(const ResetLogin());
                context.read<AuthBloc>().add(const UserLoggedOut());
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, color: theme.colorScheme.onSurface),
                    const SizedBox(width: 12),
                    const Text('Configuración'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: theme.colorScheme.error),
                    const SizedBox(width: 12),
                    Text('Cerrar Sesión', style: TextStyle(color: theme.colorScheme.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Buscar granjas...',
          hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildStatsSection(ThemeData theme, FarmState state) {
    final farmCount = state.farms.length;

    // Trigger bovine count loading when farms are loaded
    if (state.status == Status.success && state.farms.isNotEmpty && _totalBovinues == 0 && !_loadingBovinues) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadBovinueCounts(state.farms);
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.agriculture,
              label: 'Granjas',
              value: '$farmCount',
              color: theme.colorScheme.primary,
              theme: theme,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.pets,
              label: 'Bovinos',
              value: _loadingBovinues ? '...' : '$_totalBovinues',
              color: theme.colorScheme.tertiary,
              theme: theme,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.trending_up,
              label: 'Activos',
              value: '$farmCount',
              color: theme.colorScheme.secondary,
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Mis Granjas',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          BlocBuilder<FarmBloc, FarmState>(
            builder: (context, state) {
              final filteredCount = _filterFarms(state.farms).length;
              final totalCount = state.farms.length;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _searchQuery.isNotEmpty ? '$filteredCount de $totalCount' : '$totalCount',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFarmsList(ThemeData theme, FarmState state) {
    switch (state.status) {
      case Status.loading:
        return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        );
      case Status.failure:
        return SliverFillRemaining(
          child: _ErrorView(
            message: state.message.isEmpty ? 'No se pudieron cargar las granjas' : state.message,
            onRetry: _fetchFarms,
            theme: theme,
          ),
        );
      case Status.success:
        final filteredFarms = _filterFarms(state.farms);
        if (state.farms.isEmpty) {
          return SliverFillRemaining(
            child: _EmptyState(
              onAddFarm: _onAddFarm,
              theme: theme,
            ),
          );
        }
        if (filteredFarms.isEmpty) {
          return SliverFillRemaining(
            child: _NoResultsState(theme: theme),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final farm = filteredFarms[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ModernFarmCard(
                    farm: farm,
                    theme: theme,
                    onTap: () {
                      context.push(
                        AppRoutes.farmDetail.replaceFirst(':id', '${farm.id}'),
                        extra: farm,
                      ).then((deleted) {
                        if (deleted == true) {
                          _fetchFarms();
                        }
                      });
                    },
                  ),
                );
              },
              childCount: filteredFarms.length,
            ),
          ),
        );
      case Status.initial:
        return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final ThemeData theme;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernFarmCard extends StatelessWidget {
  final Farm farm;
  final ThemeData theme;
  final VoidCallback? onTap;

  const _ModernFarmCard({
    required this.farm,
    required this.theme,
    this.onTap,
  });

  String _getActivityName(String activity) {
    switch (activity) {
      case '0':
        return 'Carne';
      case '1':
        return 'Leche';
      case '2':
        return 'Genérica';
      case 'CARNE':
        return 'Carne';
      case 'LECHE':
        return 'Leche';
      case 'GENERICA':
        return 'Genérica';
      default:
        return activity.isNotEmpty ? activity : 'Sin definir';
    }
  }

  Color _getActivityColor() {
    switch (farm.mainActivity) {
      case '0':
      case 'CARNE':
        return Colors.red.shade400;
      case '1':
      case 'LECHE':
        return Colors.blue.shade400;
      case '2':
      case 'GENERICA':
        return Colors.orange.shade400;
      default:
        return theme.colorScheme.tertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Icono de la granja
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.agriculture,
                  color: theme.colorScheme.primary,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              // Información de la granja
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      farm.alias,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      farm.description.isNotEmpty ? farm.description : 'Sin descripción',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Chip de actividad
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getActivityColor().withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getActivityName(farm.mainActivity),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _getActivityColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Flecha
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAddFarm;
  final ThemeData theme;

  const _EmptyState({required this.onAddFarm, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.agriculture_outlined,
                size: 64,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '¡Bienvenido a GanLink!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Comienza registrando tu primera granja para gestionar tu ganado de manera eficiente.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onAddFarm,
              icon: const Icon(Icons.add),
              label: const Text('Crear mi primera granja'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoResultsState extends StatelessWidget {
  final ThemeData theme;

  const _NoResultsState({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No se encontraron granjas',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Intenta con otro término de búsqueda',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
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
  final ThemeData theme;

  const _ErrorView({
    required this.message,
    required this.onRetry,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Algo salió mal',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
