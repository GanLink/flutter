class ApiConstants {
  static const String baseUrl = 'http://172.172.70.138';

  // Auth endpoints
  static const String registerEndpoint = '/api/v1/Authorization/sign-up';
  static const String loginEndpoint = '/api/v1/Authorization/sign-in';
  static const String logoutEndpoint = '/api/v1/Authorization/sign-out';

  // Farm endpoints
  static const String farmEndpoint = '/api/v1/Farm';
  static String userFarmsEndpoint(int userId) =>
      '/api/v1/Farm/users/$userId/farms';
  static String deleteFarmEndpoint(int farmId) => '/api/v1/Farm/$farmId';

  // Bovinue endpoints
  static const String bovinueEndpoint = '/api/v1/bovinue';
  static String bovinuesByFarmEndpoint(int farmId) =>
      '/api/v1/Bovinue/farm/$farmId';

  // Bovinue Metric endpoints
  static const String bovinueMetricEndpoint = '/api/v1/BovinueMetric';
  static String metricsByBovinueEndpoint(int bovinueId) =>
      '/api/v1/BovinueMetric/bovinue/$bovinueId';
  static String updateMetricEndpoint(int metricId) =>
      '/api/v1/BovinueMetric/$metricId';
}
