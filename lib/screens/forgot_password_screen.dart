import 'package:flutter/material.dart';
import '../app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Views: 'forgot' -> 'reset' -> (success auto-returns)
  String _view = 'forgot';
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _loading = false;
  bool _codeSent = false;
  bool _resetSuccess = false;
  String _error = '';

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotSubmit() async {
    if (_emailController.text.trim().isEmpty) return;
    setState(() {
      _loading = true;
      _error = '';
    });
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _codeSent = true;
      _loading = false;
    });
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _view = 'reset');
    }
  }

  Future<void> _handleResetSubmit() async {
    if (_newPassController.text != _confirmPassController.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    if (_codeController.text.trim().isEmpty) {
      setState(() => _error = 'Please enter the verification code');
      return;
    }
    if (_newPassController.text.length < 4) {
      setState(() => _error = 'Password must be at least 4 characters');
      return;
    }
    setState(() {
      _loading = true;
      _error = '';
    });
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _resetSuccess = true;
      _loading = false;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.darkBg : AppTheme.background;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: txt),
          onPressed: () {
            if (_view == 'reset') {
              setState(() {
                _view = 'forgot';
                _error = '';
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: _view == 'forgot'
              ? _buildForgotView(txt, txtSec, card, border)
              : _buildResetView(txt, txtSec, card, border),
        ),
      ),
    );
  }

  Widget _buildForgotView(
      Color txt, Color txtSec, Color card, Color border) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // Icon
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_reset,
                color: AppTheme.primary, size: 40),
          ),
        ),
        const SizedBox(height: 24),

        // Title
        Center(
          child: Text(
            'Forgot Password',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: txt,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Enter your email to receive a reset code',
            style: TextStyle(fontSize: 14, color: txtSec),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 32),

        // Email Field
        Text('Email Address',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: txt)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: txt),
          decoration: _inputDeco(
            hint: 'Enter your email',
            icon: Icons.email_outlined,
            card: card,
            border: border,
            txtSec: txtSec,
          ),
        ),

        const SizedBox(height: 20),

        // Code sent message
        if (_codeSent)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Text(
              '✅ Code sent! Redirecting...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF00C853),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        // Submit button
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: (_loading || _codeSent) ? null : _handleForgotSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              disabledBackgroundColor:
                  AppTheme.primary.withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: _loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white),
                  )
                : const Text(
                    'Send Reset Code',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
          ),
        ),

        const SizedBox(height: 16),

        // Back to login
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '← Back to Login',
              style: TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResetView(
      Color txt, Color txtSec, Color card, Color border) {
    if (_resetSuccess) {
      return Column(
        children: [
          const SizedBox(height: 60),
          const Text('✅', style: TextStyle(fontSize: 50)),
          const SizedBox(height: 16),
          const Text(
            'Password Reset!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF00C853),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Redirecting to login...',
            style: TextStyle(fontSize: 13, color: txtSec),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // Icon
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.vpn_key, color: AppTheme.primary, size: 40),
          ),
        ),
        const SizedBox(height: 24),

        // Title
        Center(
          child: Text(
            'Reset Password',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: txt,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Enter the code and your new password',
            style: TextStyle(fontSize: 14, color: txtSec),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 32),

        // Verification Code
        Text('Verification Code',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: txt)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _codeController,
          keyboardType: TextInputType.number,
          style: TextStyle(color: txt),
          decoration: _inputDeco(
            hint: 'Enter 6-digit code',
            icon: Icons.pin_outlined,
            card: card,
            border: border,
            txtSec: txtSec,
          ),
        ),
        const SizedBox(height: 18),

        // New Password
        Text('New Password',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: txt)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _newPassController,
          obscureText: true,
          style: TextStyle(color: txt),
          decoration: _inputDeco(
            hint: 'Enter new password',
            icon: Icons.lock_outlined,
            card: card,
            border: border,
            txtSec: txtSec,
          ),
        ),
        const SizedBox(height: 18),

        // Confirm Password
        Text('Confirm Password',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: txt)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmPassController,
          obscureText: true,
          style: TextStyle(color: txt),
          decoration: _inputDeco(
            hint: 'Confirm new password',
            icon: Icons.lock_outlined,
            card: card,
            border: border,
            txtSec: txtSec,
          ),
        ),

        const SizedBox(height: 16),

        // Error
        if (_error.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _error,
              style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),

        // Reset button
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _loading ? null : _handleResetSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              disabledBackgroundColor:
                  AppTheme.primary.withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: _loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white),
                  )
                : const Text(
                    'Reset Password',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
          ),
        ),

        const SizedBox(height: 16),

        // Back to login
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '← Back to Login',
              style: TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDeco({
    required String hint,
    required IconData icon,
    required Color card,
    required Color border,
    required Color txtSec,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: txtSec),
      prefixIcon: Icon(icon, color: AppTheme.primary),
      filled: true,
      fillColor: card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.primary),
      ),
    );
  }
}
