import 'package:flutter/foundation.dart';

class ApiConstants {
  // Use 127.0.0.1 for Web/iOS Simulator, and 10.0.2.2 for Android Emulator
  static const String baseUrl = kIsWeb
      ? 'http://localhost:8000/api'
      : 'http://10.0.2.2:8000/api';

  // ── Auth endpoints ───────────────────────────────────────────────
  static const String login = '/login';
  static const String logout = '/logout';
  static const String profile = '/v1/profile';

  // ── Notification endpoints ───────────────────────────────────────
  static const String notifications = '/v1/notifications';
  static const String notificationsMarkRead = '/v1/notifications/read-all';

  // ── Laravel Reverb / WebSocket ───────────────────────────────────
  // Matches .env:  REVERB_HOST, REVERB_PORT, REVERB_APP_KEY
  static const String reverbHost = kIsWeb ? 'localhost' : '10.0.2.2';
  static const int    reverbPort = 8080;
  static const String reverbAppKey = 'edusphere-key-2026';
  static const String reverbAppId  = 'edusphere';
  static const String reverbScheme = 'ws'; // 'wss' in production

  /// POST /broadcasting/auth — used by Pusher for private channel auth.
  /// Points at the Laravel HTTP server (port 8000), NOT the Reverb WS server.
  static String get broadcastingAuthUrl =>
      kIsWeb ? 'http://localhost:8000/broadcasting/auth'
             : 'http://10.0.2.2:8000/broadcasting/auth';
}
