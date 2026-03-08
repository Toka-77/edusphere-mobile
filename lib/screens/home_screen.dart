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
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  /// Global key so any child screen can open the drawer via
  /// `HomeScreen.openDrawer()`.
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  /// Static callback referenced by every child screen's menu button.
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
    Navigator.pop(context); // close drawer
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDark ? AppTheme.darkCard : Colors.white;
    final borderColor =
        isDark ? AppTheme.darkBorder : AppTheme.border;
    final txtColor =
        isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec =
        isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    return Scaffold(
      key: HomeScreen.scaffoldKey,
      body: _screens[_currentIndex],

      // ── Drawer ──────────────────────────────────────────────
      drawer: Drawer(
        backgroundColor: cardColor,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primary,
                      AppTheme.primaryDark,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'TK',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Toka Khaled',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'toka@edusphere.edu',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Navigation items
              _DrawerItem(
                icon: Icons.dashboard_outlined,
                label: t('dashboard'),
                selected: _currentIndex == 0,
                txtColor: txtColor,
                txtSec: txtSec,
                onTap: () => _goTo(0),
              ),
              _DrawerItem(
                icon: Icons.qr_code_scanner_outlined,
                label: t('attendance'),
                selected: _currentIndex == 1,
                txtColor: txtColor,
                txtSec: txtSec,
                onTap: () => _goTo(1),
              ),
              _DrawerItem(
                icon: Icons.grid_view_outlined,
                label: t('services'),
                selected: _currentIndex == 2,
                txtColor: txtColor,
                txtSec: txtSec,
                onTap: () => _goTo(2),
              ),
              _DrawerItem(
                icon: Icons.school_outlined,
                label: t('curriculum'),
                selected: _currentIndex == 3,
                txtColor: txtColor,
                txtSec: txtSec,
                onTap: () => _goTo(3),
              ),
              _DrawerItem(
                icon: Icons.badge_outlined,
                label: t('records'),
                selected: _currentIndex == 4,
                txtColor: txtColor,
                txtSec: txtSec,
                onTap: () => _goTo(4),
              ),

              Divider(color: borderColor),

              _DrawerItem(
                icon: Icons.smart_toy_outlined,
                label: t('aiAssistant'),
                selected: false,
                txtColor: txtColor,
                txtSec: txtSec,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const ChatbotScreen()),
                  );
                },
              ),
              _DrawerItem(
                icon: Icons.admin_panel_settings_outlined,
                label: t('adminPanel'),
                selected: false,
                txtColor: txtColor,
                txtSec: txtSec,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const AdminPanelScreen()),
                  );
                },
              ),
              _DrawerItem(
                icon: Icons.settings_outlined,
                label: t('settings'),
                selected: false,
                txtColor: txtColor,
                txtSec: txtSec,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const SettingsScreen()),
                  );
                },
              ),

              const Spacer(),

              Divider(color: borderColor),
              _DrawerItem(
                icon: Icons.logout,
                label: t('logout'),
                selected: false,
                txtColor: AppTheme.primary,
                txtSec: txtSec,
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const LoginScreen()),
                    (_) => false,
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),

      // ── Bottom Navigation Bar ───────────────────────────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border(
            top: BorderSide(
                color: borderColor, width: 1),
          ),
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
          selectedLabelStyle: const TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              const TextStyle(fontSize: 11),
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

// ── Drawer item widget ──────────────────────────────────────────
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color txtColor;
  final Color txtSec;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.txtColor,
    required this.txtSec,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? AppTheme.primary : txtSec,
        size: 22,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight:
              selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? AppTheme.primary : txtColor,
        ),
      ),
      selected: selected,
      selectedTileColor:
          AppTheme.primary.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16),
      onTap: onTap,
    );
  }
}
