import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import 'home_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe      = false;
  bool _loading         = false;
  bool get _isDark => themeModeNotifier.value == ThemeMode.dark;
  String _error         = '';

  // ── Light palette ───────────────────────────────────────────────
  static const _lightBg      = Color(0xFFFFFFFF);
  static const _lightBorder  = Color(0xFFE2E8F0);
  static const _lightText    = Color(0xFF0F172A);
  static const _lightTextSec = Color(0xFF64748B);
  static const _lightTextLit = Color(0xFFADB5BD);
  static const _lightInput   = Color(0xFFF8FAFC);

  // ── Theme getters ───────────────────────────────────────────────
  Color get _bg      => _isDark ? AppTheme.darkBg        : _lightBg;
  Color get _card    => _isDark ? AppTheme.darkCard       : _lightBg;
  Color get _border  => _isDark ? AppTheme.darkBorder     : _lightBorder;
  Color get _txt     => _isDark ? AppTheme.darkText       : _lightText;
  Color get _txtSec  => _isDark ? AppTheme.darkTextSec    : _lightTextSec;
  Color get _txtLit  => _isDark ? AppTheme.darkTextLight  : _lightTextLit;
  Color get _inputBg => _isDark ? AppTheme.darkBg2        : _lightInput;

  // ── University image based on theme ────────────────────────────
  String get _buildingImage => _isDark
      ? 'assets/images/university_transparent.png'
      : 'assets/images/university.png';

  // ✅ Email validation — must contain @ and a dot after it
  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    return regex.hasMatch(email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _error = '');
    final email = _emailController.text.trim();
    final pass  = _passwordController.text;

    // ✅ Email format check
    if (email.isEmpty || !_isValidEmail(email)) {
      setState(() => _error = 'Please enter a valid email (e.g. name@example.com)');
      return;
    }

    // ✅ Password length check
    if (pass.length < 4) {
      setState(() => _error = 'Password must be at least 4 characters');
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: _bg,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopSection(),
                _buildFormSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── TOP SECTION ─────────────────────────────────────────────────
  Widget _buildTopSection() {
    return Container(
      width: double.infinity,
      color: _bg,
      child: Stack(
        children: [
          if (_isDark)
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primary.withValues(alpha: 0.07),
                ),
              ),
            ),

          Column(
            children: [
              // ── Logo row ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 80, 0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 46,
                      height: 46,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EduSphere',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: _txt,
                            letterSpacing: -0.4,
                          ),
                        ),
                        Text(
                          'University Portal',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: _txtSec,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ── Building image ────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 245,
                child: Image.asset(
                  _buildingImage,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: ShaderMask(
                      shaderCallback: (b) =>
                          AppTheme.redGradient.createShader(b),
                      child: const Icon(
                        Icons.account_balance_rounded,
                        size: 110,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ── Tagline ───────────────────────────────────────
              Text(
                '"Empowering minds, shaping futures"',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: _txtSec,
                ),
              ),

              const SizedBox(height: 10),

              // ── Dots ──────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dot(false),
                  const SizedBox(width: 6),
                  _dot(true),
                  const SizedBox(width: 6),
                  _dot(false),
                ],
              ),

              const SizedBox(height: 22),
            ],
          ),

          // ── Dark / Light toggle ───────────────────────────────
          Positioned(
            top: 20,
            right: 16,
            child: GestureDetector(
              onTap: () {
                themeModeNotifier.value =
                _isDark ? ThemeMode.light : ThemeMode.dark;
                setState(() {}); // عشان الـ UI يتحدث
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                padding: const EdgeInsets.symmetric(
                    horizontal: 11, vertical: 6),
                decoration: BoxDecoration(
                  color: _isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: Icon(
                        _isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        key: ValueKey(_isDark),
                        size: 15,
                        color: _isDark ? Colors.white70 : Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _isDark ? 'Dark' : 'Light',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _isDark
                            ? Colors.white70
                            : const Color(0xFF475569),
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

  Widget _dot(bool active) => Container(
    width: active ? 20 : 6,
    height: 6,
    decoration: BoxDecoration(
      color: active ? AppTheme.primary : _border,
      borderRadius: BorderRadius.circular(3),
    ),
  );

  // ── FORM SECTION ─────────────────────────────────────────────────
  Widget _buildFormSection() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      decoration: BoxDecoration(
        color: _card,
        border: Border(top: BorderSide(color: _border)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome at EduSphere',
            style: GoogleFonts.inter(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: _txt,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(width: double.infinity, height: 1, color: _border),
          const SizedBox(height: 26),

          // ── Email ────────────────────────────────────────────
          Text('Email',
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _txt)),
          const SizedBox(height: 8),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.inter(color: _txt, fontSize: 14),
            decoration: _inputDeco(hint: 'Enter here'),
          ),

          const SizedBox(height: 18),

          // ── Password ─────────────────────────────────────────
          Text('Password',
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _txt)),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: GoogleFonts.inter(color: _txt, fontSize: 14),
            decoration: _inputDeco(
              hint: 'Enter password here',
              suffix: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: _txtSec,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ── Remember me ──────────────────────────────────────
          GestureDetector(
            onTap: () => setState(() => _rememberMe = !_rememberMe),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: _rememberMe,
                    onChanged: (v) =>
                        setState(() => _rememberMe = v ?? false),
                    activeColor: AppTheme.primary,
                    side: BorderSide(color: _border, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(width: 8),
                Text('Remember me',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: _txtSec)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Error ────────────────────────────────────────────
          if (_error.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.25)),
              ),
              child: Text(
                _error,
                style: GoogleFonts.inter(
                    color: AppTheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),

          // ── Sign In ──────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _loading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                disabledBackgroundColor:
                AppTheme.primary.withValues(alpha: 0.6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: _loading
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white),
              )
                  : Text(
                'Sign In',
                style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── Forgot password ───────────────────────────────────
          Center(
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ForgotPasswordScreen()),
              ),
              child: Text(
                'Forget your password?',
                style: GoogleFonts.inter(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              ),
            ),
          ),

          const SizedBox(height: 18),

          Center(
            child: Text(
              '© 2025 EduSphere. All rights reserved.',
              style: GoogleFonts.inter(fontSize: 11, color: _txtLit),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDeco({required String hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: _txtSec, fontSize: 14),
      suffixIcon: suffix,
      filled: true,
      fillColor: _inputBg,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: AppTheme.primary.withValues(alpha: 0.45), width: 2),
      ),
    );
  }
}