import 'package:flutter/foundation.dart';

class ApiConstants {
  // Use 127.0.0.1 for Web/iOS Simulator, and 10.0.2.2 for Android Emulator
  static const String baseUrl = kIsWeb 
      ? 'http://localhost:8000/api' 
      : 'http://10.0.2.2:8000/api';
  
  static const String login = '/login';
  static const String logout = '/logout';
  static const String profile = '/v1/profile';
  
  // Add other endpoints here as you expand
}
