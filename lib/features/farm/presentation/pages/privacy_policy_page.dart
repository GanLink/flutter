import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Política de Privacidad'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Política de Privacidad',
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
              '1. Información que Recopilamos',
              'Recopilamos información necesaria para el funcionamiento de la aplicación, incluyendo datos de granjas, ganado bovino y métricas relacionadas con la producción.',
            ),
            _buildSection(
              theme,
              '2. Uso de la Información',
              'La información recopilada se utiliza únicamente para proporcionar los servicios de la aplicación y mejorar la experiencia del usuario.',
            ),
            _buildSection(
              theme,
              '3. Protección de Datos',
              'Implementamos medidas de seguridad técnicas y administrativas para proteger su información contra acceso no autorizado, alteración, divulgación o destrucción.',
            ),
            _buildSection(
              theme,
              '4. Compartir Información',
              'No vendemos, alquilamos ni compartimos su información personal con terceros, excepto cuando sea necesario para proporcionar los servicios solicitados.',
            ),
            _buildSection(
              theme,
              '5. Sus Derechos',
              'Usted tiene derecho a acceder, corregir, eliminar o portar sus datos personales. Puede ejercer estos derechos contactándonos a través de la aplicación.',
            ),
            _buildSection(
              theme,
              '6. Cambios a esta Política',
              'Podemos actualizar esta política de privacidad periódicamente. Le notificaremos sobre cambios significativos a través de la aplicación.',
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Si tiene preguntas sobre esta política, contacte al soporte técnico.',
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