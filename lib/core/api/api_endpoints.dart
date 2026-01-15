class ApiEndpoints {
  // Base URL for the API
static const String baseUrl = 'http://192.168.1.74:5000';//home wifi 


  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth endpoints
  static const String login = '/auth/login';
  static const String createAccount = '/auth/createaccount';

  // Add more endpoints as needed
}
