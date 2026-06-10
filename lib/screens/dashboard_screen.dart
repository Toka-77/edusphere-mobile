import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/auth/auth_bloc.dart';
import '../logic/auth/auth_state.dart';
import '../logic/dashboard/dashboard_bloc.dart';
import '../logic/dashboard/dashboard_event.dart';
import '../logic/dashboard/dashboard_state.dart';
import '../logic/notification/notification_bloc.dart';
import '../logic/notification/notification_state.dart';
import '../data/models/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_theme.dart';
import 'home_screen.dart';
import 'grades_screen.dart';
import 'timetable_screen.dart';
import 'add_drop_screen.dart';
import 'login_screen.dart';
import 'attendance_qr_screen.dart';
import 'settings_screen.dart';
import 'notifications_screen.dart';

// ── Data ─────────────────────────────────────────────────────────

class _StatItem {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String trend;
  final bool trendUp;
  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.trend,
    required this.trendUp,
  });
}

class _ClassItem {
  final String name;
  final String sub;
  final String time;
  final String status;
  final Color statusColor;
  final Color dotColor;
  const _ClassItem({
    required this.name,
    required this.sub,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.dotColor,
  });
}

class _GradeItem {
  final String code;
  final String task;
  final int pct;
  final Color color;
  const _GradeItem(
      {required this.code,
        required this.task,
        required this.pct,
        required this.color});
}

// ── Dashboard Screen ─────────────────────────────────────────────

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  bool _showNotif = false;
  Timer? _qrTimer;
  int _qrSeconds = 300;
  late AnimationController _qrPulse;

  // ✅ Pending Tasks removed
  final List<_StatItem> _stats = const [
    _StatItem(
        icon: Icons.menu_book_outlined,
        iconColor: AppTheme.primary,
        label: 'Total Courses',
        value: '6',
        trend: 'This Sem',
        trendUp: true),
    _StatItem(
        icon: Icons.emoji_events_outlined,
        iconColor: AppTheme.blue,
        label: 'Average GPA',
        value: '3.8',
        trend: '+0.2 pts',
        trendUp: true),
    _StatItem(
        icon: Icons.calendar_today_outlined,
        iconColor: AppTheme.orange,
        label: 'Classes Today',
        value: '4',
        trend: 'On Track',
        trendUp: true),
  ];

  final List<_ClassItem> _classes = const [
    _ClassItem(
        name: 'Advanced Web Development',
        sub: 'Dr. Sarah Hassan • CS 431',
        time: '09:00 AM',
        status: 'Live Now',
        statusColor: AppTheme.primary,
        dotColor: AppTheme.primary),
    _ClassItem(
        name: 'Database Systems',
        sub: 'Dr. Ahmed Ali • CS 412',
        time: '11:00 AM',
        status: 'Upcoming',
        statusColor: AppTheme.info,
        dotColor: AppTheme.info),
    _ClassItem(
        name: 'Machine Learning',
        sub: 'Dr. Layla Nour • IT Lab 411',
        time: '07:00 PM',
        status: 'Scheduled',
        statusColor: AppTheme.purple,
        dotColor: AppTheme.purple),
  ];

  final List<_GradeItem> _grades = const [
    _GradeItem(
        code: 'CS431', task: 'Project 3', pct: 95, color: Color(0xFF00C853)),
    _GradeItem(
        code: 'MATH301', task: 'Midterm Exam', pct: 38, color: AppTheme.primary),
    _GradeItem(
        code: 'ENG101', task: 'Essay', pct: 92, color: Color(0xFF00C853)),
  ];

  final List<Map<String, dynamic>> _notifs = [
    {
      'icon': Icons.schedule_outlined,
      'color': const Color(0xFFF59E0B),
      'title': 'Class Starting Soon',
      'sub': 'Advanced Web Dev starts in 15 minutes',
      'time': '15 min ago',
      'isNew': true,
    },
    {
      'icon': Icons.grade_outlined,
      'color': const Color(0xFF10B981),
      'title': 'Grade Posted',
      'sub': 'CS431 Project 3 grade is now available',
      'time': '1 hour ago',
      'isNew': true,
    },
    {
      'icon': Icons.warning_amber_outlined,
      'color': AppTheme.primary,
      'title': 'Attendance Warning',
      'sub': 'Your attendance in CS402 is below 80%',
      'time': '1 day ago',
      'isNew': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _qrPulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _qrTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_qrSeconds > 0) setState(() => _qrSeconds--);
    });

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      if (user.studentNumericId != null) {
        context.read<DashboardBloc>().add(LoadDashboard(user.studentNumericId!));
      }
    }
  }

  @override
  void dispose() {
    _qrTimer?.cancel();
    _qrPulse.dispose();
    super.dispose();
  }

  String get _qrTimerStr {
    final m = _qrSeconds ~/ 60;
    final s = _qrSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool get _isDark => themeModeNotifier.value == ThemeMode.dark;

  Color _card(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark ? AppTheme.darkCard : Colors.white;

  Color _border(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark ? AppTheme.darkBorder : AppTheme.border;

  Color _txt(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark ? AppTheme.darkText : AppTheme.textPrimary;

  Color _txtSec(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark ? AppTheme.darkTextSec : AppTheme.textSecondary;

  void _showSearch(BuildContext ctx) {
    final isDark = Theme.of(ctx).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkCard : Colors.white;
    final txt2 = _txt(ctx);
    final txtSec2 = _txtSec(ctx);
    final borderC = _border(ctx);

    showDialog(
      context: ctx,
      builder: (dialogCtx) {
        String query = '';
        final items = [
          {'label': 'Dashboard', 'icon': '📊', 'desc': 'Main overview'},
          {'label': 'Attendance QR', 'icon': '📷', 'desc': 'QR attendance'},
          {'label': 'Grades', 'icon': '📈', 'desc': 'Academic grades'},
          {'label': 'Timetable', 'icon': '📅', 'desc': 'Class schedule'},
          {'label': 'Student Services', 'icon': '👥', 'desc': 'Medical, complaints'},
          {'label': 'Curriculum', 'icon': '📚', 'desc': 'Course plan'},
          {'label': 'Records', 'icon': '📄', 'desc': 'Academic records'},
          {'label': 'AI Assistant', 'icon': '🤖', 'desc': 'Chat with AI'},
          {'label': 'Settings', 'icon': '⚙️', 'desc': 'Preferences'},
        ];
        return StatefulBuilder(builder: (dialogCtx, setS) {
          final results = query.isNotEmpty
              ? items
              .where((i) => (i['label']! + i['desc']!)
              .toLowerCase()
              .contains(query.toLowerCase()))
              .toList()
              : <Map<String, String>>[];
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: cardBg,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    style: TextStyle(color: txt2),
                    decoration: InputDecoration(
                      hintText: 'Search anything...',
                      hintStyle: TextStyle(color: txtSec2),
                      prefixIcon: Icon(Icons.search, color: txtSec2),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: borderC),
                          borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: borderC),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppTheme.primary, width: 2),
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (v) => setS(() => query = v),
                  ),
                  if (results.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ...results.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(children: [
                        Text(item['icon']!, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['label']!,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: txt2)),
                              Text(item['desc']!,
                                  style: TextStyle(fontSize: 12, color: txtSec2)),
                            ],
                          ),
                        ),
                      ]),
                    )),
                  ],
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final card = _card(context);
    final border = _border(context);
    final txt = _txt(context);
    final txtSec = _txtSec(context);
    final authState = context.read<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    final userName = user?.name.toUpperCase() ?? 'STUDENT';
    final userInitials = user?.initials ?? 'ST';
    final userCode = user?.studentCode ?? 'N/A';
    final isDark = _isDark;

    return Scaffold(
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardInitial || state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DashboardError) {
            return Center(child: Text('Failed to load: ${state.message}', style: TextStyle(color: txt)));
          }

          final data = (state as DashboardLoaded).data;
          final newCount = data.unreadNotifCount;

          final dynamicStats = [
            _StatItem(
                icon: Icons.menu_book_outlined,
                iconColor: AppTheme.primary,
                label: 'Total Courses',
                value: data.totalEnrolledCourses.toString(),
                trend: 'This Sem',
                trendUp: true),
            _StatItem(
                icon: Icons.emoji_events_outlined,
                iconColor: AppTheme.blue,
                label: 'Average GPA',
                value: data.cgpa.toStringAsFixed(2),
                trend: '${data.earnedCredits} / ${data.requiredCredits} Cr',
                trendUp: true),
            _StatItem(
                icon: Icons.calendar_today_outlined,
                iconColor: AppTheme.orange,
                label: 'Classes Today',
                value: data.todayClasses.length.toString(),
                trend: 'On Track',
                trendUp: true),
          ];

          final dynamicClasses = data.todayClasses.map((c) {
            Color statusColor = AppTheme.info;
            if (c.status == 'live') statusColor = AppTheme.primary;
            if (c.status == 'done') statusColor = AppTheme.success;
            return _ClassItem(
              name: c.courseName,
              sub: '${c.instructor} • ${c.room}',
              time: c.formattedTime,
              status: c.status == 'live' ? 'Live Now' : (c.status == 'done' ? 'Completed' : 'Upcoming'),
              statusColor: statusColor,
              dotColor: statusColor,
            );
          }).toList();

          final dynamicNotifs = data.notifications.map((n) {
            return {
              'icon': Icons.notifications_outlined,
              'color': AppTheme.primary,
              'title': n.title,
              'sub': n.body,
              'time': n.timeAgo,
              'isNew': !n.isRead,
            };
          }).toList();

          return Stack(
            children: [
              SafeArea(
            child: CustomScrollView(
              slivers: [
                // ── AppBar ────────────────────────────────────────
                SliverAppBar(
                  pinned: true,
                  backgroundColor: card,
                  leading: IconButton(
                    icon: Icon(Icons.menu, color: txt),
                    onPressed: HomeScreen.openDrawer,
                  ),
                  // ✅ FIX: titleSpacing + mainAxisSize.min + Flexible
                  titleSpacing: 0,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Image.asset('assets/images/logo.png',
                              fit: BoxFit.contain),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('EduSphere',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: txt)),
                            Text('Student Portal',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 11, color: txtSec)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      onPressed: () => _showSearch(context),
                      icon: Icon(Icons.search, color: txt),
                    ),
                    IconButton(
                      tooltip: _isDark ? 'Light Mode' : 'Dark Mode',
                      onPressed: () {
                        themeModeNotifier.value =
                        _isDark ? ThemeMode.light : ThemeMode.dark;
                        setState(() {});
                      },
                      icon: Icon(
                        _isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                        color: txt,
                      ),
                    ),
                    // Bell icon — badge from NotificationBloc (real-time)
                    BlocBuilder<NotificationBloc, NotificationState>(
                      builder: (context, notifState) {
                        final liveCount = notifState.unreadCount;
                        return IconButton(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const NotificationsScreen()),
                            );
                          },
                          icon: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(Icons.notifications_outlined, color: txt),
                              if (liveCount > 0)
                                Positioned(
                                  right: -2,
                                  top: -2,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: const BoxDecoration(
                                        color: AppTheme.primary,
                                        shape: BoxShape.circle),
                                    alignment: Alignment.center,
                                    child: Text(
                                      liveCount > 99
                                          ? '99+'
                                          : '$liveCount',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.settings_outlined, color: txt),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const SettingsScreen())),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PopupMenuButton<String>(
                        tooltip: 'User menu',
                        onSelected: (v) {
                          if (v == 'logout') {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  (_) => false,
                            );
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            enabled: false,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(userName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700, color: txt)),
                                  Text('ID: $userCode',
                                      style: TextStyle(fontSize: 11, color: txtSec)),
                                ]),
                          ),
                          const PopupMenuDivider(),
                          const PopupMenuItem(
                            value: 'logout',
                            child: Row(children: [
                              Icon(Icons.logout, color: AppTheme.primary, size: 20),
                              SizedBox(width: 10),
                              Text('Log Out',
                                  style: TextStyle(color: AppTheme.primary)),
                            ]),
                          ),
                        ],
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            gradient: AppTheme.redGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(userInitials,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Body ──────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page Header
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back, ${user?.firstName ?? 'Student'} 👋',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: txt,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Here's what's happening today.",
                                    style: TextStyle(fontSize: 12, color: txtSec),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 128),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _dbQuickBtn(
                                    icon: Icons.table_chart_outlined,
                                    label: 'Timetable',
                                    isPrimary: false,
                                    border: border,
                                    txt: txt,
                                    txtSec: txtSec,
                                    isDark: isDark,
                                    onTap: () => Navigator.push(context,
                                        MaterialPageRoute(builder: (_) => const TimetableScreen())),
                                  ),
                                  const SizedBox(height: 6),
                                  _dbQuickBtn(
                                    icon: Icons.add_circle_outline,
                                    label: 'Add Course',
                                    isPrimary: true,
                                    border: border,
                                    txt: txt,
                                    txtSec: txtSec,
                                    isDark: isDark,
                                    onTap: () => Navigator.push(context,
                                        MaterialPageRoute(builder: (_) => const AddDropScreen())),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Stat cards
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.35,
                          children: dynamicStats
                              .map((s) => _StatCard(item: s, card: card, border: border))
                              .toList(),
                        ),
                        const SizedBox(height: 20),

                        // Today's Classes
                        _sectionHeader("Today's Classes", 'View Schedule', txt, () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const TimetableScreen()));
                        }),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: border),
                          ),
                          child: Column(
                            children: dynamicClasses.isEmpty
                                ? [Padding(padding: const EdgeInsets.all(16), child: Text("No classes today!", style: TextStyle(color: txtSec)))]
                                : dynamicClasses
                                .map((c) => _ClassRow(
                                item: c, txtColor: txt, txtSec: txtSec, border: border))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Recent Grades
                        _sectionHeader('Recent Grades', 'View All', txt, () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const GradesScreen()));
                        }),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: border),
                          ),
                          child: Column(
                            children: _grades
                                .map((g) => _GradeRow(item: g, txtColor: txt, txtSec: txtSec))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Smart Attendance QR Card
                        _QRCard(
                          card: card,
                          border: border,
                          txt: txt,
                          txtSec: txtSec,
                          isDark: isDark,
                          timerStr: _qrTimerStr,
                          pulse: _qrPulse,
                          onScan: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const AttendanceQRScreen())),
                        ),
                        const SizedBox(height: 20),

                        // Quick Actions
                        Text('Quick Actions',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700, color: txt)),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: border),
                          ),
                          child: Column(
                            children: [
                              _QuickAction(
                                icon: Icons.bar_chart_outlined,
                                iconColor: AppTheme.blue,
                                label: 'Check My Grades',
                                border: border,
                                txtColor: txt,
                                onTap: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => const GradesScreen())),
                              ),
                              _QuickAction(
                                icon: Icons.add_circle_outline,
                                iconColor: AppTheme.success,
                                label: 'Add/Drop Courses',
                                border: border,
                                txtColor: txt,
                                onTap: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => const AddDropScreen())),
                              ),
                              _QuickAction(
                                icon: Icons.table_chart_outlined,
                                iconColor: AppTheme.primary,
                                label: 'View Timetable',
                                border: border,
                                txtColor: txt,
                                isLast: true,
                                onTap: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => const TimetableScreen())),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Notification overlay backdrop
          if (_showNotif)
            Positioned(
              top: 0, right: 0, left: 0, bottom: 0,
              child: GestureDetector(
                onTap: () => setState(() => _showNotif = false),
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),
          // Notification panel
          if (_showNotif)
            Positioned(
              top: 100,
              right: 12,
              left: 12,
              child: Material(
                elevation: 12,
                borderRadius: BorderRadius.circular(16),
                color: _card(context),
                child: Container(
                  width: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: border),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Notifications',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: txt)),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  for (final n in _notifs) n['isNew'] = false;
                                  _showNotif = false;
                                });
                              },
                              child: const Text('Mark all read',
                                  style: TextStyle(color: AppTheme.primary, fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                      ...dynamicNotifs.map((n) => _NotifRow(
                          notif: n, border: border, txtColor: txt, txtSec: txtSec)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    }),
  );
}

  Widget _dbQuickBtn({
    required IconData icon,
    required String label,
    required bool isPrimary,
    required Color border,
    required Color txt,
    required Color txtSec,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isPrimary
              ? AppTheme.primary
              : (isDark ? AppTheme.darkBg2 : AppTheme.background),
          borderRadius: BorderRadius.circular(10),
          border: isPrimary ? null : Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: isPrimary ? Colors.white : txtSec),
            const SizedBox(width: 5),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isPrimary ? Colors.white : txt)),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(
      String title, String action, Color txt, VoidCallback onAction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: txt)),
        TextButton(
          onPressed: onAction,
          child: Row(children: [
            Text(action,
                style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward, size: 14, color: AppTheme.primary),
          ]),
        ),
      ],
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final _StatItem item;
  final Color card;
  final Color border;
  const _StatCard({required this.item, required this.card, required this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: item.iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: item.trendUp
                      ? const Color(0xFF00C853).withValues(alpha: 0.12)
                      : AppTheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                        item.trendUp ? Icons.trending_up : Icons.trending_down,
                        size: 11,
                        color: item.trendUp ? const Color(0xFF00C853) : AppTheme.primary),
                    const SizedBox(width: 3),
                    Text(item.trend,
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: item.trendUp
                                ? const Color(0xFF00C853)
                                : AppTheme.primary)),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(item.value,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.darkText
                      : AppTheme.textPrimary)),
          const SizedBox(height: 2),
          Text(item.label,
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

// ── Class Row ─────────────────────────────────────────────────────

class _ClassRow extends StatelessWidget {
  final _ClassItem item;
  final Color txtColor;
  final Color txtSec;
  final Color border;
  const _ClassRow(
      {required this.item,
        required this.txtColor,
        required this.txtSec,
        required this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: border.withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: item.dotColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.check_box_outlined, color: item.dotColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700, color: txtColor)),
                const SizedBox(height: 2),
                Text(item.sub, style: TextStyle(fontSize: 11, color: txtSec)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(item.time,
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600, color: txtColor)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: item.statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(item.status,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: item.statusColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Grade Row ─────────────────────────────────────────────────────

class _GradeRow extends StatelessWidget {
  final _GradeItem item;
  final Color txtColor;
  final Color txtSec;
  const _GradeRow({required this.item, required this.txtColor, required this.txtSec});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.code,
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700, color: txtColor)),
                  Text(item.task, style: TextStyle(fontSize: 11, color: txtSec)),
                ],
              ),
              Text('${item.pct}%',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w800, color: item.color)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: item.pct / 100.0,
              minHeight: 6,
              backgroundColor: item.color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(item.color),
            ),
          ),
        ],
      ),
    );
  }
}

// ── QR Card ───────────────────────────────────────────────────────

class _QRCard extends StatelessWidget {
  final Color card;
  final Color border;
  final Color txt;
  final Color txtSec;
  final bool isDark;
  final String timerStr;
  final AnimationController pulse;
  final VoidCallback onScan;

  const _QRCard({
    required this.card,
    required this.border,
    required this.txt,
    required this.txtSec,
    required this.isDark,
    required this.timerStr,
    required this.pulse,
    required this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Smart Attendance',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w800, color: txt)),
                  const SizedBox(height: 2),
                  Text('Scan QR to mark attendance',
                      style: TextStyle(fontSize: 12, color: txtSec)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, size: 12, color: AppTheme.primary),
                    const SizedBox(width: 4),
                    Text('Expires in $timerStr',
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: AnimatedBuilder(
              animation: pulse,
              builder: (_, child) => Container(
                padding: EdgeInsets.all(8 + pulse.value * 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.2 + pulse.value * 0.15),
                      blurRadius: 16 + pulse.value * 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: child,
              ),
              child: const _QRCodeWidget(),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text('CURRENT: CS402',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                    letterSpacing: 1)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onScan,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 18),
              label: const Text('Scan Now',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple QR code visual
class _QRCodeWidget extends StatelessWidget {
  final List<List<int>> _grid = const [
    [1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1],
    [1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1],
    [1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1],
    [1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1],
    [1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 1],
    [1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
    [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0],
    [0, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1],
    [1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1],
    [0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0],
    [1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0],
    [1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 1],
    [1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0],
    [1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0],
    [1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1],
    [1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1],
    [1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0],
    [1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1],
  ];

  const _QRCodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const size = 140.0;
    const cells = 21;
    const cellSize = size / cells;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _QRPainter(grid: _grid, cellSize: cellSize),
      ),
    );
  }
}

class _QRPainter extends CustomPainter {
  final List<List<int>> grid;
  final double cellSize;
  const _QRPainter({required this.grid, required this.cellSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF0F172A);
    for (int r = 0; r < grid.length; r++) {
      for (int c = 0; c < grid[r].length; c++) {
        if (grid[r][c] == 1) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(c * cellSize + 0.5, r * cellSize + 0.5,
                  cellSize - 1, cellSize - 1),
              const Radius.circular(1),
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_QRPainter old) => false;
}

// ── Quick Action ──────────────────────────────────────────────────

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color border;
  final Color txtColor;
  final bool isLast;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.border,
    required this.txtColor,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(bottom: BorderSide(color: border.withValues(alpha: 0.5))),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: txtColor)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }
}

// ── Notification Row ──────────────────────────────────────────────

class _NotifRow extends StatelessWidget {
  final Map<String, dynamic> notif;
  final Color border;
  final Color txtColor;
  final Color txtSec;
  const _NotifRow(
      {required this.notif,
        required this.border,
        required this.txtColor,
        required this.txtSec});

  @override
  Widget build(BuildContext context) {
    final isNew = notif['isNew'] == true;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isNew
            ? (notif['color'] as Color).withValues(alpha: 0.04)
            : Colors.transparent,
        border: Border(top: BorderSide(color: border.withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: (notif['color'] as Color).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(notif['icon'] as IconData,
                color: notif['color'] as Color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(notif['title'] as String,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: txtColor)),
                    ),
                    if (isNew)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                            color: AppTheme.primary, shape: BoxShape.circle),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(notif['sub'] as String,
                    style: TextStyle(fontSize: 11, color: txtSec)),
                const SizedBox(height: 2),
                Text(notif['time'] as String,
                    style: const TextStyle(
                        fontSize: 10, color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}