class ApiConstants {
  static final String baseUrl = 'http://10.0.2.2:5081';
  static final String registerEndpoint = '/api/v1/Authorization/sign-up';
  static final String loginEndpoint = '/api/v1/Authorization/sign-in';
  static final String farmEndpoint = '/api/v1/Farm';
  static String userFarmsEndpoint(int userId) =>
      '/api/v1/Farm/users/$userId/farms';
}
