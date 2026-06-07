import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_theme.dart';
import '../locale_provider.dart';
import 'home_screen.dart';
import '../logic/auth/auth_bloc.dart';
import '../logic/auth/auth_event.dart';
import '../logic/auth/auth_state.dart';
import '../data/services/auth_service.dart';
import '../logic/dashboard/dashboard_bloc.dart';
import '../logic/dashboard/dashboard_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedSection = 'profile';
  String _selectedLang = 'English';

  // Notification toggles
  bool _notifyEmail = true;
  bool _notifyPush = true;
  bool _notifyGrades = true;
  bool _notifyAssign = false;
  bool _notifyAttend = true;

  // Security toggles (2FA)
  bool _2faAuth = false;
  bool _2faSms = false;

  // Security – change password
  final _oldPwController = TextEditingController();
  final _newPwController = TextEditingController();
  final _confPwController = TextEditingController();
  bool _pwSaved = false;
  bool _isSavingPw = false;
  String? _pwError;

  // Profile save
  bool _isSavingProfile = false;
  bool _profileSaved = false;

  // Profile fields (populated from AuthBloc in initState)
  final _fullNameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailFieldController = TextEditingController();
  final _phoneController = TextEditingController();
  final _programController = TextEditingController();

  // Active sessions
  final List<Map<String, dynamic>> _sessions = [
    {
      'device': 'Mobile - Safari iOS',
      'ip': '192.168.1.5',
      'time': 'Now',
      'current': true
    },
    {
      'device': 'Chrome on Windows',
      'ip': '41.234.12.80',
      'time': '2 hours ago',
      'current': false
    },
  ];



  final List<Map<String, String>> _languages = const [
    {'label': 'English', 'flag': '🇬🇧', 'code': 'en'},
    {'label': 'Arabic', 'flag': '🇪🇬', 'code': 'ar'},
    {'label': 'Russian', 'flag': '🇷🇺', 'code': 'ru'},
    {'label': 'French', 'flag': '🇫🇷', 'code': 'fr'},
    {'label': 'German', 'flag': '🇩🇪', 'code': 'de'},
  ];

  ThemeMode get _currentMode => themeModeNotifier.value;

  void _setTheme(ThemeMode mode) {
    setState(() => themeModeNotifier.value = mode);
  }

  void _logout() {
    context.read<AuthBloc>().add(LogoutRequested());
  }

  Future<void> _handleSavePw() async {
    final current = _oldPwController.text.trim();
    final newPw  = _newPwController.text.trim();
    final confirm = _confPwController.text.trim();
    if (current.isEmpty) {
      setState(() => _pwError = 'Please enter your current password.');
      return;
    }
    if (newPw.length < 8) {
      setState(() => _pwError = 'New password must be at least 8 characters.');
      return;
    }
    if (newPw != confirm) {
      setState(() => _pwError = 'Passwords do not match.');
      return;
    }
    setState(() { _isSavingPw = true; _pwError = null; });
    try {
      await context.read<AuthService>().changePassword(
        currentPassword: current,
        newPassword: newPw,
        newPasswordConfirmation: confirm,
      );
      setState(() { _pwSaved = true; _isSavingPw = false; });
      _oldPwController.clear();
      _newPwController.clear();
      _confPwController.clear();
      Future.delayed(const Duration(seconds: 3),
          () => mounted ? setState(() => _pwSaved = false) : null);
    } catch (e) {
      setState(() {
        _pwError = e.toString().replaceAll('Exception: ', '');
        _isSavingPw = false;
      });
    }
  }

  Future<void> _handleSaveProfile() async {
    final name = _fullNameController.text.trim();
    if (name.isEmpty) return;
    setState(() => _isSavingProfile = true);
    try {
      await context.read<AuthService>().updateProfile(name);
      setState(() { _profileSaved = true; _isSavingProfile = false; });
      Future.delayed(const Duration(seconds: 3),
          () => mounted ? setState(() => _profileSaved = false) : null);
    } catch (e) {
      setState(() => _isSavingProfile = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final s = context.read<AuthBloc>().state;
      if (s is AuthAuthenticated) {
        final u = s.user;
        _fullNameController.text = u.name;
        _studentIdController.text = u.studentCode ?? '';
        _emailFieldController.text = u.email;
        _phoneController.text = u.phones.isNotEmpty ? u.phones.first : '';
        _programController.text = u.program ?? '';
      }
    });
  }

  @override
  void dispose() {
    _oldPwController.dispose();
    _newPwController.dispose();
    _confPwController.dispose();
    _fullNameController.dispose();
    _studentIdController.dispose();
    _emailFieldController.dispose();
    _phoneController.dispose();
    _programController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.darkCard : Colors.white;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.border;
    final bgColor = isDark ? AppTheme.darkBg : AppTheme.background;
    final txtColor = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: txtColor),
                onPressed: () => Navigator.pop(context),
              )
            : IconButton(
                icon: Icon(Icons.menu, color: txtColor),
                onPressed: HomeScreen.openDrawer,
              ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t('settingsTitle'),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: txtColor)),
            Text(t('settingsSub'),
                style: TextStyle(fontSize: 11, color: txtSec)),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Section Nav Tabs ──────────────────────────────────
          Container(
            color: cardColor,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  _navTab('profile', '👤', t('profile'), txtColor, cardColor,
                      borderColor),
                  _navTab('security', '🔒', t('security'), txtColor, cardColor,
                      borderColor),
                  _navTab('notifications', '🔔', t('notifications'), txtColor,
                      cardColor, borderColor),
                  _navTab('appearance', '🎨', t('appearance'), txtColor,
                      cardColor, borderColor),
                  _navTab('language', '🌐', t('language'), txtColor, cardColor,
                      borderColor),
                  _navTab('academic', '📊', t('academic'), txtColor, cardColor,
                      borderColor),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: borderColor),

          // ── Section Content ──────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildSection(
                  isDark, cardColor, borderColor, txtColor, txtSec),
            ),
          ),
        ],
      ),
    );
  }

  // ── Nav Tab ──────────────────────────────────────────────────────
  Widget _navTab(String key, String icon, String label, Color txtColor,
      Color cardColor, Color borderColor) {
    final isActive = _selectedSection == key;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: () => setState(() => _selectedSection = key),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive ? AppTheme.primary : borderColor,
            ),
          ),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? AppTheme.primary : txtColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Section Router ──────────────────────────────────────────────
  Widget _buildSection(bool isDark, Color cardColor, Color borderColor,
      Color txtColor, Color txtSec) {
    switch (_selectedSection) {
      case 'profile':
        return _buildProfile(cardColor, borderColor, txtColor, txtSec);
      case 'security':
        return _buildSecurity(
            isDark, cardColor, borderColor, txtColor, txtSec);
      case 'notifications':
        return _buildNotifications(
            isDark, cardColor, borderColor, txtColor, txtSec);
      case 'appearance':
        return _buildAppearance(
            isDark, cardColor, borderColor, txtColor, txtSec);
      case 'language':
        return _buildLanguage(
            isDark, cardColor, borderColor, txtColor, txtSec);
      case 'academic':
        return _buildAcademic(cardColor, borderColor, txtColor, txtSec);
      default:
        return const SizedBox();
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // PROFILE SECTION
  // ═══════════════════════════════════════════════════════════════
  Widget _buildProfile(
      Color cardColor, Color borderColor, Color txtColor, Color txtSec) {
    final authState = context.read<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    final initials = user?.initials ?? '?';
    final displayName = user?.name ?? '';
    final displayEmail = user?.email ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar row
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryDark],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(initials,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(displayName,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: txtColor)),
                  Text(displayEmail,
                      style: TextStyle(fontSize: 12, color: txtSec)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Name is editable
          ..._profileField('Full Name', _fullNameController, txtColor, txtSec,
              cardColor, borderColor, readOnly: false),
          ..._profileField('Student ID', _studentIdController, txtColor,
              txtSec, cardColor, borderColor, readOnly: true),
          ..._profileField('Email', _emailFieldController, txtColor, txtSec,
              cardColor, borderColor, readOnly: true),
          ..._profileField('Phone', _phoneController, txtColor, txtSec,
              cardColor, borderColor, readOnly: true),
          ..._profileField('Program', _programController, txtColor, txtSec,
              cardColor, borderColor, readOnly: true),

          if (_profileSaved)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text('✅ Name updated successfully!',
                  style: TextStyle(
                      color: AppTheme.success,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
            ),

          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: _isSavingProfile ? null : _handleSaveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: _isSavingProfile
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Save Name',
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),

          // Note about read-only fields
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.info.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.info.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppTheme.info, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Some fields are managed by the university and cannot be changed here.',
                    style: TextStyle(fontSize: 12, color: txtSec),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _profileField(String label, TextEditingController ctrl,
      Color txtColor, Color txtSec, Color cardColor, Color borderColor,
      {bool readOnly = false}) {
    return [
      Text(label,
          style: TextStyle(
              fontSize: 11, color: txtSec, fontWeight: FontWeight.w500)),
      const SizedBox(height: 4),
      TextField(
        controller: ctrl,
        readOnly: readOnly,
        style: TextStyle(fontSize: 14, color: readOnly ? txtSec : txtColor),
        decoration: InputDecoration(
          filled: true,
          fillColor: cardColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: readOnly
                ? BorderSide(color: borderColor)
                : const BorderSide(color: AppTheme.primary, width: 2),
          ),
          suffixIcon: readOnly
              ? Icon(Icons.lock_outline, size: 16, color: txtSec)
              : null,
        ),
      ),
      const SizedBox(height: 12),
    ];
  }

  // ═══════════════════════════════════════════════════════════════
  // SECURITY SECTION
  // ═══════════════════════════════════════════════════════════════
  Widget _buildSecurity(bool isDark, Color cardColor, Color borderColor,
      Color txtColor, Color txtSec) {
    return Column(
      children: [
        // Change Password
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🔑 Change Password',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: txtColor)),
              const SizedBox(height: 4),
              Text('Update your account password regularly to keep it secure.',
                  style: TextStyle(fontSize: 12, color: txtSec)),
              const SizedBox(height: 16),
              _secField('Current Password', _oldPwController, txtColor, txtSec,
                  cardColor, borderColor),
              _secField('New Password', _newPwController, txtColor, txtSec,
                  cardColor, borderColor),
              _secField('Confirm Password', _confPwController, txtColor,
                  txtSec, cardColor, borderColor),
              if (_pwError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(_pwError!,
                      style: const TextStyle(
                          color: AppTheme.error,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ),
              if (_pwSaved)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text('\u2705 Password updated successfully!',
                      style: TextStyle(
                          color: Color(0xFF00E676),
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: _isSavingPw ? null : _handleSavePw,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isSavingPw
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Save Password',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Active Sessions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('💻 Active Sessions',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: txtColor)),
              const SizedBox(height: 4),
              Text(
                  'Manage devices that are currently signed in to your account.',
                  style: TextStyle(fontSize: 12, color: txtSec)),
              const SizedBox(height: 14),
              ..._sessions
                  .map((s) => _sessionRow(s, txtColor, txtSec, cardColor, borderColor)),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2FA
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🛡️ Two-Factor Authentication',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: txtColor)),
              const SizedBox(height: 4),
              Text('Add an extra layer of security to your account.',
                  style: TextStyle(fontSize: 12, color: txtSec)),
              const SizedBox(height: 14),
              _toggleRow(
                label: 'Authenticator App',
                sub: 'Use Google Authenticator or similar',
                value: _2faAuth,
                onChanged: (v) => setState(() => _2faAuth = v),
                txtColor: txtColor,
                txtSec: txtSec,
                borderColor: borderColor,
                showBorder: true,
              ),
              _toggleRow(
                label: 'SMS Verification',
                sub: 'Receive codes via text message',
                value: _2faSms,
                onChanged: (v) => setState(() => _2faSms = v),
                txtColor: txtColor,
                txtSec: txtSec,
                borderColor: borderColor,
                showBorder: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _secField(String label, TextEditingController ctrl, Color txtColor,
      Color txtSec, Color cardColor, Color borderColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: txtSec, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            obscureText: true,
            style: TextStyle(fontSize: 14, color: txtColor),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: TextStyle(color: txtSec),
              prefixIcon:
                  const Icon(Icons.vpn_key, color: AppTheme.primary, size: 18),
              filled: true,
              fillColor: cardColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: AppTheme.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sessionRow(Map<String, dynamic> session, Color txtColor,
      Color txtSec, Color cardColor, Color borderColor) {
    final bool isCurrent = session['current'] == true;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: borderColor.withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          Text(isCurrent ? '💻' : '📱', style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session['device'],
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: txtColor)),
                Text('IP: ${session['ip']} · ${session['time']}',
                    style: TextStyle(fontSize: 12, color: txtSec)),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00E676).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('THIS DEVICE',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF00E676))),
            )
          else
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                side: const BorderSide(color: AppTheme.primary),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Revoke',
                  style:
                      TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // NOTIFICATIONS SECTION
  // ═══════════════════════════════════════════════════════════════
  Widget _buildNotifications(bool isDark, Color cardColor, Color borderColor,
      Color txtColor, Color txtSec) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🔔 Notification Preferences',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: txtColor)),
          const SizedBox(height: 4),
          Text('Choose which notifications you want to receive.',
              style: TextStyle(fontSize: 12, color: txtSec)),
          const SizedBox(height: 14),
          _toggleRow(
            label: 'Email Notifications',
            sub: 'Receive updates via email',
            value: _notifyEmail,
            onChanged: (v) => setState(() => _notifyEmail = v),
            txtColor: txtColor,
            txtSec: txtSec,
            borderColor: borderColor,
            showBorder: true,
          ),
          _toggleRow(
            label: 'Push Notifications',
            sub: 'Browser alerts',
            value: _notifyPush,
            onChanged: (v) => setState(() => _notifyPush = v),
            txtColor: txtColor,
            txtSec: txtSec,
            borderColor: borderColor,
            showBorder: true,
          ),
          _toggleRow(
            label: 'Grade Updates',
            sub: 'When new grades are posted',
            value: _notifyGrades,
            onChanged: (v) => setState(() => _notifyGrades = v),
            txtColor: txtColor,
            txtSec: txtSec,
            borderColor: borderColor,
            showBorder: true,
          ),
          _toggleRow(
            label: 'Assignment Reminders',
            sub: 'Before due dates',
            value: _notifyAssign,
            onChanged: (v) => setState(() => _notifyAssign = v),
            txtColor: txtColor,
            txtSec: txtSec,
            borderColor: borderColor,
            showBorder: true,
          ),
          _toggleRow(
            label: 'Attendance Alerts',
            sub: 'Absence warnings',
            value: _notifyAttend,
            onChanged: (v) => setState(() => _notifyAttend = v),
            txtColor: txtColor,
            txtSec: txtSec,
            borderColor: borderColor,
            showBorder: false,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // APPEARANCE SECTION
  // ═══════════════════════════════════════════════════════════════
  Widget _buildAppearance(bool isDark, Color cardColor, Color borderColor,
      Color txtColor, Color txtSec) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🎨 Appearance',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: txtColor)),
              const SizedBox(height: 4),
              Text('THEME',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: txtSec)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _themeCard('🌙', 'Dark Mode', ThemeMode.dark, cardColor,
                      borderColor, txtColor),
                  const SizedBox(width: 10),
                  _themeCard('☀️', 'Light Mode', ThemeMode.light, cardColor,
                      borderColor, txtColor),
                  const SizedBox(width: 10),
                  _themeCard('🖥️', 'System', ThemeMode.system, cardColor,
                      borderColor, txtColor),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _themeCard(String icon, String label, ThemeMode mode, Color cardColor,
      Color borderColor, Color txtColor) {
    final isActive = _currentMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => _setTheme(mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? AppTheme.primary : borderColor,
              width: isActive ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: txtColor)),
              if (isActive) ...[
                const SizedBox(height: 4),
                const Text('✓ Active',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w700)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // LANGUAGE SECTION
  // ═══════════════════════════════════════════════════════════════
  Widget _buildLanguage(bool isDark, Color cardColor, Color borderColor,
      Color txtColor, Color txtSec) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🌐 Language',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: txtColor)),
          const SizedBox(height: 14),
          ..._languages.map((lang) {
            final isSelected = _selectedLang == lang['label'];
            return GestureDetector(
              onTap: () {
                setState(() => _selectedLang = lang['label']!);
                localeNotifier.value = lang['code']!;
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : borderColor,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(lang['label']!,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: txtColor,
                              fontSize: 14)),
                    ),
                    if (isSelected)
                      const Text('✓',
                          style: TextStyle(
                              color: AppTheme.primary, fontSize: 18)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ACADEMIC SECTION
  // ═══════════════════════════════════════════════════════════════
  Widget _buildAcademic(
      Color cardColor, Color borderColor, Color txtColor, Color txtSec) {
    final authState = context.read<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    final dashState = context.read<DashboardBloc>().state;
    final gpa = dashState is DashboardLoaded
        ? dashState.data.cgpa.toStringAsFixed(2) : '-';
    final credits = user?.creditHours?.toString() ?? '-';
    final totalCredits = dashState is DashboardLoaded
        ? dashState.data.requiredCredits.toString() : '120';
    final program  = user?.program ?? '-';
    final level    = user?.level != null ? 'Level ${user!.level}' : '-';
    final standing = (user?.isHonor == true) ? 'Honor Roll' : 'Good Standing';

    final items = [
      ['🎓 Current GPA', '$gpa / 4.0', const Color(0xFF00C853)],
      ['📚 Credits Earned', '$credits / $totalCredits', const Color(0xFF2979FF)],
      ['🏅 Academic Standing', standing, const Color(0xFFFF6D00)],
      ['🎖️ Level', level, txtColor],
      ['📖 Program', program, txtColor],
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📊 Academic Information',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: txtColor)),
          const SizedBox(height: 14),
          // ── FIX: replaced childAspectRatio with mainAxisExtent ──
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 72,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final item = items[i];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item[0] as String,
                        style: TextStyle(
                            fontSize: 11,
                            color: txtSec,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(
                      item[1] as String,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: item[2] as Color),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SHARED — Toggle Row
  // ═══════════════════════════════════════════════════════════════
  Widget _toggleRow({
    required String label,
    required String sub,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color txtColor,
    required Color txtSec,
    required Color borderColor,
    required bool showBorder,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: showBorder
            ? Border(
                bottom:
                    BorderSide(color: borderColor.withValues(alpha: 0.5)))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: txtColor)),
                Text(sub, style: TextStyle(fontSize: 11, color: txtSec)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }
}