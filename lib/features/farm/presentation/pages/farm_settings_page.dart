import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ganlink/core/blocs/theme_bloc.dart';
import 'package:ganlink/core/navigation/app_routes.dart';

class FarmSettingsPage extends StatefulWidget {
  const FarmSettingsPage({super.key});

  @override
  State<FarmSettingsPage> createState() => _FarmSettingsPageState();
}

class _FarmSettingsPageState extends State<FarmSettingsPage> {
  bool _notificationsEnabled = true;
  bool _autoSyncEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _autoSyncEnabled = prefs.getBool('auto_sync_enabled') ?? true;
      _isLoading = false;
    });
  }

  Future<void> _saveNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() => _notificationsEnabled = value);
  }

  Future<void> _saveAutoSync(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_sync_enabled', value);
    setState(() => _autoSyncEnabled = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _buildSectionTitle(theme, 'General'),
          SwitchListTile(
            title: Text('Notificaciones', style: TextStyle(color: theme.colorScheme.onSurface)),
            subtitle: Text('Recibir alertas de la granja', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
            value: _notificationsEnabled,
            onChanged: _saveNotifications,
            secondary: Icon(
              Icons.notifications_outlined,
              color: theme.colorScheme.primary,
            ),
          ),
          const Divider(indent: 72),
          // Modo oscuro usando ThemeBloc
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return SwitchListTile(
                title: Text('Modo Oscuro', style: TextStyle(color: theme.colorScheme.onSurface)),
                subtitle: Text('Cambiar apariencia de la app', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                value: themeState.isDarkMode,
                onChanged: (value) {
                  context.read<ThemeBloc>().add(SetDarkMode(value));
                },
                secondary: Icon(
                  Icons.dark_mode_outlined,
                  color: theme.colorScheme.primary,
                ),
              );
            },
          ),
          const Divider(indent: 72),
          SwitchListTile(
            title: Text('Sincronización Automática', style: TextStyle(color: theme.colorScheme.onSurface)),
            subtitle: Text('Sincronizar datos con el servidor', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
            value: _autoSyncEnabled,
            onChanged: _saveAutoSync,
            secondary: Icon(
              Icons.sync_outlined,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(theme, 'Información'),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: theme.colorScheme.primary,
            ),
            title: Text('Versión', style: TextStyle(color: theme.colorScheme.onSurface)),
            subtitle: Text('0.1.0', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          ),
          const Divider(indent: 72),
          ListTile(
            leading: Icon(
              Icons.description_outlined,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              'Términos y Condiciones',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
            onTap: () {
              context.push(AppRoutes.termsAndConditions);
            },
          ),
          const Divider(indent: 72),
          ListTile(
            leading: Icon(
              Icons.privacy_tip_outlined,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              'Política de Privacidad',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
            onTap: () {
              context.push(AppRoutes.privacyPolicy);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
