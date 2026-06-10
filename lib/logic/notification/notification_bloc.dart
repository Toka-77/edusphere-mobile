import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/dashboard_model.dart';
import '../../data/services/notification_service.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_constants.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final DioClient _dioClient;
  final NotificationService _notifService;
  StreamSubscription<NotifModel>? _wsSub;

  NotificationBloc({
    required DioClient dioClient,
    required NotificationService notifService,
  })  : _dioClient = dioClient,
        _notifService = notifService,
        super(const NotificationState()) {
    on<LoadNotifications>(_onLoad);
    on<MarkAllNotificationsRead>(_onMarkAllRead);
    on<DisconnectNotifications>(_onDisconnect);
    on<WsNotifReceived>(_onWsNotif);
  }

  // ── Handlers ─────────────────────────────────────────────────────

  Future<void> _onLoad(
      LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    // 1. Fetch existing notifications via REST
    final notifs = await _fetchFromApi();
    final unread = notifs.where((n) => !n.isRead).length;
    emit(state.copyWith(
      notifications: notifs,
      unreadCount: unread,
      isLoading: false,
    ));

    // 2. Connect WebSocket (idempotent — won't double-connect)
    await _connectWs(userId: event.userId, token: event.token);
  }

  Future<void> _onMarkAllRead(
      MarkAllNotificationsRead event, Emitter<NotificationState> emit) async {
    try {
      await _dioClient.dio.post(ApiConstants.notificationsMarkRead);
    } catch (_) {}
    // Optimistically update UI
    final updated = state.notifications
        .map((n) => _markRead(n))
        .toList();
    emit(state.copyWith(notifications: updated, unreadCount: 0));
  }

  Future<void> _onDisconnect(
      DisconnectNotifications event, Emitter<NotificationState> emit) async {
    await _wsSub?.cancel();
    _wsSub = null;
    await _notifService.disconnect();
    emit(const NotificationState()); // reset
  }

  void _onWsNotif(
      WsNotifReceived event, Emitter<NotificationState> emit) {
    // Prepend new notification, bump unread count
    final updated = [event.notif, ...state.notifications];
    emit(state.copyWith(
      notifications: updated,
      unreadCount: state.unreadCount + 1,
    ));
  }

  // ── Helpers ──────────────────────────────────────────────────────

  Future<List<NotifModel>> _fetchFromApi() async {
    try {
      final resp = await _dioClient.dio.get(ApiConstants.notifications);
      if (resp.statusCode == 200) {
        final body = resp.data;
        List raw = [];
        if (body is Map && body['data'] is Map) {
          raw = (body['data']['notifications'] as List?) ?? [];
        } else if (body is Map && body['data'] is List) {
          raw = body['data'] as List;
        } else if (body is List) {
          raw = body;
        }
        return raw
            .whereType<Map<String, dynamic>>()
            .map(NotifModel.fromJson)
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<void> _connectWs({required int userId, required String token}) async {
    await _wsSub?.cancel();
    await _notifService.connect(userId: userId, token: token);
    _wsSub = _notifService.notifStream.listen((notif) {
      add(WsNotifReceived(notif));
    });
  }

  /// Returns a copy of [n] with isRead = true.
  NotifModel _markRead(NotifModel n) => NotifModel(
        id: n.id,
        type: n.type,
        title: n.title,
        body: n.body,
        data: n.data,
        isRead: true,
        createdAt: n.createdAt,
      );

  @override
  Future<void> close() {
    _wsSub?.cancel();
    return super.close();
  }
}
