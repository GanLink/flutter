import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ganlink/core/blocs/auth_bloc.dart';
import 'package:ganlink/core/blocs/auth_state.dart';
import 'package:ganlink/core/enums/status.dart';
import 'package:ganlink/features/farm/presentation/blocs/farm_form_bloc.dart';
import 'package:ganlink/features/farm/presentation/blocs/farm_form_event.dart';
import 'package:ganlink/features/farm/presentation/blocs/farm_form_state.dart';
import 'package:ganlink/features/farm/repositories/farm_repository.dart';

class CreateFarmPage extends StatefulWidget {
  const CreateFarmPage({super.key});

  @override
  State<CreateFarmPage> createState() => _CreateFarmPageState();
}

class _CreateFarmPageState extends State<CreateFarmPage> {
  late final TextEditingController _aliasController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _ownerDniController;

  @override
  void initState() {
    super.initState();
    _aliasController = TextEditingController();
    _descriptionController = TextEditingController();
    _ownerDniController = TextEditingController();
  }

  @override
  void dispose() {
    _aliasController.dispose();
    _descriptionController.dispose();
    _ownerDniController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext ctx) {
    final authState = ctx.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Sesión no válida')),
      );
      return;
    }

    ctx.read<FarmFormBloc>().add(SubmitFarm(userId: authState.userId));
  }

  void _onClear(BuildContext ctx) {
    _aliasController.clear();
    _descriptionController.clear();
    _ownerDniController.clear();
    ctx.read<FarmFormBloc>().add(const ResetFarmForm());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FarmFormBloc(farmRepository: context.read<FarmRepository>()),
      child: Builder(
        builder: (context) => BlocListener<FarmFormBloc, FarmFormState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == Status.success) {
              context.pop(true); // volver y refrescar
            } else if (state.status == Status.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message.isEmpty ? 'Error al crear la farm' : state.message,
                  ),
                ),
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Registrar Granja'),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Actividad principal: Carne (1: engorde/ceba), Leche (2: ordeño/derivados), Genérica (3: mixta).',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _aliasController,
                        onChanged: (value) => context
                            .read<FarmFormBloc>()
                            .add(AliasChanged(value)),
                        decoration: const InputDecoration(
                          labelText: 'Alias de la granja',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        onChanged: (value) => context
                            .read<FarmFormBloc>()
                            .add(DescriptionChanged(value)),
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<FarmFormBloc, FarmFormState>(
                        buildWhen: (prev, curr) =>
                            prev.mainActivity != curr.mainActivity,
                        builder: (context, state) {
                          final selected = state.mainActivity;
                          return InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Actividad principal',
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                isExpanded: true,
                                value: selected,
                                hint: const Text('Selecciona la actividad'),
                                items: const [
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Text('Carne (1: engorde/ceba)'),
                                  ),
                                  DropdownMenuItem(
                                    value: 2,
                                    child: Text('Leche (2: ordeño/derivados)'),
                                  ),
                                  DropdownMenuItem(
                                    value: 3,
                                    child: Text('Genérica (3: mixta)'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    context
                                        .read<FarmFormBloc>()
                                        .add(ActivityChanged(value));
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _ownerDniController,
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                        onChanged: (value) => context
                            .read<FarmFormBloc>()
                            .add(OwnerDniChanged(value)),
                        decoration: const InputDecoration(
                          labelText: 'DNI del propietario',
                          counterText: '',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () => _onSave(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            ),
                            child: const Text('Guardar'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: () => _onClear(context),
                            child: const Text('Limpiar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                BlocSelector<FarmFormBloc, FarmFormState, bool>(
                  selector: (state) => state.status == Status.loading,
                  builder: (context, isLoading) {
                    if (!isLoading) return const SizedBox.shrink();
                    return Container(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceVariant
                          .withOpacity(0.3),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
