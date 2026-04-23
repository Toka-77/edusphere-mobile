import 'package:flutter/material.dart';
import '../app_theme.dart';

class AcademicWarningsScreen extends StatelessWidget {
  const AcademicWarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.darkBg : AppTheme.background;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: card,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Academic Warnings',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700, color: txt)),
            Text('Important notifications regarding your academic standing',
                style: TextStyle(fontSize: 11, color: txtSec)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Warning 1 — orange (medium, like web: #ff9100)
          _WarningCard(
            title: 'Attendance Warning',
            subtitle: 'CS402 - Advanced Software Engineering',
            message:
            'Your attendance in this course has dropped below 80%. Please ensure regular attendance to avoid being barred from the final exam.',
            issuedDate: 'Issued on 12 Oct 2025',
            severity: 'Medium',
            severityColor: AppTheme.warning, // #ff9100
            onAppeal: () {},
            onPolicy: () {},
          ),
          const SizedBox(height: 12),
          // Warning 2 — red (high, like web: #f44336)
          _WarningCard(
            title: 'Academic Warning',
            subtitle: 'Overall GPA',
            message:
            'Your current GPA is 2.1. Students with a GPA below 2.0 will be placed on academic probation next semester.',
            issuedDate: 'Issued on 05 Sep 2025',
            severity: 'High',
            severityColor: AppTheme.primary, // #f44336
            onAppeal: () {},
            onPolicy: () {},
          ),
          const SizedBox(height: 16),
          // Policy Note — matches web .warn-note
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.blue.withValues(alpha: 0.08)
                  : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppTheme.blue.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ℹ️', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Academic Policy Note',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: AppTheme.blue)),
                      const SizedBox(height: 4),
                      Text(
                        'Warnings are issued automatically based on your academic performance and attendance records. '
                            'If you believe there is an error, please contact your academic advisor within 7 days of the issuance date.',
                        style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppTheme.darkTextSec : AppTheme.textSecondary,
                            height: 1.6),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Warning Card — matches web .warn-card with colored left border ──

class _WarningCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String message;
  final String issuedDate;
  final String severity;
  final Color severityColor;
  final VoidCallback onAppeal;
  final VoidCallback onPolicy;

  const _WarningCard({
    required this.title,
    required this.subtitle,
    required this.message,
    required this.issuedDate,
    required this.severity,
    required this.severityColor,
    required this.onAppeal,
    required this.onPolicy,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;

    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        // Web: border-left: 4px solid {color}
      ),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Colored left accent strip (matches web border-left: 4px solid)
            Container(width: 4, color: severityColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dot + title/subtitle
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Colored dot (web: .warn-dot)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: severityColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: txt)),
                                    const SizedBox(height: 2),
                                    Text(subtitle,
                                        style: TextStyle(
                                            fontSize: 12, color: txtSec)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Appeal + Policy buttons
                        Column(
                          children: [
                            OutlinedButton(
                              onPressed: onAppeal,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                foregroundColor: AppTheme.primary,
                                side: const BorderSide(
                                    color: AppTheme.primary),
                                minimumSize: Size.zero,
                                textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(8)),
                              ),
                              child: const Text('Request Appeal'),
                            ),
                            const SizedBox(height: 6),
                            OutlinedButton(
                              onPressed: onPolicy,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                foregroundColor: txtSec,
                                side: BorderSide(color: border),
                                minimumSize: Size.zero,
                                textStyle:
                                const TextStyle(fontSize: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(8)),
                              ),
                              child: const Text('View Policy'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Description (web: .warn-desc)
                    Text(message,
                        style: TextStyle(
                            fontSize: 13, color: txt, height: 1.5)),
                    const SizedBox(height: 12),
                    // Footer: date + severity (web: .warn-footer)
                    Row(
                      children: [
                        Text('📅 $issuedDate',
                            style: TextStyle(
                                fontSize: 12, color: txtSec)),
                        const SizedBox(width: 12),
                        Text('· Severity: ',
                            style: TextStyle(
                                fontSize: 12, color: txtSec)),
                        Text(severity,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: severityColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
