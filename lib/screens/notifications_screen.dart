import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_theme.dart';
import '../data/models/dashboard_model.dart';
import '../logic/notification/notification_bloc.dart';
import '../logic/notification/notification_event.dart';
import '../logic/notification/notification_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.darkCard : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDark ? AppTheme.darkText : AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: isDark ? AppTheme.darkText : AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state.unreadCount == 0) return const SizedBox.shrink();
              return TextButton.icon(
                onPressed: () => context
                    .read<NotificationBloc>()
                    .add(MarkAllNotificationsRead()),
                icon: Icon(Icons.done_all,
                    size: 18,
                    color: AppTheme.primary),
                label: Text(
                  'Mark all read',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: isDark ? AppTheme.darkBorder : AppTheme.border,
          ),
        ),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.notifications.isEmpty) {
            return _EmptyState(isDark: isDark);
          }

          // Split into unread / read
          final unread =
              state.notifications.where((n) => !n.isRead).toList();
          final read =
              state.notifications.where((n) => n.isRead).toList();

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              if (unread.isNotEmpty) ...[
                _SectionHeader(
                    label: 'NEW', count: unread.length, isDark: isDark),
                const SizedBox(height: 8),
                ...unread.map((n) =>
                    _NotifTile(notif: n, isDark: isDark)),
                const SizedBox(height: 16),
              ],
              if (read.isNotEmpty) ...[
                _SectionHeader(label: 'EARLIER', isDark: isDark),
                const SizedBox(height: 8),
                ...read.map((n) =>
                    _NotifTile(notif: n, isDark: isDark)),
              ],
            ],
          );
        },
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final int? count;
  final bool isDark;

  const _SectionHeader({required this.label, this.count, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: isDark ? AppTheme.darkTextSec : AppTheme.textSecondary,
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Notification tile ─────────────────────────────────────────────

class _NotifTile extends StatelessWidget {
  final NotifModel notif;
  final bool isDark;

  const _NotifTile({required this.notif, required this.isDark});

  IconData _iconFor(String type) {
    switch (type) {
      case 'grade_published':
        return Icons.bar_chart;
      case 'attendance_warning':
        return Icons.warning_amber_rounded;
      case 'schedule_change':
        return Icons.calendar_today;
      case 'registration_open':
        return Icons.app_registration;
      case 'complaint_update':
        return Icons.feedback_outlined;
      case 'excuse_update':
        return Icons.medical_services_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _colorFor(String type) {
    switch (type) {
      case 'grade_published':
        return const Color(0xFF3B82F6);
      case 'attendance_warning':
        return const Color(0xFFF59E0B);
      case 'schedule_change':
        return const Color(0xFF8B5CF6);
      case 'registration_open':
        return const Color(0xFF10B981);
      case 'complaint_update':
        return const Color(0xFFEC4899);
      case 'excuse_update':
        return const Color(0xFF06B6D4);
      default:
        return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppTheme.darkCard : Colors.white;
    final titleColor = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final bodyColor = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final timeColor = isDark ? AppTheme.darkTextLight : AppTheme.textLight;
    final iconColor = _colorFor(notif.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: notif.isRead
              ? (isDark ? AppTheme.darkBorder : AppTheme.border)
              : iconColor.withValues(alpha: 0.35),
          width: notif.isRead ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon bubble
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_iconFor(notif.type), color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: notif.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: titleColor,
                          ),
                        ),
                      ),
                      if (!notif.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: iconColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.body,
                    style: TextStyle(fontSize: 13, color: bodyColor, height: 1.5),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notif.timeAgo,
                    style: TextStyle(fontSize: 11, color: timeColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_outlined,
              size: 40,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'All caught up!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? AppTheme.darkText : AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No notifications yet.\nCheck back later.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppTheme.darkTextSec : AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
