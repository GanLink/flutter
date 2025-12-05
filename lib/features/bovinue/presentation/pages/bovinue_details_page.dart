import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/enums/status.dart';
import '../../domain/bovinue_metric.dart';
import '../../domain/update_bovinue_metric.dart';
import '../blocs/bovinue_details_bloc.dart';
import '../blocs/bovinue_details_event.dart';
import '../blocs/bovinue_details_state.dart';

class BovinueDetailsPage extends StatefulWidget {
  final int bovinueId;
  final String token;

  const BovinueDetailsPage({
    super.key,
    required this.bovinueId,
    required this.token,
  });

  @override
  State<BovinueDetailsPage> createState() => _BovinueDetailsPageState();
}

class _BovinueDetailsPageState extends State<BovinueDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<BovinueDetailsBloc>().add(
          LoadBovinueDetails(
            bovinueId: widget.bovinueId,
            token: widget.token,
          ),
        );
  }

  String _formatDate(String isoDate) {
    if (isoDate.isEmpty) return '';
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd MMM yyyy', 'es').format(date);
    } catch (e) {
      return isoDate;
    }
  }

  void _showEditDialog(BovinueMetric metric) {
    final controller = TextEditingController(text: metric.quantity.toString());

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Editar ${metric.parameterName}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Valor',
            hintText: 'Ingrese el nuevo valor',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final newValue = int.tryParse(controller.text);
              if (newValue != null) {
                context.read<BovinueDetailsBloc>().add(
                      UpdateMetric(
                        metric: UpdateBovinueMetric(
                          id: metric.id,
                          bovinueId: metric.bovinueId,
                          bovinueMPId: metric.bovinueMPId,
                          date: DateTime.now().toUtc().toIso8601String(),
                          quantity: newValue,
                        ),
                        token: widget.token,
                      ),
                    );
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bovino #${widget.bovinueId}'),
      ),
      body: BlocBuilder<BovinueDetailsBloc, BovinueDetailsState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == Status.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar datos',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      context.read<BovinueDetailsBloc>().add(
                            LoadBovinueDetails(
                              bovinueId: widget.bovinueId,
                              token: widget.token,
                            ),
                          );
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state.metrics.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sin métricas registradas',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<BovinueDetailsBloc>().add(
                    RefreshMetrics(
                      bovinueId: widget.bovinueId,
                      token: widget.token,
                    ),
                  );
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.metrics.length,
              itemBuilder: (context, index) {
                final metric = state.metrics[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    onTap: () => _showEditDialog(metric),
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.analytics,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    title: Text(
                      metric.parameterName.isNotEmpty
                          ? metric.parameterName
                          : 'Métrica ${metric.bovinueMPId}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (metric.categoryName.isNotEmpty)
                          Text(
                            'Categoría: ${metric.categoryName}',
                            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        Text(
                          'Fecha: ${_formatDate(metric.date)}',
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${metric.quantity}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.edit,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                    isThreeLine: metric.categoryName.isNotEmpty,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
