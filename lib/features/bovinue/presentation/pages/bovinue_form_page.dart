import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/enums/status.dart';
import '../blocs/bovinue_form_bloc.dart';
import '../blocs/bovinue_form_event.dart';
import '../blocs/bovinue_form_state.dart';
import '../widgets/metric_input_card.dart';

class BovinueFormPage extends StatefulWidget {
  final int farmId;
  final String token;

  const BovinueFormPage({
    super.key,
    required this.farmId,
    required this.token,
  });

  @override
  State<BovinueFormPage> createState() => _BovinueFormPageState();
}

class _BovinueFormPageState extends State<BovinueFormPage> {
  @override
  void initState() {
    super.initState();
    context.read<BovinueFormBloc>().add(const InitializeForm());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Bovino'),
      ),
      body: BlocConsumer<BovinueFormBloc, BovinueFormState>(
        listener: (context, state) {
          if (state.status == Status.success && state.createdBovinue != null) {
            context.push('/bovinue/success/${widget.farmId}');
          } else if (state.status == Status.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.metrics.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Descripción
                      Text(
                        'Selecciona el tipo de bovino y registra las métricas clave del animal para tomar mejores decisiones productivas.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Tipo de Bovino
                      Text(
                        'Tipo de Bovino',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<BovinueType>(
                        // ignore: deprecated_member_use
                        value: state.bovinueType,
                        dropdownColor: theme.colorScheme.surface,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Seleccionar tipo',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest,
                        ),
                        items: BovinueType.values
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(
                                    type.displayName,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<BovinueFormBloc>()
                                .add(ChangeBovinueType(value));
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      // Métricas productivas header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Métricas productivas',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                context.push('/bovinue/metricas-info'),
                            child: Text(
                              'Ver información',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Lista de métricas
                      ...state.metrics.asMap().entries.map((entry) {
                        final index = entry.key;
                        final metric = entry.value;
                        return MetricInputCard(
                          title: metric.title,
                          placeholder: metric.placeholder,
                          checked: metric.checked,
                          value: metric.value,
                          keyboardType: metric.keyboardType,
                          onCheckedChanged: (checked) {
                            context
                                .read<BovinueFormBloc>()
                                .add(ToggleMetric(index));
                          },
                          onValueChanged: (value) {
                            context.read<BovinueFormBloc>().add(
                                  UpdateMetricValue(index: index, value: value),
                                );
                          },
                        );
                      }),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Resumen de selección
                      Text(
                        'Resumen de selección:',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryItem(
                        theme,
                        'Tipo de bovino',
                        state.bovinueType?.displayName ?? '-',
                      ),
                      ...state.metrics.map((metric) => _buildSummaryItem(
                            theme,
                            metric.title,
                            metric.checked && metric.value.isNotEmpty
                                ? metric.value
                                : '-',
                          )),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Botón de enviar
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: state.status == Status.loading || !state.isValid
                        ? null
                        : () {
                            context.read<BovinueFormBloc>().add(
                                  SubmitBovinueForm(
                                    farmId: widget.farmId,
                                    token: widget.token,
                                  ),
                                );
                          },
                    child: state.status == Status.loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('Registrar Bovino'),
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                children: [
                  TextSpan(
                    text: '$label: ',
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      color: value == '-'
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.primary,
                      fontWeight:
                          value == '-' ? FontWeight.normal : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
