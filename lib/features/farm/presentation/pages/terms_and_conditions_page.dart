import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Términos y Condiciones'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Términos y Condiciones',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Última actualización: ${DateTime.now().toString().split(' ')[0]}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              theme,
              '1. Aceptación de los Términos',
              'Al acceder y utilizar esta aplicación, usted acepta estar sujeto a estos términos y condiciones de uso.',
            ),
            _buildSection(
              theme,
              '2. Uso de la Aplicación',
              'Esta aplicación está destinada únicamente para el manejo y monitoreo de ganado bovino en granjas. El uso indebido de la aplicación queda bajo responsabilidad del usuario.',
            ),
            _buildSection(
              theme,
              '3. Privacidad de Datos',
              'Nos comprometemos a proteger su información personal y los datos de su granja de acuerdo con nuestra Política de Privacidad.',
            ),
            _buildSection(
              theme,
              '4. Limitación de Responsabilidad',
              'La aplicación se proporciona "tal cual" sin garantías de ningún tipo. No nos hacemos responsables por daños indirectos o consecuentes.',
            ),
            _buildSection(
              theme,
              '5. Modificaciones',
              'Nos reservamos el derecho de modificar estos términos en cualquier momento. Los cambios serán efectivos inmediatamente después de su publicación.',
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Para más información, contacte al soporte técnico.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}