import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../theme_provider.dart';
import '../locale_provider.dart';
import 'dashboard_screen.dart';
import 'attendance_qr_screen.dart';
import 'student_services_screen.dart';
import 'curriculum_screen.dart';
import 'records_screen.dart';
import 'admin_panel_screen.dart';
import 'chatbot_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';

// ── Notification data ───────────────────────────────────────────────
class _NotifItem {
  final String icon;
  final String title;
  final String desc;
  final String time;
  final int pageIndex;
  const _NotifItem(
      {required this.icon,
      required this.title,
      required this.desc,
      required this.time,
      required this.pageIndex});
}

const List<_NotifItem> _notifications = [
  _NotifItem(
      icon: '📅',
      title: 'Class Starting Soon',
      desc: 'Advanced Web Development starts in 15 min',
      time: '10 min ago',
      pageIndex: 1),
  _NotifItem(
      icon: '📝',
      title: 'Assignment Due Tomorrow',
      desc: 'Web Development Project 3 - CS431',
      time: '1 hour ago',
      pageIndex: 0),
  _NotifItem(
      icon: '📊',
      title: 'Grade Posted',
      desc: 'MATH301 Midterm Exam: 38%',
      time: '3 hours ago',
      pageIndex: 0),
  _NotifItem(
      icon: '⚠️',
      title: 'Attendance Warning',
      desc: 'You missed 2 sessions in ENG101',
      time: 'Yesterday',
      pageIndex: 2),
];

// ── Search index ────────────────────────────────────────────────────
class _SearchItem {
  final String label;
  final int pageIndex;
  final String icon;
  final String desc;
  const _SearchItem(
      {required this.label,
      required this.pageIndex,
      required this.icon,
      required this.desc});
}

const List<_SearchItem> _searchIndex = [
  _SearchItem(
      label: 'Dashboard', pageIndex: 0, icon: '📊', desc: 'Main overview'),
  _SearchItem(
      label: 'Attendance QR',
      pageIndex: 1,
      icon: '📷',
      desc: 'QR code attendance'),
  _SearchItem(
      label: 'Student Services',
      pageIndex: 2,
      icon: '👥',
      desc: 'Medical, complaints, requests'),
  _SearchItem(
      label: 'Curriculum Management',
      pageIndex: 3,
      icon: '📚',
      desc: 'Course plan'),
  _SearchItem(
      label: 'Records & Documents',
      pageIndex: 4,
      icon: '📄',
      desc: 'Academic records'),
  _SearchItem(
      label: 'Admin Panel',
      pageIndex: 5,
      icon: '🛡️',
      desc: 'Administration'),
  _SearchItem(
      label: 'AI Assistant', pageIndex: 6, icon: '🤖', desc: 'AI help'),
  _SearchItem(
      label: 'Settings',
      pageIndex: 7,
      icon: '⚙️',
      desc: 'Account preferences'),
];

// ── Nav item model ──────────────────────────────────────────────────
class _NavItem {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String? badge;
  final String? tKey;
  const _NavItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badge,
    this.tKey,
  });
}

const List<_NavItem> _navItems = [
  _NavItem(
    index: 0,
    icon: Icons.dashboard_outlined,
    activeIcon: Icons.dashboard,
    label: 'Dashboard',
    tKey: 'dashboard',
  ),
  _NavItem(
    index: 1,
    icon: Icons.qr_code_scanner_outlined,
    activeIcon: Icons.qr_code_scanner,
    label: 'Attendance QR',
    badge: '3',
    tKey: 'attendance',
  ),
  _NavItem(
    index: 2,
    icon: Icons.grid_view_outlined,
    activeIcon: Icons.grid_view,
    label: 'Student Services',
    tKey: 'students',
  ),
  _NavItem(
    index: 3,
    icon: Icons.menu_book_outlined,
    activeIcon: Icons.menu_book,
    label: 'Curriculum',
    tKey: 'curriculum',
  ),
  _NavItem(
    index: 4,
    icon: Icons.badge_outlined,
    activeIcon: Icons.badge,
    label: 'Records',
    tKey: 'records',
  ),
  _NavItem(
    index: 5,
    icon: Icons.security_outlined,
    activeIcon: Icons.security,
    label: 'Admin Panel',
    tKey: 'admin',
  ),
  _NavItem(
    index: 6,
    icon: Icons.smart_toy_outlined,
    activeIcon: Icons.smart_toy,
    label: 'AI Assistant',
    tKey: 'aiAssistant',
  ),
  _NavItem(
    index: 7,
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings,
    label: 'Settings',
    tKey: 'settings',
  ),
];

// ── HomeScreen ──────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  // Static key so child screens can open the drawer
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  static void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

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
    AdminPanelScreen(),
    ChatbotScreen(),
    SettingsScreen(),
  ];

  void _navigate(int index) {
    setState(() => _currentIndex = index);
    Navigator.pop(context); // close drawer
  }

  void _navigateFromOverlay(int index) {
    setState(() => _currentIndex = index);
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.darkCard : Colors.white;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txtColor = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final bgColor = isDark ? AppTheme.darkBg : AppTheme.background;

    return Scaffold(
      key: HomeScreen.scaffoldKey,
      backgroundColor: bgColor,
      drawer: _buildDrawer(
          isDark, cardColor, borderColor, txtColor, txtSec, bgColor),
      // Body is the active screen — each screen has its own AppBar
      body: _screens[_currentIndex],
    );
  }

  Widget _buildDrawer(bool isDark, Color cardColor, Color borderColor,
      Color txtColor, Color txtSec, Color bgColor) {
    return Drawer(
      backgroundColor: isDark ? AppTheme.darkSidebar : cardColor,
      child: SafeArea(
        child: Column(
          children: [
            // ── Logo header ────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('EduSphere',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: txtColor)),
                      Text(t('studentPortal'),
                          style: TextStyle(fontSize: 12, color: txtSec)),
                    ],
                  ),
                ],
              ),
            ),

            // ── Student card ───────────────────────────────────────
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('RA',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Toka Khaled',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                        Text('Business Technology • Year 4',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Nav items ──────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                children: [
                  for (final item in _navItems)
                    _DrawerNavItem(
                      item: item,
                      isSelected: _currentIndex == item.index,
                      isDark: isDark,
                      txtColor: txtColor,
                      txtSec: txtSec,
                      onTap: () => _navigate(item.index),
                    ),
                ],
              ),
            ),

            // ── Divider + Sign Out ─────────────────────────────────
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: _DrawerNavItem(
                item: const _NavItem(
                  index: -1,
                  icon: Icons.logout,
                  activeIcon: Icons.logout,
                  label: 'Sign Out',
                 tKey: 'signOut',
                ),
                isSelected: false,
                isDark: isDark,
                txtColor: AppTheme.primary,
                txtSec: txtSec,
                onTap: _showLogoutDialog,
                isLogout: true,
              ),
            ),

            // ── Support card ───────────────────────────────────────
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.primary.withValues(alpha: 0.1)
                    : AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t('needHelp'),
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: txtColor,
                          fontSize: 13)),
                  const SizedBox(height: 3),
                  Text(t('contactSupport'),
                      style: TextStyle(fontSize: 11, color: txtSec)),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // close drawer
                        _showSupportDialog();
                      },
                      style: ElevatedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 8)),
                      child: Text(t('getSupport'),
                          style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Support Dialog ────────────────────────────────────────────────
  void _showSupportDialog() {
    String selectedType = '';
    final msgController = TextEditingController();
    bool sent = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          final cardColor = isDark ? AppTheme.darkCard : Colors.white;
          final txtColor = isDark ? AppTheme.darkText : AppTheme.textPrimary;
          final txtSec =
              isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

          if (sent) {
            return Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('✅', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),
                  Text('Ticket Submitted!',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: txtColor,
                          fontSize: 16)),
                  const SizedBox(height: 6),
                  Text('Our team will respond within 24 hours.',
                      style: TextStyle(fontSize: 13, color: txtSec)),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('🎓 Get Support',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: txtColor)),
                            Text('EduSphere IT & Academic Support',
                                style:
                                    TextStyle(fontSize: 12, color: txtSec)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: Icon(Icons.close, color: txtSec),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('ISSUE TYPE',
                      style: TextStyle(
                          fontSize: 12,
                          color: txtSec,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        ['Technical', 'Academic', 'Payment', 'Other']
                            .map((t) => ChoiceChip(
                                  label: Text(t,
                                      style:
                                          const TextStyle(fontSize: 12)),
                                  selected: selectedType == t,
                                  onSelected: (_) =>
                                      setSheetState(() => selectedType = t),
                                  selectedColor: AppTheme.primary
                                      .withValues(alpha: 0.2),
                                ))
                            .toList(),
                  ),
                  const SizedBox(height: 16),
                  Text('DESCRIBE YOUR ISSUE',
                      style: TextStyle(
                          fontSize: 12,
                          color: txtSec,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: msgController,
                    maxLines: 4,
                    style: TextStyle(color: txtColor),
                    decoration: InputDecoration(
                      hintText: 'Describe your problem...',
                      hintStyle: TextStyle(color: txtSec),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: isDark
                                ? AppTheme.darkBorder
                                : AppTheme.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: isDark
                                ? AppTheme.darkBorder
                                : AppTheme.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setSheetState(() => sent = true);
                        Future.delayed(const Duration(seconds: 2),
                            () {
                          if (ctx.mounted) Navigator.pop(ctx);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('📤 Submit Ticket',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  // ── Notification Panel ────────────────────────────────────────────
  void showNotificationPanel() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.darkCard : Colors.white;
    final txtColor = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text('Notifications',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: txtColor,
                        fontSize: 16)),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: Icon(Icons.close, color: txtSec, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._notifications.map((n) => InkWell(
                  onTap: () {
                    Navigator.pop(ctx);
                    _navigateFromOverlay(n.pageIndex);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n.icon, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n.title,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: txtColor)),
                              Text(n.desc,
                                  style: TextStyle(
                                      fontSize: 12, color: txtSec)),
                              Text(n.time,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: txtSec,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // ── Search Dialog ─────────────────────────────────────────────────
  void showSearchDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final cardColor = isDark ? AppTheme.darkCard : Colors.white;
        final txtColor = isDark ? AppTheme.darkText : AppTheme.textPrimary;
        final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
        String query = '';

        return StatefulBuilder(builder: (ctx, setDialogState) {
          final results = query.trim().isNotEmpty
              ? _searchIndex
                  .where((item) =>
                      item.label
                          .toLowerCase()
                          .contains(query.toLowerCase()) ||
                      item.desc
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                  .take(7)
                  .toList()
              : <_SearchItem>[];

          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            backgroundColor: cardColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    style: TextStyle(color: txtColor),
                    decoration: InputDecoration(
                      hintText: 'Search anything...',
                      hintStyle: TextStyle(color: txtSec),
                      prefixIcon: Icon(Icons.search, color: txtSec),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: isDark
                                ? AppTheme.darkBorder
                                : AppTheme.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: isDark
                                ? AppTheme.darkBorder
                                : AppTheme.border),
                      ),
                    ),
                    onChanged: (v) => setDialogState(() => query = v),
                  ),
                  if (results.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ...results.map((item) => InkWell(
                          onTap: () {
                            Navigator.pop(ctx);
                            _navigateFromOverlay(item.pageIndex);
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            child: Row(
                              children: [
                                Text(item.icon,
                                    style: const TextStyle(fontSize: 18)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item.label,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: txtColor)),
                                      Text(item.desc,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: txtSec)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  void _showLogoutDialog() {
    Navigator.pop(context); // close drawer first
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.darkCard : Colors.white;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Text('🚪', style: TextStyle(fontSize: 40)),
            SizedBox(height: 8),
            Text('Sign Out?',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
          ],
        ),
        content: const Text(
          "You'll be signed out of EduSphere. Make sure you've saved your work.",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _logout();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Sign Out'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Drawer Nav Item ─────────────────────────────────────────────────
class _DrawerNavItem extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final bool isDark;
  final Color txtColor;
  final Color txtSec;
  final VoidCallback onTap;
  final bool isLogout;

  const _DrawerNavItem({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.txtColor,
    required this.txtSec,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: isSelected ? AppTheme.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                Icon(
                  isSelected ? item.activeIcon : item.icon,
                  size: 20,
                  color: isSelected
                      ? AppTheme.primary
                      : (isLogout ? AppTheme.primary : txtColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.tKey != null ? t(item.tKey!) : item.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? AppTheme.primary
                          : (isLogout ? AppTheme.primary : txtColor),
                    ),
                  ),
                ),
                if (item.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.badge!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
