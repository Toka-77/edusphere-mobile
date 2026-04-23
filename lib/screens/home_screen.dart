import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../locale_provider.dart';
import 'dashboard_screen.dart';
import 'attendance_qr_screen.dart';
import 'student_services_screen.dart';
import 'curriculum_screen.dart';
import 'records_screen.dart';
import 'settings_screen.dart';
import 'chatbot_screen.dart';
import 'admin_panel_screen.dart';
import 'grades_screen.dart';
import 'timetable_screen.dart';
import 'add_drop_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  static final GlobalKey<ScaffoldState> scaffoldKey =
  GlobalKey<ScaffoldState>();

  static VoidCallback get openDrawer =>
          () => scaffoldKey.currentState?.openDrawer();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = const [
    DashboardScreen(),
    AttendanceQRScreen(),
    StudentServicesScreen(),
    CurriculumScreen(),
    RecordsScreen(),
  ];

  void _goTo(int index) {
    setState(() => _currentIndex = index);
    Navigator.pop(context);
  }

  void _pushScreen(Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  void _showLogoutDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;

    Navigator.pop(context); // close drawer first
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🚪', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text('Sign Out?',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800, color: txt)),
              const SizedBox(height: 8),
              Text(
                "You'll be signed out of EduSphere. Make sure you've saved your work.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: txtSec, height: 1.6),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: txt,
                        side: BorderSide(color: border),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                              (_) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Sign Out',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.darkCard : Colors.white;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.border;

    return Scaffold(
      key: HomeScreen.scaffoldKey,
      body: _screens[_currentIndex],

      // ── Drawer ─ matches web .sidebar (#0f1120) ─────────────────
      drawer: Drawer(
        // Web: --sb: #0f1120 (dark navy sidebar)
        backgroundColor:
        isDark ? const Color(0xFF0F1120) : Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              // ── Sidebar Header (matches web .sb-top) ──────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0F1120)
                      : Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? AppTheme.darkBorder
                          : AppTheme.border,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo row (matches web .sb-logo)
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: AppTheme.redGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EduSphere',
                              style: TextStyle(
                                color: isDark
                                    ? AppTheme.darkText
                                    : AppTheme.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Student Portal',
                              style: TextStyle(
                                color: isDark
                                    ? AppTheme.darkTextLight
                                    : AppTheme.textLight,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // User info row (matches web .sb-user)
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.primary, AppTheme.primaryDark],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('RA',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rawda Ayman',
                                style: TextStyle(
                                  color: isDark
                                      ? AppTheme.darkText
                                      : AppTheme.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'rawda@edusphere.edu',
                                style: TextStyle(
                                  color: isDark
                                      ? AppTheme.darkTextLight
                                      : AppTheme.textLight,
                                  fontSize: 11,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      // Main nav
                      _DrawerItem(
                        icon: Icons.dashboard_outlined,
                        label: t('dashboard'),
                        selected: _currentIndex == 0,
                        isDark: isDark,
                        onTap: () => _goTo(0),
                      ),
                      _DrawerItem(
                        icon: Icons.qr_code_scanner_outlined,
                        label: t('attendance'),
                        selected: _currentIndex == 1,
                        isDark: isDark,
                        onTap: () => _goTo(1),
                      ),
                      _DrawerItem(
                        icon: Icons.grid_view_outlined,
                        label: t('services'),
                        selected: _currentIndex == 2,
                        isDark: isDark,
                        onTap: () => _goTo(2),
                      ),
                      _DrawerItem(
                        icon: Icons.school_outlined,
                        label: t('curriculum'),
                        selected: _currentIndex == 3,
                        isDark: isDark,
                        onTap: () => _goTo(3),
                      ),
                      _DrawerItem(
                        icon: Icons.badge_outlined,
                        label: t('records'),
                        selected: _currentIndex == 4,
                        isDark: isDark,
                        onTap: () => _goTo(4),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Divider(
                            color: isDark
                                ? AppTheme.darkBorder
                                : AppTheme.border),
                      ),

                      // Extra pages
                      _DrawerItem(
                        icon: Icons.bar_chart_outlined,
                        label: t('grades'),
                        selected: false,
                        isDark: isDark,
                        onTap: () => _pushScreen(const GradesScreen()),
                      ),
                      _DrawerItem(
                        icon: Icons.calendar_month_outlined,
                        label: t('timetable'),
                        selected: false,
                        isDark: isDark,
                        onTap: () => _pushScreen(const TimetableScreen()),
                      ),
                      _DrawerItem(
                        icon: Icons.add_circle_outline,
                        label: t('addDrop'),
                        selected: false,
                        isDark: isDark,
                        onTap: () => _pushScreen(const AddDropScreen()),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Divider(
                            color: isDark
                                ? AppTheme.darkBorder
                                : AppTheme.border),
                      ),

                      _DrawerItem(
                        icon: Icons.smart_toy_outlined,
                        label: t('aiAssistant'),
                        selected: false,
                        isDark: isDark,
                        onTap: () => _pushScreen(const ChatbotScreen()),
                      ),
                      _DrawerItem(
                        icon: Icons.admin_panel_settings_outlined,
                        label: t('adminPanel'),
                        selected: false,
                        isDark: isDark,
                        onTap: () => _pushScreen(const AdminPanelScreen()),
                      ),
                      _DrawerItem(
                        icon: Icons.settings_outlined,
                        label: t('settings'),
                        selected: false,
                        isDark: isDark,
                        onTap: () => _pushScreen(const SettingsScreen()),
                      ),

                      // Support card (matches web .sb-promo)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            // Web: rgba(244,67,54,0.1) bg + rgba(244,67,54,0.15) border
                            color: AppTheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Need Help? 🎓',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppTheme.darkText
                                      : AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Contact EduSphere support',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? AppTheme.darkTextSec
                                      : AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primary,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(8)),
                                    elevation: 0,
                                  ),
                                  child: const Text('Get Support',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Logout at bottom
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                child: Divider(
                    color:
                    isDark ? AppTheme.darkBorder : AppTheme.border),
              ),
              _DrawerItem(
                icon: Icons.logout,
                label: t('logout'),
                selected: false,
                isDark: isDark,
                isLogout: true,
                onTap: _showLogoutDialog,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),

      // ── Bottom Navigation Bar ─────────────────────────────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border(top: BorderSide(color: borderColor, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: cardColor,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor:
          isDark ? AppTheme.darkTextLight : AppTheme.textLight,
          showUnselectedLabels: true,
          selectedLabelStyle:
          const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: 'Dashboard'),
            BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner_outlined),
                activeIcon: Icon(Icons.qr_code_scanner),
                label: 'Attendance'),
            BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_outlined),
                activeIcon: Icon(Icons.grid_view),
                label: 'Services'),
            BottomNavigationBarItem(
                icon: Icon(Icons.school_outlined),
                activeIcon: Icon(Icons.school),
                label: 'Curriculum'),
            BottomNavigationBarItem(
                icon: Icon(Icons.badge_outlined),
                activeIcon: Icon(Icons.badge),
                label: 'Records'),
          ],
        ),
      ),
    );
  }
}

// ── Drawer item — matches web .nav-item / .nav-item.active ─────
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final bool selected;
  final bool isDark;
  final bool isLogout;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    this.badge,
    required this.selected,
    required this.isDark,
    this.isLogout = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Active: red gradient bg + white text + white dot (matches web)
    // Inactive: transparent + theme text color
    final Color iconColor = isLogout
        ? AppTheme.primary
        : selected
        ? Colors.white
        : (isDark ? AppTheme.darkTextSec : AppTheme.textSecondary);
    final Color labelColor = isLogout
        ? AppTheme.primary
        : selected
        ? Colors.white
        : (isDark ? AppTheme.darkText : AppTheme.textPrimary);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            // Web: active = linear-gradient(135deg,#f44336,#b71c1c)
            gradient: selected ? AppTheme.redGradient : null,
            borderRadius: BorderRadius.circular(10),
            color: selected ? null : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: labelColor,
                  ),
                ),
              ),
              // Badge
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.3)
                        : AppTheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(badge!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800)),
                ),
              // White dot for active (matches web nav-item-active white dot)
              if (selected)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
