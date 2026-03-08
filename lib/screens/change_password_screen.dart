import 'package:flutter/material.dart';
import '../app_theme.dart';

class ChangePasswordScreen
    extends StatefulWidget {
  const ChangePasswordScreen(
      {super.key});

  @override
  State<ChangePasswordScreen>
      createState() =>
          _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<
        ChangePasswordScreen> {
  final _currentPasswordController =
      TextEditingController();
  final _newPasswordController =
      TextEditingController();
  final _confirmPasswordController =
      TextEditingController();
  final _formKey =
      GlobalKey<FormState>();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool get _hasMin8 =>
      _newPasswordController
          .text.length >=
      8;
  bool get _hasUpper =>
      _newPasswordController.text
          .contains(
              RegExp(r'[A-Z]'));
  bool get _hasLower =>
      _newPasswordController.text
          .contains(
              RegExp(r'[a-z]'));
  bool get _hasNumber =>
      _newPasswordController.text
          .contains(
              RegExp(r'[0-9]'));
  bool get _hasSpecial =>
      _newPasswordController.text
          .contains(RegExp(
              r'[!@#$%^&*(),.?":{}|<>]'));

  @override
  void dispose() {
    _currentPasswordController
        .dispose();
    _newPasswordController
        .dispose();
    _confirmPasswordController
        .dispose();
    super.dispose();
  }

  @override
  Widget build(
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.darkBg : AppTheme.background;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final txtLight = isDark ? AppTheme.darkTextLight : AppTheme.textLight;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: card,
        title: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            Text('Change Password',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight
                            .w700,
                    color: txt)),
            Text(
                'Update your account password',
                style: TextStyle(
                    fontSize: 11,
                    color: txtSec)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(
                16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header Icon
              Container(
                width: 70,
                height: 70,
                decoration:
                    BoxDecoration(
                  color: isDark
                      ? AppTheme.primary.withValues(alpha: 0.15)
                      : AppTheme.primaryLight,
                  borderRadius:
                      BorderRadius
                          .circular(
                              20),
                ),
                child: const Icon(
                    Icons
                        .lock_reset,
                    color: AppTheme
                        .primary,
                    size: 36),
              ),
              const SizedBox(
                  height: 20),

              // Form Card
              Container(
                padding:
                    const EdgeInsets
                        .all(20),
                decoration:
                    BoxDecoration(
                  color: card,
                  borderRadius:
                      BorderRadius
                          .circular(
                              20),
                  border: Border.all(
                      color: border),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    // Current Password
                    Text(
                        'Current Password',
                        style: TextStyle(
                            fontSize:
                                13,
                            fontWeight: FontWeight
                                .w600,
                            color: txtSec)),
                    const SizedBox(
                        height: 8),
                    TextFormField(
                      controller:
                          _currentPasswordController,
                      obscureText:
                          _obscureCurrent,
                      style: TextStyle(color: txt),
                      validator: (v) => v ==
                                  null ||
                              v.isEmpty
                          ? 'Required'
                          : null,
                      decoration:
                          _inputDecoration(
                        hint:
                            'Enter your current password',
                        suffix: _eyeButton(
                            () => setState(() =>
                                _obscureCurrent = !_obscureCurrent),
                            _obscureCurrent),
                        fillColor: isDark ? AppTheme.darkBg2 : AppTheme.background,
                        hintColor: txtLight,
                        borderColor: border,
                      ),
                    ),
                    const SizedBox(
                        height:
                            16),

                    // New Password
                    Text(
                        'New Password',
                        style: TextStyle(
                            fontSize:
                                13,
                            fontWeight: FontWeight
                                .w600,
                            color: txtSec)),
                    const SizedBox(
                        height: 8),
                    TextFormField(
                      controller:
                          _newPasswordController,
                      obscureText:
                          _obscureNew,
                      style: TextStyle(color: txt),
                      onChanged: (_) =>
                          setState(
                              () {}),
                      validator:
                          (v) {
                        if (v ==
                                null ||
                            v.isEmpty) {
                          return 'Required';
                        }
                        if (v.length <
                            8) {
                          return 'At least 8 characters';
                        }
                        return null;
                      },
                      decoration:
                          _inputDecoration(
                        hint:
                            'Enter your new password',
                        suffix: _eyeButton(
                            () => setState(() =>
                                _obscureNew = !_obscureNew),
                            _obscureNew),
                        fillColor: isDark ? AppTheme.darkBg2 : AppTheme.background,
                        hintColor: txtLight,
                        borderColor: border,
                      ),
                    ),
                    const SizedBox(
                        height:
                            16),

                    // Confirm Password
                    Text(
                        'Confirm New Password',
                        style: TextStyle(
                            fontSize:
                                13,
                            fontWeight: FontWeight
                                .w600,
                            color: txtSec)),
                    const SizedBox(
                        height: 8),
                    TextFormField(
                      controller:
                          _confirmPasswordController,
                      obscureText:
                          _obscureConfirm,
                      style: TextStyle(color: txt),
                      validator:
                          (v) {
                        if (v ==
                                null ||
                            v.isEmpty) {
                          return 'Required';
                        }
                        if (v !=
                            _newPasswordController
                                .text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      decoration:
                          _inputDecoration(
                        hint:
                            'Confirm your new password',
                        suffix: _eyeButton(
                            () => setState(() =>
                                _obscureConfirm = !_obscureConfirm),
                            _obscureConfirm),
                        fillColor: isDark ? AppTheme.darkBg2 : AppTheme.background,
                        hintColor: txtLight,
                        borderColor: border,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                  height: 16),

              // Requirements + Tips Row
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  // Requirements
                  Expanded(
                    child:
                        Container(
                      padding:
                          const EdgeInsets
                              .all(
                              16),
                      decoration:
                          BoxDecoration(
                        color: card,
                        borderRadius:
                            BorderRadius.circular(
                                16),
                        border: Border.all(
                            color: border),
                      ),
                      child:
                          Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                              'Password Requirements',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: txt)),
                          const SizedBox(
                              height:
                                  12),
                          _RequirementItem(
                              label:
                                  'At least 8 characters',
                              met:
                                  _hasMin8),
                          _RequirementItem(
                              label:
                                  'Contains uppercase letter',
                              met:
                                  _hasUpper),
                          _RequirementItem(
                              label:
                                  'Contains lowercase letter',
                              met:
                                  _hasLower),
                          _RequirementItem(
                              label:
                                  'Contains number',
                              met:
                                  _hasNumber),
                          _RequirementItem(
                              label:
                                  'Contains special character',
                              met:
                                  _hasSpecial),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                      width: 12),

                  // Security Tips
                  Expanded(
                    child:
                        Container(
                      padding:
                          const EdgeInsets
                              .all(
                              16),
                      decoration:
                          BoxDecoration(
                        color: isDark
                            ? AppTheme.primary.withValues(alpha: 0.1)
                            : AppTheme.primaryLight,
                        borderRadius:
                            BorderRadius.circular(
                                16),
                        border: Border.all(
                            color: AppTheme
                                .primary
                                .withValues(alpha: 0.2)),
                      ),
                      child:
                          Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                              'Security Tips',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: txt)),
                          const SizedBox(
                              height:
                                  12),
                          const _TipItem(
                              text:
                                  'Use a unique password for this account'),
                          const _TipItem(
                              text:
                                  'Avoid using personal information'),
                          const _TipItem(
                              text:
                                  'Change your password regularly'),
                          const _TipItem(
                              text:
                                  'Never share your password'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 20),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child:
                        SizedBox(
                      height: 50,
                      child:
                          ElevatedButton(
                        onPressed:
                            () {
                          if (_formKey
                              .currentState!
                              .validate()) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text('✅ Password updated successfully!'),
                                backgroundColor: AppTheme.success,
                              ),
                            );
                            Navigator.pop(
                                context);
                          }
                        },
                        child: const Text(
                            'Update Password',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                  const SizedBox(
                      width: 12),
                  Expanded(
                    child:
                        SizedBox(
                      height: 50,
                      child:
                          OutlinedButton(
                        onPressed: () =>
                            Navigator.pop(
                                context),
                        style: OutlinedButton
                            .styleFrom(
                          side: BorderSide(
                              color: border),
                          foregroundColor: txtSec,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12)),
                        ),
                        child: const Text(
                            'Cancel',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                      ),
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

  InputDecoration _inputDecoration(
      {required String hint,
      Widget? suffix,
      required Color fillColor,
      required Color hintColor,
      required Color borderColor}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          color: hintColor,
          fontSize: 13),
      prefixIcon: const Icon(
          Icons.lock_outline,
          color: AppTheme.primary,
          size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
                12),
        borderSide:
            BorderSide(
                color: borderColor),
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
                12),
        borderSide:
            BorderSide(
                color: borderColor),
      ),
      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
                12),
        borderSide:
            const BorderSide(
                color: AppTheme
                    .primary,
                width: 2),
      ),
    );
  }

  Widget _eyeButton(
      VoidCallback onTap,
      bool obscure) {
    return IconButton(
      icon: Icon(
          obscure
              ? Icons
                  .visibility_off
              : Icons.visibility,
          color: AppTheme
              .textSecondary,
          size: 20),
      onPressed: onTap,
    );
  }
}

class _RequirementItem
    extends StatelessWidget {
  final String label;
  final bool met;

  const _RequirementItem(
      {required this.label,
      required this.met});

  @override
  Widget build(
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;

    return Padding(
      padding:
          const EdgeInsets.only(
              bottom: 8),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration:
                BoxDecoration(
              shape:
                  BoxShape.circle,
              color: met
                  ? AppTheme
                      .success
                      .withValues(
                          alpha:
                              0.1)
                  : Colors
                      .transparent,
              border: Border.all(
                color: met
                    ? AppTheme
                        .success
                    : border,
                width: 1.5,
              ),
            ),
            child: met
                ? const Icon(
                    Icons.check,
                    size: 11,
                    color: AppTheme
                        .success)
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: met
                        ? AppTheme
                            .success
                        : txtSec)),
          ),
        ],
      ),
    );
  }
}

class _TipItem
    extends StatelessWidget {
  final String text;

  const _TipItem(
      {required this.text});

  @override
  Widget build(
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    return Padding(
      padding:
          const EdgeInsets.only(
              bottom: 8),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Container(
            width: 5,
            height: 5,
            margin:
                const EdgeInsets
                    .only(top: 5),
            decoration:
                const BoxDecoration(
              color:
                  AppTheme.primary,
              shape:
                  BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 12,
                    color: txtSec,
                    height: 1.4)),
          ),
        ],
      ),
    );
  }
}
