import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../theme_provider.dart';
import '../widgets/stat_card.dart';
import 'assignments_screen.dart';
import 'grades_screen.dart';
import 'timetable_screen.dart';
import 'change_password_screen.dart';
import 'login_screen.dart';
import 'add_drop_screen.dart';
import 'home_screen.dart';
import 'records_screen.dart';

// ─────────────────────────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────────────────────────

class _Notif {
  final IconData icon;
  final Color color;
  final String title;
  final String sub;
  final String time;
  final bool isNew;
  const _Notif(
      {required this.icon,
        required this.color,
        required this.title,
        required this.sub,
        required this.time,
        required this.isNew});
}

// ─────────────────────────────────────────────────────────────────
// DashboardScreen
// ─────────────────────────────────────────────────────────────────

class DashboardScreen
    extends StatefulWidget {
  const DashboardScreen(
      {super.key});

  @override
  State<DashboardScreen>
  createState() =>
      _DashboardState();
}

class _DashboardState
    extends State<
        DashboardScreen> {
  bool _showNotif = false;

  final _notifs = const [
    _Notif(
        icon: Icons
            .assignment_outlined,
        color: Color(0xFF3B82F6),
        title:
        'New Assignment Posted',
        sub:
        'Web Development - Project 3 is now available',
        time: '5 min ago',
        isNew: true),
    _Notif(
        icon: Icons.grade_outlined,
        color: Color(0xFF10B981),
        title: 'Grade Updated',
        sub:
        'Your grade for Midterm Exam has been posted',
        time: '1 hour ago',
        isNew: true),
    _Notif(
        icon: Icons.alarm_outlined,
        color: Color(0xFFF59E0B),
        title: 'Class Reminder',
        sub:
        'Advanced JavaScript starts in 30 minutes',
        time: '2 hours ago',
        isNew: false),
    _Notif(
        icon: Icons
            .campaign_outlined,
        color: Color(0xFF8B5CF6),
        title: 'New Announcement',
        sub:
        'Campus will be closed on Friday for maintenance',
        time: '1 day ago',
        isNew: false),
  ];

  // ── helpers ──────────────────────────────────────────────────────
  bool get _isDark =>
      themeModeNotifier.value ==
          ThemeMode.dark;

  Color _card(BuildContext ctx) =>
      Theme.of(ctx).brightness ==
          Brightness.dark
          ? AppTheme.darkCard
          : Colors.white;

  Color _border(
      BuildContext ctx) =>
      Theme.of(ctx).brightness ==
          Brightness.dark
          ? AppTheme.darkBorder
          : AppTheme.border;

  Color _txt(BuildContext ctx) =>
      Theme.of(ctx).brightness ==
          Brightness.dark
          ? AppTheme.darkText
          : AppTheme.textPrimary;
  // ── search dialog ──────────────────────────────────────────────────
  void _showSearch(BuildContext ctx, Color txt) {
    final isDark = Theme.of(ctx).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkCard : Colors.white;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    showDialog(
      context: ctx,
      builder: (dialogCtx) {
        String query = '';
        final items = [
          {'label': 'Dashboard', 'icon': '📊', 'desc': 'Main overview'},
          {'label': 'Attendance QR', 'icon': '📷', 'desc': 'QR attendance'},
          {'label': 'Student Services', 'icon': '👥', 'desc': 'Medical, complaints'},
          {'label': 'Curriculum', 'icon': '📚', 'desc': 'Course plan'},
          {'label': 'Records', 'icon': '📄', 'desc': 'Academic records'},
          {'label': 'Admin Panel', 'icon': '🛡️', 'desc': 'Administration'},
          {'label': 'AI Assistant', 'icon': '🤖', 'desc': 'Chat with AI'},
          {'label': 'Settings', 'icon': '⚙️', 'desc': 'Preferences'},
        ];
        return StatefulBuilder(builder: (dialogCtx, setS) {
          final results = query.isNotEmpty
              ? items.where((i) =>
                  (i['label']! + i['desc']!).toLowerCase().contains(query.toLowerCase())).toList()
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
                    style: TextStyle(color: txt),
                    decoration: InputDecoration(
                      hintText: 'Search anything...',
                      hintStyle: TextStyle(color: txtSec),
                      prefixIcon: Icon(Icons.search, color: txtSec),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['label']!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: txt)),
                                Text(item['desc']!, style: TextStyle(fontSize: 12, color: txtSec)),
                              ],
                            )),
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

  // ── build ─────────────────────────────────────────────────────────
  @override
  Widget build(
      BuildContext context) {
    final card = _card(context);
    final border =
    _border(context);
    final txt = _txt(context);
    final newCount = _notifs
        .where((n) => n.isNew)
        .length;

    return Scaffold(
      body: Stack(
        children: [
          // ── Main scroll ──────────────────────────────────────────
          SafeArea(
            child:
            CustomScrollView(
              slivers: [
                // ── AppBar ─────────────────────────────────────────
                SliverAppBar(
                  pinned: true,
                  backgroundColor: card,
                  leading: IconButton(
                    icon: Icon(Icons.menu, color: txt),
                    onPressed: HomeScreen.openDrawer,
                  ),
                  title: Row(
                      children: [
                        Image.asset(
                              'assets/images/logo.png',
                              width: 52,
                              height: 52,
                              fit: BoxFit.contain),
                        const SizedBox(
                            width:
                            10),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                                'EduSphere',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: txt)),
                            const Text(
                                'Student Portal',
                                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ]),
                  actions: [
                    // 🔍 Search
                    IconButton(
                      onPressed: () => _showSearch(context, txt),
                      icon: Icon(Icons.search, color: txt),
                    ),
                    // 🔔 Notification bell
                    IconButton(
                      onPressed: () =>
                          setState(() =>
                          _showNotif =
                          !_showNotif),
                      icon: Stack(
                        clipBehavior:
                        Clip.none,
                        children: [
                          Icon(
                              Icons
                                  .notifications_outlined,
                              color:
                              txt),
                          Positioned(
                            right:
                            -2,
                            top:
                            -2,
                            child:
                            Container(
                              width:
                              16,
                              height:
                              16,
                              decoration: const BoxDecoration(
                                  color: AppTheme.primary,
                                  shape: BoxShape.circle),
                              alignment:
                              Alignment.center,
                              child: Text(
                                  '$newCount',
                                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ⚙️ Settings popup
                    PopupMenuButton<
                        String>(
                      icon: Icon(
                          Icons
                              .settings_outlined,
                          color:
                          txt),
                      onSelected:
                          (v) {
                        if (v ==
                            'dark') {
                          themeModeNotifier.value = _isDark
                              ? ThemeMode
                              .light
                              : ThemeMode
                              .dark;
                          setState(
                                  () {});
                        } else if (v ==
                            'pass') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ChangePasswordScreen()));
                        } else if (v ==
                            'logout') {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                                  (_) => false);
                        }
                      },
                      itemBuilder:
                          (_) => [
                        PopupMenuItem(
                          value:
                          'dark',
                          child: Row(
                              children: [
                                Icon(_isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, color: AppTheme.info, size: 20),
                                const SizedBox(width: 10),
                                Text(_isDark ? 'Light Mode' : 'Dark Mode'),
                              ]),
                        ),
                        const PopupMenuItem(
                          value:
                          'pass',
                          child: Row(
                              children: [
                                Icon(Icons.lock_outline, color: AppTheme.warning, size: 20),
                                SizedBox(width: 10),
                                Text('Change Password'),
                              ]),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem(
                          value:
                          'logout',
                          child: Row(
                              children: [
                                Icon(Icons.logout, color: AppTheme.primary, size: 20),
                                SizedBox(width: 10),
                                Text('Log Out', style: TextStyle(color: AppTheme.primary)),
                              ]),
                        ),
                      ],
                    ),

                    // Avatar
                    const Padding(
                      padding: EdgeInsets
                          .only(
                          right:
                          12),
                      child:
                      CircleAvatar(
                        radius: 18,
                        backgroundColor:
                        AppTheme
                            .primaryLight,
                        child: Text(
                            'TK',
                            style: TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 12)),
                      ),
                    ),
                  ],
                ),

                // ── Body content ───────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                    const EdgeInsets
                        .all(
                        16),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        // Welcome banner
                        Container(
                          width: double
                              .infinity,
                          padding: const EdgeInsets
                              .all(
                              20),
                          decoration:
                          BoxDecoration(
                            gradient:
                            const LinearGradient(
                              colors: [
                                AppTheme.primary,
                                AppTheme.primaryDark
                              ],
                              begin:
                              Alignment.topLeft,
                              end:
                              Alignment.bottomRight,
                            ),
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child:
                          const Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Welcome back,',
                                  style: TextStyle(color: Colors.white70, fontSize: 14)),
                              SizedBox(
                                  height: 4),
                              Text(
                                  'Toka Khaled! 👋',
                                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                              SizedBox(
                                  height: 4),
                              Text(
                                  "Here's what's happening with your classes today.",
                                  style: TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                        const SizedBox(
                            height:
                            20),

                        // Stat cards
                        GridView
                            .count(
                          shrinkWrap:
                          true,
                          physics:
                          const NeverScrollableScrollPhysics(),
                          crossAxisCount:
                          2,
                          crossAxisSpacing:
                          12,
                          mainAxisSpacing:
                          12,
                          childAspectRatio:
                          1.5,
                          children: [
                            StatCard(
                                icon: Icons.menu_book_outlined,
                                iconColor: AppTheme.primary,
                                label: 'Total Courses',
                                value: '6',
                                trending: true),
                            StatCard(
                                icon: Icons.emoji_events_outlined,
                                iconColor: AppTheme.info,
                                label: 'Average GPA',
                                value: '3.8',
                                trending: true),
                            StatCard(
                                icon: Icons.calendar_today_outlined,
                                iconColor: AppTheme.warning,
                                label: 'Classes Today',
                                value: '4'),
                            StatCard(
                                icon: Icons.access_time_outlined,
                                iconColor: AppTheme.orange,
                                label: 'Pending Tasks',
                                value: '4'),
                          ],
                        ),
                        const SizedBox(
                            height:
                            20),

                        // Today's classes
                        Text(
                            "Today's Classes",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: txt)),
                        const SizedBox(
                            height:
                            12),
                        _ClassCard(
                            title:
                            'Advanced Web Development',
                            location:
                            'Tech Building 201',
                            time:
                            '09:00 AM',
                            badge:
                            'Starting Soon',
                            badgeColor: AppTheme
                                .primary,
                            iconBg: AppTheme
                                .primaryLight,
                            iconColor: AppTheme
                                .primary,
                            cardColor:
                            card,
                            borderColor:
                            border),
                        const SizedBox(
                            height:
                            8),
                        _ClassCard(
                            title:
                            'Database Systems',
                            location:
                            'Tech Building 305',
                            time:
                            '11:00 AM',
                            iconBg: const Color(
                                0xFFF3F4F6),
                            iconColor: AppTheme
                                .textSecondary,
                            cardColor:
                            card,
                            borderColor:
                            border),
                        const SizedBox(
                            height:
                            8),
                        _ClassCard(
                            title:
                            'Machine Learning',
                            location:
                            'AI Lab 401',
                            time:
                            '02:00 PM',
                            iconBg: const Color(
                                0xFFF3F4F6),
                            iconColor: AppTheme
                                .textSecondary,
                            cardColor:
                            card,
                            borderColor:
                            border),
                        const SizedBox(
                            height:
                            20),

                        // Recent grades
                        Text(
                            'Recent Grades',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: txt)),
                        const SizedBox(
                            height:
                            12),
                        _GradeCard(
                            course:
                            'CS401',
                            task:
                            'Project 2',
                            pct:
                            0.95,
                            grade:
                            '95%',
                            color: AppTheme
                                .success,
                            cardColor:
                            card,
                            borderColor:
                            border),
                        const SizedBox(
                            height:
                            8),
                        _GradeCard(
                            course:
                            'MATH301',
                            task:
                            'Midterm Exam',
                            pct:
                            0.88,
                            grade:
                            '88%',
                            color: AppTheme
                                .info,
                            cardColor:
                            card,
                            borderColor:
                            border),
                        const SizedBox(
                            height:
                            8),
                        _GradeCard(
                            course:
                            'ENG201',
                            task:
                            'Essay 1',
                            pct:
                            0.92,
                            grade:
                            '92%',
                            color: AppTheme
                                .success,
                            cardColor:
                            card,
                            borderColor:
                            border),
                        const SizedBox(
                            height:
                            20),

                        // Pending Assignments header
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          children: [
                            Text(
                                'Pending Assignments',
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: txt)),
                            TextButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const AssignmentsScreen())),
                              child: const Text(
                                  'View All',
                                  style: TextStyle(color: AppTheme.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                        const SizedBox(
                            height:
                            8),

                        // Pending assignment cards
                        ...[
                          {'title': 'Web Development Project 3',  'course': 'CS401',  'due': 'Due Dec 15', 'priority': 'High Priority',   'pColor': AppTheme.primary, 'aColor': AppTheme.primary},
                          {'title': 'Linear Algebra Problem Set', 'course': 'MATH301','due': 'Due Dec 18', 'priority': 'Medium Priority', 'pColor': AppTheme.warning, 'aColor': AppTheme.warning},
                          {'title': 'Technical Writing Essay',    'course': 'ENG201', 'due': 'Due Dec 20', 'priority': 'Medium Priority', 'pColor': AppTheme.warning, 'aColor': AppTheme.warning},
                          {'title': 'Database Design Project',    'course': 'CS402',  'due': 'Due Dec 22', 'priority': 'Low Priority',    'pColor': AppTheme.success, 'aColor': AppTheme.orange},
                        ].expand((item) => [
                          _SimplePendingCard(
                            title:         item['title'] as String,
                            course:        item['course'] as String,
                            dueDate:       item['due'] as String,
                            priority:      item['priority'] as String,
                            priorityColor: item['pColor'] as Color,
                            accentColor:   item['aColor'] as Color,
                            cardColor:     card,
                            borderColor:   border,
                          ),
                          const SizedBox(height: 8),
                        ]),

                        const SizedBox(
                            height:
                            20),

                        // Quick Actions
                        Text(
                            'Quick Actions',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: txt)),
                        const SizedBox(
                            height:
                            12),
                        Row(
                            children: [
                              Expanded(
                                  child: _ActionBtn(label: 'View Assignments', borderColor: border, txtColor: txt, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AssignmentsScreen())))),
                              const SizedBox(
                                  width: 8),
                              Expanded(
                                  child: _ActionBtn(label: 'Check My Grades', borderColor: border, txtColor: txt, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GradesScreen())))),
                            ]),
                        const SizedBox(
                            height:
                            8),
                        Row(
                            children: [
                              Expanded(
                                  child: _ActionBtn(label: 'Add/Drop Courses', borderColor: border, txtColor: txt, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddDropScreen())))),
                              const SizedBox(
                                  width: 8),
                              Expanded(
                                  child: _ActionBtn(label: 'View Timetable', borderColor: border, txtColor: txt, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TimetableScreen())))),
                            ]),
                        const SizedBox(
                            height:
                            24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Notification overlay backdrop ──────────────────────────
          if (_showNotif)
            GestureDetector(
                onTap: () =>
                    setState(() =>
                    _showNotif =
                    false),
                child: Container(
                    color: Colors
                        .black38)),

          // ── Notification panel ─────────────────────────────────────
          if (_showNotif)
            Positioned(
              top: MediaQuery.of(
                  context)
                  .padding
                  .top +
                  kToolbarHeight,
              right: 8,
              width: 310,
              child: Material(
                elevation: 10,
                borderRadius:
                BorderRadius
                    .circular(
                    16),
                color: card,
                child: Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius
                        .circular(
                        16),
                    border: Border.all(
                        color:
                        border),
                  ),
                  child: Column(
                    mainAxisSize:
                    MainAxisSize
                        .min,
                    children: [
                      // panel header
                      Padding(
                        padding: const EdgeInsets
                            .fromLTRB(
                            16,
                            14,
                            10,
                            10),
                        child: Row(
                          children: [
                            Text(
                                'Notifications',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: txt)),
                            const SizedBox(
                                width: 8),
                            Container(
                              padding: const EdgeInsets
                                  .symmetric(
                                  horizontal: 8,
                                  vertical: 3),
                              decoration: BoxDecoration(
                                  color: AppTheme.primary,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                  '$newCount new',
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: AppTheme.textSecondary),
                              onPressed: () =>
                                  setState(() => _showNotif = false),
                              padding:
                              EdgeInsets.zero,
                              constraints:
                              const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                          height:
                          1,
                          color:
                          border),

                      // notification rows
                      ..._notifs.map(
                              (n) =>
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: n.isNew ? n.color.withOpacity(0.04) : Colors.transparent,
                                  border: Border(bottom: BorderSide(color: border, width: 0.5)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: n.color.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(n.icon, color: n.color, size: 18),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(children: [
                                            Expanded(
                                              child: Text(n.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: txt)),
                                            ),
                                            if (n.isNew)
                                              Container(
                                                width: 7,
                                                height: 7,
                                                decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                                              ),
                                          ]),
                                          const SizedBox(height: 2),
                                          Text(n.sub, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 3),
                                          Text(n.time, style: const TextStyle(fontSize: 11, color: AppTheme.textLight)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),

                      // footer
                      TextButton(
                        onPressed: () =>
                            setState(() =>
                            _showNotif = false),
                        child:
                        const Padding(
                          padding: EdgeInsets.only(
                              bottom:
                              4),
                          child: Text(
                              'View All Notifications',
                              style: TextStyle(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Small widgets ────────────────────────────────────────────────

class _ClassCard
    extends StatelessWidget {
  final String title,
      location,
      time;
  final Color iconBg,
      iconColor,
      cardColor,
      borderColor;
  final String? badge;
  final Color? badgeColor;
  const _ClassCard(
      {required this.title,
        required this.location,
        required this.time,
        required this.iconBg,
        required this.iconColor,
        required this.cardColor,
        required this.borderColor,
        this.badge,
        this.badgeColor});

  @override
  Widget build(
      BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: cardColor,
          borderRadius:
          BorderRadius
              .circular(14),
          border: Border.all(
              color: borderColor)),
      child: Row(children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
              color: iconBg,
              borderRadius:
              BorderRadius
                  .circular(
                  10)),
          child: Icon(
              Icons.access_time,
              color: iconColor,
              size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight:
                      FontWeight
                          .w600,
                      fontSize: 14,
                      color: AppTheme
                          .textPrimary)),
              Row(children: [
                const Icon(
                    Icons
                        .location_on_outlined,
                    size: 12,
                    color: AppTheme
                        .textLight),
                const SizedBox(
                    width: 2),
                Text(location,
                    style: const TextStyle(
                        fontSize:
                        12,
                        color: AppTheme
                            .textSecondary)),
              ]),
            ],
          ),
        ),
        Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .end,
            children: [
              Text(time,
                  style: const TextStyle(
                      fontWeight:
                      FontWeight
                          .w600,
                      fontSize: 13,
                      color: AppTheme
                          .textPrimary)),
              if (badge != null)
                Text(badge!,
                    style: TextStyle(
                        fontSize:
                        11,
                        color:
                        badgeColor,
                        fontWeight:
                        FontWeight
                            .w500)),
            ]),
      ]),
    );
  }
}

class _GradeCard
    extends StatelessWidget {
  final String course, task, grade;
  final double pct;
  final Color color,
      cardColor,
      borderColor;
  const _GradeCard(
      {required this.course,
        required this.task,
        required this.pct,
        required this.grade,
        required this.color,
        required this.cardColor,
        required this.borderColor});

  @override
  Widget build(
      BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: cardColor,
          borderRadius:
          BorderRadius
              .circular(14),
          border: Border.all(
              color: borderColor)),
      child: Column(children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
          children: [
            Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Text(course,
                      style: const TextStyle(
                          fontWeight:
                          FontWeight
                              .w700,
                          fontSize:
                          14,
                          color: AppTheme
                              .textPrimary)),
                  Text(task,
                      style: const TextStyle(
                          fontSize:
                          12,
                          color: AppTheme
                              .textSecondary)),
                ]),
            Text(grade,
                style: TextStyle(
                    fontWeight:
                    FontWeight
                        .w700,
                    fontSize: 18,
                    color: color)),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius:
          BorderRadius
              .circular(4),
          child:
          LinearProgressIndicator(
            value: pct,
            backgroundColor:
            const Color(
                0xFFE5E7EB),
            valueColor:
            AlwaysStoppedAnimation<
                Color>(color),
            minHeight: 6,
          ),
        ),
      ]),
    );
  }
}

class _ActionBtn
    extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color borderColor,
      txtColor;
  const _ActionBtn(
      {required this.label,
        required this.onTap,
        required this.borderColor,
        required this.txtColor});

  @override
  Widget build(
      BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style:
      OutlinedButton.styleFrom(
        side: BorderSide(
            color: borderColor),
        shape:
        RoundedRectangleBorder(
            borderRadius:
            BorderRadius
                .circular(
                12)),
        padding: const EdgeInsets
            .symmetric(
            vertical: 14),
        foregroundColor: txtColor,
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 13,
              fontWeight:
              FontWeight.w500,
              color: txtColor)),
    );
  }
}

class _SimplePendingCard
    extends StatelessWidget {
  final String title,
      course,
      dueDate,
      priority;
  final Color priorityColor,
      accentColor,
      cardColor,
      borderColor;

  const _SimplePendingCard({
    required this.title,
    required this.course,
    required this.dueDate,
    required this.priority,
    required this.priorityColor,
    required this.accentColor,
    required this.cardColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Colored left accent strip
              Container(width: 4, color: accentColor),

              // Card content
              Expanded(
                child: Container(
                  color: cardColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppTheme.textPrimary)),
                            const SizedBox(height: 2),
                            Text(course,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(dueDate,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary)),
                          const SizedBox(height: 2),
                          Text(priority,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: priorityColor)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}