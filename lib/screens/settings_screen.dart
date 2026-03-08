import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../theme_provider.dart';
import '../locale_provider.dart';
import 'change_password_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SettingsScreen
    extends StatefulWidget {
  const SettingsScreen(
      {super.key});

  @override
  State<SettingsScreen>
      createState() =>
          _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  String _selectedSection =
      'profile';
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
  final _oldPwController =
      TextEditingController();
  final _newPwController =
      TextEditingController();
  final _confPwController =
      TextEditingController();
  bool _pwSaved = false;

  // Profile fields
  final _fullNameController =
      TextEditingController(
          text: 'Toka Khaled');
  final _studentIdController =
      TextEditingController(
          text: '224052');
  final _emailFieldController =
      TextEditingController(
          text:
              'toka@edusphere.edu');
  final _phoneController =
      TextEditingController(
          text:
              '+20 100 000 0000');
  final _facultyController =
      TextEditingController(
          text:
              'Business & Technology');
  final _programController =
      TextEditingController(
          text:
              'B.Sc. Management Information System');

  // Active sessions
  final List<Map<String, dynamic>>
      _sessions = [
    {
      'device':
          ' Mobile - Safari iOS',
      'ip': '192.168.1.5',
      'time': 'Now',
      'current': true
    },
    {
      'device':
          'Chrome on Windows',
      'ip': '41.234.12.80',
      'time': '2 hours ago',
      'current': false
    },
  ];

  // Academic info
  final Map<String, String>
      _acadInfo = {
    'gpa': '3.82',
    'credits': '75',
    'totalCredits': '120',
    'standing': 'Good Standing',
    'advisor': 'Dr. Ahmed Hassan',
    'gradDate': 'June 2026',
    'major': 'Computer Science',
    'minor': 'Mathematics',
  };

  final List<Map<String, String>>
      _languages = const [
    {
      'label': 'English',
      'flag': '🇬🇧',
      'code': 'en'
    },
    {
      'label': 'Arabic',
      'flag': '🇪🇬',
      'code': 'ar'
    },
    {
      'label': 'Russian',
      'flag': '🇷🇺',
      'code': 'ru'
    },
    {
      'label': 'French',
      'flag': '🇫🇷',
      'code': 'fr'
    },
    {
      'label': 'German',
      'flag': '🇩🇪',
      'code': 'de'
    },
  ];

  ThemeMode get _currentMode =>
      themeModeNotifier.value;

  void _setTheme(ThemeMode mode) {
    setState(() =>
        themeModeNotifier.value =
            mode);
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (_) =>
              const LoginScreen()),
      (_) => false,
    );
  }

  void _handleSavePw() {
    if (_newPwController
                .text.length >=
            4 &&
        _newPwController.text ==
            _confPwController
                .text) {
      setState(
          () => _pwSaved = true);
      Future.delayed(
          const Duration(
              seconds: 3),
          () => mounted
              ? setState(() =>
                  _pwSaved = false)
              : null);
      _oldPwController.clear();
      _newPwController.clear();
      _confPwController.clear();
    }
  }

  @override
  void dispose() {
    _oldPwController.dispose();
    _newPwController.dispose();
    _confPwController.dispose();
    _fullNameController.dispose();
    _studentIdController.dispose();
    _emailFieldController
        .dispose();
    _phoneController.dispose();
    _facultyController.dispose();
    _programController.dispose();
    super.dispose();
  }

  @override
  Widget build(
      BuildContext context) {
    final isDark =
        Theme.of(context)
                .brightness ==
            Brightness.dark;
    final cardColor = isDark
        ? AppTheme.darkCard
        : Colors.white;
    final borderColor = isDark
        ? AppTheme.darkBorder
        : AppTheme.border;
    final bgColor = isDark
        ? AppTheme.darkBg
        : AppTheme.background;
    final txtColor = isDark
        ? AppTheme.darkText
        : AppTheme.textPrimary;
    final txtSec = isDark
        ? AppTheme.darkTextSec
        : AppTheme.textSecondary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        leading: IconButton(
          icon: Icon(Icons.menu,
              color: txtColor),
          onPressed: HomeScreen
              .openDrawer,
        ),
        title: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            Text(
                t('settingsTitle'),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight
                            .w700,
                    color:
                        txtColor)),
            Text(t('settingsSub'),
                style: TextStyle(
                    fontSize: 11,
                    color:
                        txtSec)),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Section Nav Tabs ──────────────────────────────────
          Container(
            color: cardColor,
            child:
                SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal,
              padding:
                  const EdgeInsets
                      .symmetric(
                      horizontal:
                          12,
                      vertical: 8),
              child: Row(
                children: [
                  _navTab(
                      'profile',
                      '👤',
                      t('profile'),
                      txtColor,
                      cardColor,
                      borderColor),
                  _navTab(
                      'security',
                      '🔒',
                      t('security'),
                      txtColor,
                      cardColor,
                      borderColor),
                  _navTab(
                      'notifications',
                      '🔔',
                      t('notifications'),
                      txtColor,
                      cardColor,
                      borderColor),
                  _navTab(
                      'appearance',
                      '🎨',
                      t('appearance'),
                      txtColor,
                      cardColor,
                      borderColor),
                  _navTab(
                      'language',
                      '🌐',
                      t('language'),
                      txtColor,
                      cardColor,
                      borderColor),
                  _navTab(
                      'academic',
                      '📊',
                      t('academic'),
                      txtColor,
                      cardColor,
                      borderColor),
                ],
              ),
            ),
          ),
          Divider(
              height: 1,
              color: borderColor),

          // ── Section Content ──────────────────────────────────
          Expanded(
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets
                      .all(16),
              child: _buildSection(
                  isDark,
                  cardColor,
                  borderColor,
                  txtColor,
                  txtSec),
            ),
          ),
        ],
      ),
    );
  }

  // ── Nav Tab ──────────────────────────────────────────────────────
  Widget _navTab(
      String key,
      String icon,
      String label,
      Color txtColor,
      Color cardColor,
      Color borderColor) {
    final isActive =
        _selectedSection == key;
    return Padding(
      padding:
          const EdgeInsets.only(
              right: 6),
      child: GestureDetector(
        onTap: () => setState(() =>
            _selectedSection =
                key),
        child: Container(
          padding: const EdgeInsets
              .symmetric(
              horizontal: 14,
              vertical: 8),
          decoration:
              BoxDecoration(
            color: isActive
                ? AppTheme.primary
                    .withValues(
                        alpha: 0.1)
                : Colors
                    .transparent,
            borderRadius:
                BorderRadius
                    .circular(10),
            border: Border.all(
              color: isActive
                  ? AppTheme
                      .primary
                  : borderColor,
            ),
          ),
          child: Row(
            children: [
              Text(icon,
                  style:
                      const TextStyle(
                          fontSize:
                              14)),
              const SizedBox(
                  width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive
                      ? FontWeight
                          .w700
                      : FontWeight
                          .w500,
                  color: isActive
                      ? AppTheme
                          .primary
                      : txtColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Section Router ──────────────────────────────────────────────
  Widget _buildSection(
      bool isDark,
      Color cardColor,
      Color borderColor,
      Color txtColor,
      Color txtSec) {
    switch (_selectedSection) {
      case 'profile':
        return _buildProfile(
            cardColor,
            borderColor,
            txtColor,
            txtSec);
      case 'security':
        return _buildSecurity(
            isDark,
            cardColor,
            borderColor,
            txtColor,
            txtSec);
      case 'notifications':
        return _buildNotifications(
            isDark,
            cardColor,
            borderColor,
            txtColor,
            txtSec);
      case 'appearance':
        return _buildAppearance(
            isDark,
            cardColor,
            borderColor,
            txtColor,
            txtSec);
      case 'language':
        return _buildLanguage(
            isDark,
            cardColor,
            borderColor,
            txtColor,
            txtSec);
      case 'academic':
        return _buildAcademic(
            cardColor,
            borderColor,
            txtColor,
            txtSec);
      default:
        return const SizedBox();
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // PROFILE SECTION
  // ═══════════════════════════════════════════════════════════════
  Widget _buildProfile(
      Color cardColor,
      Color borderColor,
      Color txtColor,
      Color txtSec) {
    return Container(
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
            BorderRadius.circular(
                16),
        border: Border.all(
            color: borderColor),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          // Avatar row
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration:
                    BoxDecoration(
                  gradient:
                      const LinearGradient(
                    colors: [
                      AppTheme
                          .primary,
                      AppTheme
                          .primaryDark
                    ],
                  ),
                  shape: BoxShape
                      .circle,
                ),
                child:
                    const Center(
                  child: Text('RA',
                      style: TextStyle(
                          color: Colors
                              .white,
                          fontSize:
                              20,
                          fontWeight:
                              FontWeight
                                  .w800)),
                ),
              ),
              const SizedBox(
                  width: 14),
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                      'Toka Khaled',
                      style: TextStyle(
                          fontSize:
                              17,
                          fontWeight:
                              FontWeight
                                  .w700,
                          color:
                              txtColor)),
                  Text(
                      'toka.khaled@edusphere.edu',
                      style: TextStyle(
                          fontSize:
                              12,
                          color:
                              txtSec)),
                ],
              ),
            ],
          ),
          const SizedBox(
              height: 20),

          // Profile fields in grid
          ..._profileField(
              'Full Name',
              _fullNameController,
              txtColor,
              txtSec,
              cardColor,
              borderColor),
          ..._profileField(
              'Student ID',
              _studentIdController,
              txtColor,
              txtSec,
              cardColor,
              borderColor),
          ..._profileField(
              'Email',
              _emailFieldController,
              txtColor,
              txtSec,
              cardColor,
              borderColor),
          ..._profileField(
              'Phone',
              _phoneController,
              txtColor,
              txtSec,
              cardColor,
              borderColor),
          ..._profileField(
              'Faculty',
              _facultyController,
              txtColor,
              txtSec,
              cardColor,
              borderColor),
          ..._profileField(
              'Program',
              _programController,
              txtColor,
              txtSec,
              cardColor,
              borderColor),

          const SizedBox(
              height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton
                .icon(
              onPressed: () {
                ScaffoldMessenger
                        .of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                        '✅ Profile saved successfully!'),
                    backgroundColor:
                        Color(
                            0xFF00C853),
                  ),
                );
              },
              icon: const Text(
                  '💾',
                  style: TextStyle(
                      fontSize:
                          16)),
              label: const Text(
                  'Save Changes',
                  style: TextStyle(
                      fontWeight:
                          FontWeight
                              .w700,
                      color: Colors
                          .white)),
              style: ElevatedButton
                  .styleFrom(
                backgroundColor:
                    AppTheme
                        .primary,
                padding:
                    const EdgeInsets
                        .symmetric(
                        vertical:
                            14),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                                12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _profileField(
      String label,
      TextEditingController ctrl,
      Color txtColor,
      Color txtSec,
      Color cardColor,
      Color borderColor) {
    return [
      Text(label,
          style: TextStyle(
              fontSize: 11,
              color: txtSec,
              fontWeight:
                  FontWeight
                      .w500)),
      const SizedBox(height: 4),
      TextField(
        controller: ctrl,
        style: TextStyle(
            fontSize: 14,
            color: txtColor),
        decoration:
            InputDecoration(
          filled: true,
          fillColor: cardColor,
          contentPadding:
              const EdgeInsets
                  .symmetric(
                  horizontal: 14,
                  vertical: 12),
          border:
              OutlineInputBorder(
            borderRadius:
                BorderRadius
                    .circular(10),
            borderSide: BorderSide(
                color:
                    borderColor),
          ),
          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius
                    .circular(10),
            borderSide: BorderSide(
                color:
                    borderColor),
          ),
          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius
                    .circular(10),
            borderSide:
                const BorderSide(
                    color: AppTheme
                        .primary,
                    width: 2),
          ),
        ),
      ),
      const SizedBox(height: 12),
    ];
  }

  // ═══════════════════════════════════════════════════════════════
  // SECURITY SECTION
  // ═══════════════════════════════════════════════════════════════
  Widget _buildSecurity(
      bool isDark,
      Color cardColor,
      Color borderColor,
      Color txtColor,
      Color txtSec) {
    return Column(
      children: [
        // Change Password
        Container(
          padding:
              const EdgeInsets.all(
                  16),
          decoration:
              BoxDecoration(
            color: cardColor,
            borderRadius:
                BorderRadius
                    .circular(16),
            border: Border.all(
                color:
                    borderColor),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Text(
                  '🔑 Change Password',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight
                              .w700,
                      color:
                          txtColor)),
              const SizedBox(
                  height: 4),
              Text(
                  'Update your account password regularly to keep it secure.',
                  style: TextStyle(
                      fontSize: 12,
                      color:
                          txtSec)),
              const SizedBox(
                  height: 16),
              _secField(
                  'Current Password',
                  _oldPwController,
                  txtColor,
                  txtSec,
                  cardColor,
                  borderColor),
              _secField(
                  'New Password',
                  _newPwController,
                  txtColor,
                  txtSec,
                  cardColor,
                  borderColor),
              _secField(
                  'Confirm Password',
                  _confPwController,
                  txtColor,
                  txtSec,
                  cardColor,
                  borderColor),
              if (_pwSaved)
                const Padding(
                  padding: EdgeInsets
                      .only(
                          bottom:
                              8),
                  child: Text(
                      '✅ Password updated successfully!',
                      style: TextStyle(
                          color: Color(
                              0xFF00E676),
                          fontSize:
                              13,
                          fontWeight:
                              FontWeight
                                  .w700)),
                ),
              Align(
                alignment: Alignment
                    .centerLeft,
                child:
                    ElevatedButton(
                  onPressed:
                      _handleSavePw,
                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        AppTheme
                            .primary,
                    padding: const EdgeInsets
                        .symmetric(
                        horizontal:
                            24,
                        vertical:
                            12),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                10)),
                  ),
                  child: const Text(
                      'Save Password',
                      style: TextStyle(
                          fontWeight:
                              FontWeight
                                  .w700,
                          color: Colors
                              .white)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Active Sessions
        Container(
          padding:
              const EdgeInsets.all(
                  16),
          decoration:
              BoxDecoration(
            color: cardColor,
            borderRadius:
                BorderRadius
                    .circular(16),
            border: Border.all(
                color:
                    borderColor),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Text(
                  '💻 Active Sessions',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight
                              .w700,
                      color:
                          txtColor)),
              const SizedBox(
                  height: 4),
              Text(
                  'Manage devices that are currently signed in to your account.',
                  style: TextStyle(
                      fontSize: 12,
                      color:
                          txtSec)),
              const SizedBox(
                  height: 14),
              ..._sessions.map((s) =>
                  _sessionRow(
                      s,
                      txtColor,
                      txtSec,
                      cardColor,
                      borderColor)),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2FA
        Container(
          padding:
              const EdgeInsets.all(
                  16),
          decoration:
              BoxDecoration(
            color: cardColor,
            borderRadius:
                BorderRadius
                    .circular(16),
            border: Border.all(
                color:
                    borderColor),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Text(
                  '🛡️ Two-Factor Authentication',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight
                              .w700,
                      color:
                          txtColor)),
              const SizedBox(
                  height: 4),
              Text(
                  'Add an extra layer of security to your account.',
                  style: TextStyle(
                      fontSize: 12,
                      color:
                          txtSec)),
              const SizedBox(
                  height: 14),
              _toggleRow(
                label:
                    'Authenticator App',
                sub:
                    'Use Google Authenticator or similar',
                value: _2faAuth,
                onChanged: (v) =>
                    setState(() =>
                        _2faAuth =
                            v),
                txtColor: txtColor,
                txtSec: txtSec,
                borderColor:
                    borderColor,
                showBorder: true,
              ),
              _toggleRow(
                label:
                    'SMS Verification',
                sub:
                    'Receive codes via text message',
                value: _2faSms,
                onChanged: (v) =>
                    setState(() =>
                        _2faSms =
                            v),
                txtColor: txtColor,
                txtSec: txtSec,
                borderColor:
                    borderColor,
                showBorder: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _secField(
      String label,
      TextEditingController ctrl,
      Color txtColor,
      Color txtSec,
      Color cardColor,
      Color borderColor) {
    return Padding(
      padding:
          const EdgeInsets.only(
              bottom: 14),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: txtSec,
                  fontWeight:
                      FontWeight
                          .w600)),
          const SizedBox(
              height: 6),
          TextField(
            controller: ctrl,
            obscureText: true,
            style: TextStyle(
                fontSize: 14,
                color: txtColor),
            decoration:
                InputDecoration(
              hintText: '••••••••',
              hintStyle: TextStyle(
                  color: txtSec),
              prefixIcon: const Icon(
                  Icons.vpn_key,
                  color: AppTheme
                      .primary,
                  size: 18),
              filled: true,
              fillColor: cardColor,
              contentPadding:
                  const EdgeInsets
                      .symmetric(
                      horizontal:
                          14,
                      vertical:
                          12),
              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius
                        .circular(
                            10),
                borderSide: BorderSide(
                    color:
                        borderColor),
              ),
              enabledBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius
                        .circular(
                            10),
                borderSide: BorderSide(
                    color:
                        borderColor),
              ),
              focusedBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius
                        .circular(
                            10),
                borderSide:
                    const BorderSide(
                        color: AppTheme
                            .primary,
                        width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sessionRow(
      Map<String, dynamic> session,
      Color txtColor,
      Color txtSec,
      Color cardColor,
      Color borderColor) {
    final bool isCurrent =
        session['current'] == true;
    return Container(
      padding: const EdgeInsets
          .symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: borderColor
                    .withValues(
                        alpha:
                            0.5))),
      ),
      child: Row(
        children: [
          Text(
              isCurrent
                  ? '💻'
                  : '📱',
              style:
                  const TextStyle(
                      fontSize:
                          22)),
          const SizedBox(
              width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                    session[
                        'device'],
                    style: TextStyle(
                        fontSize:
                            13,
                        fontWeight:
                            FontWeight
                                .w700,
                        color:
                            txtColor)),
                Text(
                    'IP: ${session['ip']} · ${session['time']}',
                    style: TextStyle(
                        fontSize:
                            12,
                        color:
                            txtSec)),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding:
                  const EdgeInsets
                      .symmetric(
                      horizontal:
                          10,
                      vertical: 4),
              decoration:
                  BoxDecoration(
                color: const Color(
                        0xFF00E676)
                    .withValues(
                        alpha:
                            0.1),
                borderRadius:
                    BorderRadius
                        .circular(
                            20),
              ),
              child: const Text(
                  'THIS DEVICE',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          FontWeight
                              .w800,
                      color: Color(
                          0xFF00E676))),
            )
          else
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton
                  .styleFrom(
                foregroundColor:
                    AppTheme
                        .primary,
                side: const BorderSide(
                    color: AppTheme
                        .primary),
                padding:
                    const EdgeInsets
                        .symmetric(
                        horizontal:
                            14,
                        vertical:
                            6),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                                8)),
              ),
              child: const Text(
                  'Revoke',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          FontWeight
                              .w700)),
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // NOTIFICATIONS SECTION
  // ═══════════════════════════════════════════════════════════════
  Widget _buildNotifications(
      bool isDark,
      Color cardColor,
      Color borderColor,
      Color txtColor,
      Color txtSec) {
    return Container(
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
            BorderRadius.circular(
                16),
        border: Border.all(
            color: borderColor),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Text(
              '🔔 Notification Preferences',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight
                          .w700,
                  color:
                      txtColor)),
          const SizedBox(
              height: 4),
          Text(
              'Choose which notifications you want to receive.',
              style: TextStyle(
                  fontSize: 12,
                  color: txtSec)),
          const SizedBox(
              height: 14),
          _toggleRow(
            label:
                'Email Notifications',
            sub:
                'Receive updates via email',
            value: _notifyEmail,
            onChanged: (v) =>
                setState(() =>
                    _notifyEmail =
                        v),
            txtColor: txtColor,
            txtSec: txtSec,
            borderColor:
                borderColor,
            showBorder: true,
          ),
          _toggleRow(
            label:
                'Push Notifications',
            sub: 'Browser alerts',
            value: _notifyPush,
            onChanged: (v) =>
                setState(() =>
                    _notifyPush =
                        v),
            txtColor: txtColor,
            txtSec: txtSec,
            borderColor:
                borderColor,
            showBorder: true,
          ),
          _toggleRow(
            label: 'Grade Updates',
            sub:
                'When new grades are posted',
            value: _notifyGrades,
            onChanged: (v) =>
                setState(() =>
                    _notifyGrades =
                        v),
            txtColor: txtColor,
            txtSec: txtSec,
            borderColor:
                borderColor,
            showBorder: true,
          ),
          _toggleRow(
            label:
                'Assignment Reminders',
            sub:
                'Before due dates',
            value: _notifyAssign,
            onChanged: (v) =>
                setState(() =>
                    _notifyAssign =
                        v),
            txtColor: txtColor,
            txtSec: txtSec,
            borderColor:
                borderColor,
            showBorder: true,
          ),
          _toggleRow(
            label:
                'Attendance Alerts',
            sub:
                'Absence warnings',
            value: _notifyAttend,
            onChanged: (v) =>
                setState(() =>
                    _notifyAttend =
                        v),
            txtColor: txtColor,
            txtSec: txtSec,
            borderColor:
                borderColor,
            showBorder: false,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // APPEARANCE SECTION
  // ═══════════════════════════════════════════════════════════════
  Widget _buildAppearance(
      bool isDark,
      Color cardColor,
      Color borderColor,
      Color txtColor,
      Color txtSec) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // Theme
        Container(
          padding:
              const EdgeInsets.all(
                  16),
          decoration:
              BoxDecoration(
            color: cardColor,
            borderRadius:
                BorderRadius
                    .circular(16),
            border: Border.all(
                color:
                    borderColor),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Text('🎨 Appearance',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight
                              .w700,
                      color:
                          txtColor)),
              const SizedBox(
                  height: 4),
              Text('THEME',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight
                              .w600,
                      color:
                          txtSec)),
              const SizedBox(
                  height: 12),
              Row(
                children: [
                  _themeCard(
                      '🌙',
                      'Dark Mode',
                      ThemeMode
                          .dark,
                      cardColor,
                      borderColor,
                      txtColor),
                  const SizedBox(
                      width: 10),
                  _themeCard(
                      '☀️',
                      'Light Mode',
                      ThemeMode
                          .light,
                      cardColor,
                      borderColor,
                      txtColor),
                  const SizedBox(
                      width: 10),
                  _themeCard(
                      '🖥️',
                      'System',
                      ThemeMode
                          .system,
                      cardColor,
                      borderColor,
                      txtColor),
                ],
              ),
              const SizedBox(
                  height: 20),
              Text('ACCENT COLOR',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight
                              .w600,
                      color:
                          txtSec)),
              const SizedBox(
                  height: 12),
              Row(
                children: [
                  for (final clr
                      in [
                    const Color(
                        0xFFF44336),
                    const Color(
                        0xFF2979FF),
                    const Color(
                        0xFF00C853),
                    const Color(
                        0xFFFF9100),
                    const Color(
                        0xFF7C4DFF),
                    const Color(
                        0xFF00BCD4),
                  ])
                    Padding(
                      padding: const EdgeInsets
                          .only(
                          right:
                              12),
                      child:
                          Container(
                        width: 32,
                        height: 32,
                        decoration:
                            BoxDecoration(
                          color:
                              clr,
                          shape: BoxShape
                              .circle,
                          border: Border.all(
                              color: Colors
                                  .transparent,
                              width:
                                  2),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _themeCard(
      String icon,
      String label,
      ThemeMode mode,
      Color cardColor,
      Color borderColor,
      Color txtColor) {
    final isActive =
        _currentMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () =>
            _setTheme(mode),
        child: Container(
          padding: const EdgeInsets
              .symmetric(
              vertical: 16),
          decoration:
              BoxDecoration(
            color: cardColor,
            borderRadius:
                BorderRadius
                    .circular(12),
            border: Border.all(
              color: isActive
                  ? AppTheme
                      .primary
                  : borderColor,
              width:
                  isActive ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(icon,
                  style:
                      const TextStyle(
                          fontSize:
                              28)),
              const SizedBox(
                  height: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight
                              .w700,
                      color:
                          txtColor)),
              if (isActive) ...[
                const SizedBox(
                    height: 4),
                const Text(
                    '✓ Active',
                    style: TextStyle(
                        fontSize:
                            11,
                        color: AppTheme
                            .primary,
                        fontWeight:
                            FontWeight
                                .w700)),
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
  Widget _buildLanguage(
      bool isDark,
      Color cardColor,
      Color borderColor,
      Color txtColor,
      Color txtSec) {
    return Container(
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
            BorderRadius.circular(
                16),
        border: Border.all(
            color: borderColor),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Text('🌐 Language',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight
                          .w700,
                  color:
                      txtColor)),
          const SizedBox(
              height: 14),
          ..._languages
              .map((lang) {
            final isSelected =
                _selectedLang ==
                    lang['label'];
            return GestureDetector(
              onTap: () {
                setState(() =>
                    _selectedLang =
                        lang[
                            'label']!);
                localeNotifier
                        .value =
                    lang['code']!;
              },
              child: Container(
                padding:
                    const EdgeInsets
                        .symmetric(
                        horizontal:
                            16,
                        vertical:
                            14),
                margin:
                    const EdgeInsets
                        .only(
                        bottom: 8),
                decoration:
                    BoxDecoration(
                  borderRadius:
                      BorderRadius
                          .circular(
                              12),
                  border:
                      Border.all(
                    color: isSelected
                        ? AppTheme
                            .primary
                        : borderColor,
                    width:
                        isSelected
                            ? 2
                            : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                        lang[
                            'flag']!,
                        style: const TextStyle(
                            fontSize:
                                24)),
                    const SizedBox(
                        width: 12),
                    Expanded(
                      child: Text(
                          lang[
                              'label']!,
                          style: TextStyle(
                              fontWeight: FontWeight
                                  .w700,
                              color:
                                  txtColor,
                              fontSize:
                                  14)),
                    ),
                    if (isSelected)
                      const Text(
                          '✓',
                          style: TextStyle(
                              color: AppTheme
                                  .primary,
                              fontSize:
                                  18)),
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
      Color cardColor,
      Color borderColor,
      Color txtColor,
      Color txtSec) {
    final items = [
      [
        '🎓 Current GPA',
        '${_acadInfo['gpa']} / 4.0',
        const Color(0xFF00C853)
      ],
      [
        '📚 Credits Earned',
        '${_acadInfo['credits']} / ${_acadInfo['totalCredits']}',
        const Color(0xFF2979FF)
      ],
      [
        '🏅 Academic Standing',
        _acadInfo['standing']!,
        const Color(0xFFFF6D00)
      ],
      [
        '👨‍🏫 Academic Advisor',
        _acadInfo['advisor']!,
        txtColor
      ],
      [
        '📅 Expected Graduation',
        _acadInfo['gradDate']!,
        txtColor
      ],
      [
        '📖 Major',
        _acadInfo['major']!,
        txtColor
      ],
    ];

    return Container(
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
            BorderRadius.circular(
                16),
        border: Border.all(
            color: borderColor),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Text(
              '📊 Academic Information',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight
                          .w700,
                  color:
                      txtColor)),
          const SizedBox(
              height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children:
                items.map((item) {
              return Container(
                padding:
                    const EdgeInsets
                        .all(12),
                decoration:
                    BoxDecoration(
                  color: cardColor,
                  borderRadius:
                      BorderRadius
                          .circular(
                              12),
                  border: Border.all(
                      color:
                          borderColor),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                  children: [
                    Text(
                        item[0]
                            as String,
                        style: TextStyle(
                            fontSize:
                                11,
                            color:
                                txtSec,
                            fontWeight:
                                FontWeight.w500)),
                    const SizedBox(
                        height: 4),
                    Text(
                        item[1]
                            as String,
                        style: TextStyle(
                            fontSize:
                                15,
                            fontWeight: FontWeight
                                .w700,
                            color: item[2]
                                as Color)),
                  ],
                ),
              );
            }).toList(),
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
    required ValueChanged<bool>
        onChanged,
    required Color txtColor,
    required Color txtSec,
    required Color borderColor,
    required bool showBorder,
  }) {
    return Container(
      padding: const EdgeInsets
          .symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: showBorder
            ? Border(
                bottom: BorderSide(
                    color: borderColor
                        .withValues(
                            alpha:
                                0.5)))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize:
                            14,
                        fontWeight:
                            FontWeight
                                .w600,
                        color:
                            txtColor)),
                Text(sub,
                    style: TextStyle(
                        fontSize:
                            11,
                        color:
                            txtSec)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor:
                AppTheme.primary,
          ),
        ],
      ),
    );
  }
}
