import 'package:equatable/equatable.dart';
import '../../data/models/dashboard_model.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

/// Load existing notifications from REST and start WebSocket.
class LoadNotifications extends NotificationEvent {
  final int userId;
  final String token;
  const LoadNotifications({required this.userId, required this.token});

  @override
  List<Object?> get props => [userId, token];
}

/// Mark all notifications as read (calls PATCH API).
class MarkAllNotificationsRead extends NotificationEvent {}

/// Disconnect the WebSocket (called on logout).
class DisconnectNotifications extends NotificationEvent {}

/// Internal: a new notification arrived over WebSocket.
/// Named without leading underscore so it can cross file boundaries.
class WsNotifReceived extends NotificationEvent {
  final NotifModel notif;
  const WsNotifReceived(this.notif);

  @override
  List<Object?> get props => [notif];
}
