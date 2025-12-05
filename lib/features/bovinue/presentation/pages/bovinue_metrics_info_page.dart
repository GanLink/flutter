import 'package:flutter/material.dart';

class BovinueMetricsInfoPage extends StatelessWidget {
  const BovinueMetricsInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final metricsInfo = [
      {
        'title': 'Producción de leche por vaca/día',
        'description':
            'Cantidad de leche producida por día medida en litros. Esencial para granjas lecheras y para evaluar la productividad individual.',
        'icon': Icons.water_drop_outlined,
      },
      {
        'title': 'Contenido de grasa y proteína',
        'description':
            'Porcentaje de grasa y proteína en la leche. Indicador de calidad nutricional y valor comercial del producto.',
        'icon': Icons.science_outlined,
      },
      {
        'title': 'Ganancia de peso diaria (GMD)',
        'description':
            'Gramos de peso ganados por día. Métrica clave para evaluar el crecimiento y eficiencia en granjas de engorde.',
        'icon': Icons.trending_up_outlined,
      },
      {
        'title': 'Índice de conversión alimenticia',
        'description':
            'Relación entre alimento consumido y peso ganado. Menor índice indica mayor eficiencia alimentaria.',
        'icon': Icons.restaurant_outlined,
      },
      {
        'title': 'Tasa de preñez',
        'description':
            'Porcentaje de vacas preñadas sobre el total inseminadas. Indicador de eficiencia reproductiva del hato.',
        'icon': Icons.pregnant_woman_outlined,
      },
      {
        'title': 'Tasa de concepción',
        'description':
            'Porcentaje de concepciones exitosas por servicio. Refleja la fertilidad y salud reproductiva del ganado.',
        'icon': Icons.favorite_outline,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de Métricas'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: metricsInfo.length,
        itemBuilder: (context, index) {
          final info = metricsInfo[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      info['icon'] as IconData,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info['title'] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          info['description'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
