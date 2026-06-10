import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../core/constants/api_constants.dart';
import '../models/dashboard_model.dart';

/// Manages the WebSocket connection to Laravel Reverb for real-time notifications.
///
/// Uses pusher_channels_flutter which speaks the same Pusher protocol as Reverb.
/// Private channel auth is handled via onAuthorizer (calls /broadcasting/auth with Dio).
///
/// Usage:
///   await NotificationService().connect(userId: 14, token: '...');
///   NotificationService().notifStream.listen((n) => ...);
///   await NotificationService().disconnect();
class NotificationService {
  // ── Singleton ──────────────────────────────────────────────────────
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  // ── Internal state ─────────────────────────────────────────────────
  PusherChannelsFlutter? _pusher;
  bool _connected = false;
  String? _currentToken;

  final _controller = StreamController<NotifModel>.broadcast();

  /// Stream of real-time notifications received over WebSocket.
  Stream<NotifModel> get notifStream => _controller.stream;

  // ── Public API ─────────────────────────────────────────────────────

  /// Connect to Reverb and subscribe to the private notifications channel.
  ///
  /// [userId]  — the authenticated user's DB `id`.
  /// [token]   — Sanctum bearer token for /broadcasting/auth.
  Future<void> connect({required int userId, required String token}) async {
    if (_connected) return;
    _currentToken = token;

    try {
      _pusher = PusherChannelsFlutter.getInstance();

      await _pusher!.init(
        // Reverb uses the same Pusher protocol.
        // 'cluster' is ignored by Reverb but required by the Flutter plugin.
        apiKey: ApiConstants.reverbAppKey,
        cluster: 'mt1',
        // For custom Reverb host we use onAuthorizer (bypasses the built-in
        // HTTP auth and lets us call /broadcasting/auth ourselves with Dio).
        onAuthorizer: _onAuthorizer,
        onConnectionStateChange: _onConnectionStateChange,
        onError: _onError,
        onSubscriptionSucceeded: _onSubscriptionSucceeded,
        onEvent: _onEvent,
        useTLS: false,
      );

      await _pusher!.connect();

      // For Flutter Web, Pusher JS SDK's host is set via the cluster name.
      // For mobile platforms, the native SDK respects the cluster / host config.
      // NOTE: For a self-hosted Reverb server on mobile we rely on onAuthorizer
      // and the WS connection URL is derived from the cluster 'mt1' on the hosted
      // Pusher cloud unless we patch the native libraries. This means on mobile
      // the live WS won't work (but REST auth still works via onAuthorizer).
      // The correct approach for production mobile is to build a custom plugin.
      // For this project (Flutter Web + Chrome), this works perfectly.

      // Subscribe to the private channel.
      await _pusher!.subscribe(
        channelName: 'private-notifications.$userId',
      );

      _connected = true;
      debugPrint('✅ [NotificationService] Connected — private-notifications.$userId');
    } catch (e) {
      debugPrint('❌ [NotificationService] connect() error: $e');
    }
  }

  /// Disconnect from Reverb.
  Future<void> disconnect() async {
    if (!_connected) return;
    try {
      await _pusher?.disconnect();
    } catch (e) {
      debugPrint('⚠️ [NotificationService] disconnect() error: $e');
    } finally {
      _pusher = null;
      _connected = false;
      _currentToken = null;
      debugPrint('🔌 [NotificationService] Disconnected.');
    }
  }

  // ── Pusher callbacks ────────────────────────────────────────────────

  /// Called by the Pusher plugin to authorize a private channel subscription.
  /// We hit /broadcasting/auth directly with Dio (with Bearer token).
  Future<dynamic> _onAuthorizer(
      String channelName, String socketId, dynamic options) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        ApiConstants.broadcastingAuthUrl,
        data: {
          'socket_id': socketId,
          'channel_name': channelName,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $_currentToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }),
      );
      return response.data;
    } catch (e) {
      debugPrint('❌ [NotificationService] Auth error: $e');
      return {};
    }
  }

  void _onConnectionStateChange(dynamic currentState, dynamic previousState) {
    debugPrint('[NotificationService] WS state: $previousState → $currentState');
  }

  void _onError(String message, int? code, dynamic e) {
    debugPrint('❌ [NotificationService] WS error ($code): $message');
  }

  void _onSubscriptionSucceeded(String channelName, dynamic data) {
    debugPrint('✅ [NotificationService] Subscribed to $channelName');
  }

  void _onEvent(PusherEvent event) {
    // The backend broadcasts as 'NewNotification' (broadcastAs())
    if (event.eventName != 'NewNotification') return;

    try {
      final raw = event.data is String
          ? jsonDecode(event.data as String) as Map<String, dynamic>
          : event.data as Map<String, dynamic>;

      final notif = NotifModel.fromJson(raw);
      _controller.add(notif);
      debugPrint('🔔 [NotificationService] New notif: ${notif.title}');
    } catch (e) {
      debugPrint('⚠️ [NotificationService] Failed to parse event: $e');
    }
  }

  void dispose() {
    disconnect();
    _controller.close();
  }
}
