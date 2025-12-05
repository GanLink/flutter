import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ganlink/core/blocs/auth_bloc.dart';
import 'package:ganlink/core/blocs/auth_state.dart';
import 'package:ganlink/core/enums/status.dart';
import 'package:ganlink/features/farm/domain/farm.dart';
import 'package:ganlink/features/farm/repositories/farm_repository.dart';
import 'package:ganlink/features/bovinue/domain/bovinue.dart';
import 'package:ganlink/features/bovinue/repositories/bovinue_repository.dart';
import 'package:ganlink/features/bovinue/presentation/widgets/bovinue_card.dart';

class FarmDetailPage extends StatefulWidget {
  final Farm farm;

  const FarmDetailPage({super.key, required this.farm});

  @override
  State<FarmDetailPage> createState() => _FarmDetailPageState();
}

class _FarmDetailPageState extends State<FarmDetailPage> {
  bool _isDeleting = false;
  Status _bovinuesStatus = Status.initial;
  List<Bovinue> _bovinues = [];

  @override
  void initState() {
    super.initState();
    _loadBovinues();
  }

  Future<void> _loadBovinues() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return;

    setState(() => _bovinuesStatus = Status.loading);

    try {
      final repo = context.read<BovinueRepository>();
      final bovinues = await repo.getBovinuesByFarmId(
        widget.farm.id,
        authState.token,
      );
      if (!mounted) return;
      setState(() {
        _bovinues = bovinues;
        _bovinuesStatus = Status.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _bovinuesStatus = Status.failure;
      });
    }
  }

  String _getActivityName(String activity) {
    switch (activity) {
      case '0':
        return 'Carne';
      case '1':
        return 'Leche';
      case '2':
        return 'Genérica';
      // Compatibilidad con valores antiguos de la API
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

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Granja'),
        content: Text(
          '¿Estás seguro de eliminar "${widget.farm.alias}"?\n\nEsta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _deleteFarm();
    }
  }

  Future<void> _deleteFarm() async {
    final repo = context.read<FarmRepository>();
    setState(() => _isDeleting = true);
    try {
      await repo.deleteFarm(widget.farm.id);
      if (!mounted) return;
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: ${e.toString()}')),
      );
    }
  }

  void _navigateToAddBovinue() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return;

    context.push(
      '/bovinue/crear/${widget.farm.id}',
      extra: authState.token,
    ).then((result) {
      if (result == true) {
        _loadBovinues();
      }
    });
  }

  void _navigateToBovinueDetails(Bovinue bovinue) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return;

    context.push(
      '/bovinue/${bovinue.id}',
      extra: authState.token,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final farm = widget.farm;

    return Scaffold(
      appBar: AppBar(
        title: Text(farm.alias),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDelete();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Eliminar granja'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isDeleting
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadBovinues,
              child: CustomScrollView(
                slivers: [
                  // Información de la granja
                  SliverToBoxAdapter(
                    child: Card(
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: theme.colorScheme.primaryContainer,
                                  radius: 24,
                                  child: Icon(
                                    Icons.agriculture,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        farm.alias,
                                        style: theme.textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                      Chip(
                                        label: Text(_getActivityName(farm.mainActivity)),
                                        backgroundColor: theme.colorScheme.secondaryContainer,
                                        labelStyle: TextStyle(
                                          color: theme.colorScheme.onSecondaryContainer,
                                          fontSize: 12,
                                        ),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (farm.description.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Text(
                                farm.description,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                            const Divider(height: 24),
                            Row(
                              children: [
                                Icon(
                                  Icons.badge_outlined,
                                  size: 18,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'DNI Propietario: ${farm.ownerDni}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Título de bovinos
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bovinos',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            '${_bovinues.length} registrados',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Lista de bovinos
                  if (_bovinuesStatus == Status.loading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_bovinuesStatus == Status.failure)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: theme.colorScheme.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error al cargar bovinos',
                              style: TextStyle(color: theme.colorScheme.onSurface),
                            ),
                            const SizedBox(height: 8),
                            FilledButton(
                              onPressed: _loadBovinues,
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (_bovinues.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pets_outlined,
                              size: 64,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Sin bovinos registrados',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Agrega tu primer bovino',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final bovinue = _bovinues[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: BovinueCard(
                                bovinue: bovinue,
                                onTap: () => _navigateToBovinueDetails(bovinue),
                              ),
                            );
                          },
                          childCount: _bovinues.length,
                        ),
                      ),
                    ),

                  // Espacio para el FAB
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddBovinue,
        icon: const Icon(Icons.add),
        label: const Text('Agregar Bovino'),
      ),
    );
  }
}
