import 'package:flutter/material.dart';
import '../app_theme.dart';

class AcademicWarningsScreen
    extends StatelessWidget {
  const AcademicWarningsScreen(
      {super.key});

  @override
  Widget build(
      BuildContext context) {
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
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            Text(
                'Academic Warnings',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight
                            .w700,
                    color: txt)),
            Text(
                'Important notifications regarding your academic standing',
                style: TextStyle(
                    fontSize: 11,
                    color: txtSec)),
          ],
        ),
      ),
      body: ListView(
        padding:
            const EdgeInsets.all(
                16),
        children: [
          _WarningCard(
            title:
                'Attendance Warning',
            subtitle:
                'CS402 - Advanced Software Engineering',
            message:
                'Your attendance in this course has dropped below 80%. Please ensure regular attendance to avoid being barred from the final exam.',
            issuedDate:
                'Issued on 12 Oct 2025',
            severity: 'Medium',
            severityColor:
                AppTheme.warning,
            onAppeal: () {},
            onPolicy: () {},
          ),
          const SizedBox(
              height: 12),
          _WarningCard(
            title:
                'Academic Warning',
            subtitle:
                'Overall GPA',
            message:
                'Your current GPA is 2.1. Students with a GPA below 2.0 will be placed on academic probation next semester.',
            issuedDate:
                'Issued on 05 Sep 2025',
            severity: 'High',
            severityColor:
                AppTheme.primary,
            onAppeal: () {},
            onPolicy: () {},
          ),
          const SizedBox(
              height: 16),
          Builder(
            builder: (context) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Container(
                padding:
                    const EdgeInsets
                        .all(16),
                decoration:
                    BoxDecoration(
                  color: isDark
                      ? AppTheme.info.withValues(alpha: 0.1)
                      : const Color(0xFFEFF6FF),
                  borderRadius:
                      BorderRadius
                          .circular(
                              14),
                  border: Border.all(
                      color: AppTheme
                          .info
                          .withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    const Icon(
                        Icons
                            .info_outline,
                        color: AppTheme
                            .info,
                        size: 20),
                    const SizedBox(
                        width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                              'Academic Policy Note',
                              style: TextStyle(
                                  fontWeight: FontWeight
                                      .w700,
                                  fontSize:
                                      13,
                                  color:
                                      AppTheme.info)),
                          SizedBox(
                              height:
                                  4),
                          Text(
                            'Warnings are issued automatically based on your academic performance and attendance records. If you believe there is an error, please contact your academic advisor within 7 days of the issuance date.',
                            style: TextStyle(
                                fontSize:
                                    12,
                                color: AppTheme
                                    .info,
                                height:
                                    1.5),
                          ),
                        ],
                      ),
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
}

class _WarningCard
    extends StatelessWidget {
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
  Widget build(
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final txtLight = isDark ? AppTheme.darkTextLight : AppTheme.textLight;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;

    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius:
            BorderRadius.circular(
                16),
        border: Border.all(
            color: border),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Icon(
                  Icons
                      .shield_outlined,
                  color: txtSec,
                  size: 20),
              const SizedBox(
                  width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight
                                .w700,
                            fontSize:
                                15,
                            color: txt)),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize:
                                12,
                            color: txtSec)),
                  ],
                ),
              ),
              Column(
                children: [
                  OutlinedButton(
                    onPressed:
                        onAppeal,
                    style: OutlinedButton
                        .styleFrom(
                      padding: const EdgeInsets
                          .symmetric(
                          horizontal:
                              12,
                          vertical:
                              6),
                      foregroundColor:
                          AppTheme
                              .primary,
                      side: const BorderSide(
                          color: AppTheme
                              .primary),
                      minimumSize:
                          Size.zero,
                      textStyle: const TextStyle(
                          fontSize:
                              12,
                          fontWeight:
                              FontWeight
                                  .w600),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  8)),
                    ),
                    child: const Text(
                        'Request Appeal'),
                  ),
                  const SizedBox(
                      height: 6),
                  OutlinedButton(
                    onPressed:
                        onPolicy,
                    style: OutlinedButton
                        .styleFrom(
                      padding: const EdgeInsets
                          .symmetric(
                          horizontal:
                              12,
                          vertical:
                              6),
                      foregroundColor: txtSec,
                      side: BorderSide(
                          color: border),
                      minimumSize:
                          Size.zero,
                      textStyle: const TextStyle(
                          fontSize:
                              12),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  8)),
                    ),
                    child: const Text(
                        'View Policy'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
              height: 12),
          Text(message,
              style: TextStyle(
                  fontSize: 13,
                  color: txt,
                  height: 1.5)),
          const SizedBox(
              height: 12),
          Row(
            children: [
              Icon(
                  Icons
                      .calendar_today_outlined,
                  size: 13,
                  color: txtLight),
              const SizedBox(
                  width: 4),
              Text(issuedDate,
                  style: TextStyle(
                      fontSize: 12,
                      color: txtSec)),
              const SizedBox(
                  width: 16),
              Icon(
                  Icons
                      .warning_amber_outlined,
                  size: 13,
                  color: txtLight),
              const SizedBox(
                  width: 4),
              Text(
                  'Severity: $severity',
                  style: TextStyle(
                      fontSize: 12,
                      color:
                          severityColor,
                      fontWeight:
                          FontWeight
                              .w500)),
            ],
          ),
        ],
      ),
    );
  }
}
