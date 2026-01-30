import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  // Configuration
  static const bool isPhysicalDevice = false;
  static const String _ipAddress = '192.168.1.1'; // change if needed
  static const int _port = 5000;

  // Host resolver
  static String get _host {
    if (isPhysicalDevice) return _ipAddress;
    if (kIsWeb) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    if (Platform.isIOS) return 'localhost';
    return 'localhost';
  }

  
  static String get baseUrl => 'http://$_host:$_port';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  // Fixed: function to include userId
  static String updateProfile = '/api/auth/update-profile';
}