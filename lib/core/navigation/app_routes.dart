/// Rutas de la aplicación
/// Define todas las rutas como constantes para evitar typos
class AppRoutes {
  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String confirmRegister = '/confirm-register';

  // Main routes
  static const String home = '/';
  static const String main = '/main';

  // Farm routes
  static const String createFarm = '/farm/create';
  static const String farmDetail = '/farm/:id';
  static const String farmSettings = '/farm/settings';

  // Legal routes
  static const String termsAndConditions = '/legal/terms';
  static const String privacyPolicy = '/legal/privacy';

  // Bovinue routes
  static const String bovinueForm = '/bovinue/crear/:farmId';
  static const String bovinueDetails = '/bovinue/:bovinueId';
  static const String bovinueMetricsInfo = '/bovinue/metricas-info';
  static const String bovinueSuccess = '/bovinue/success/:farmId';
}
