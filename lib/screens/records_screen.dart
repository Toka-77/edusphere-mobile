import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'home_screen.dart';

class RecordsScreen
    extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(
      BuildContext context) {
    final isDark =
        Theme.of(context)
            .brightness ==
            Brightness.dark;
    final txt = isDark
        ? AppTheme.darkText
        : AppTheme.textPrimary;
    final txtSec = isDark
        ? AppTheme.darkTextSec
        : AppTheme.textSecondary;
    final card = isDark
        ? AppTheme.darkCard
        : Colors.white;
    final bg = isDark
        ? AppTheme.darkBg
        : AppTheme.background;
    final brd = isDark
        ? AppTheme.darkBorder
        : AppTheme.border;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: card,
        leading: IconButton(
          icon: Icon(Icons.menu,
              color: txt),
          onPressed: HomeScreen
              .openDrawer,
        ),
        title: Column(
          crossAxisAlignment:
          CrossAxisAlignment
              .start,
          children: [
            Text(
                'Records & Enrollment',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight
                        .w700,
                    color: txt)),
            Text(
                'Your official academic record and status',
                style: TextStyle(
                    fontSize: 11,
                    color:
                    txtSec)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(
            16),
        child: Column(
          children: [
            // ── Student ID Card ────────────────────────────────────
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
                    color: brd),
                boxShadow: [
                  BoxShadow(
                    color: Colors
                        .black
                        .withValues(
                        alpha:
                        0.05),
                    blurRadius: 10,
                    offset:
                    const Offset(
                        0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration:
                    BoxDecoration(
                      color: AppTheme
                          .primary,
                      borderRadius:
                      BorderRadius
                          .circular(
                          20),
                    ),
                    child: const Icon(
                        Icons
                            .person,
                        color: Colors
                            .white,
                        size: 40),
                  ),
                  const SizedBox(
                      height: 12),
                  Text(
                      'TOKA KHALED',
                      style: TextStyle(
                          fontSize:
                          20,
                          fontWeight:
                          FontWeight
                              .w700,
                          color:
                          txt)),
                  Text(
                      'ID: 21at41',
                      style: TextStyle(
                          fontSize:
                          13,
                          color:
                          txtSec,
                          fontWeight:
                          FontWeight
                              .w500)),
                  const SizedBox(
                      height: 16),
                  _InfoTile(
                      icon: Icons
                          .school_outlined,
                      label:
                      'Faculty',
                      value:
                      'Engineering & Technology'),
                  const SizedBox(
                      height: 8),
                  _InfoTile(
                      icon: Icons
                          .menu_book_outlined,
                      label:
                      'Program',
                      value:
                      'B.Sc. in Computer Science'),
                  const SizedBox(
                      height: 8),
                  _InfoTile(
                      icon: Icons
                          .calendar_today_outlined,
                      label:
                      'Year',
                      value:
                      '4th Year'),
                  const SizedBox(
                      height: 8),
                  _InfoTile(
                      icon: Icons
                          .grade_outlined,
                      label: 'GPA',
                      value:
                      '3.82 / 4.0'),
                  const SizedBox(height: 8),
                  _InfoTile(
                      icon: Icons
                          .credit_card_outlined,
                      label: 'Credits',
                      value: '75 / 120'),
                  const SizedBox(
                      height: 16),
                  Container(
                    padding: const EdgeInsets
                        .symmetric(
                        horizontal:
                        16,
                        vertical:
                        12),
                    decoration:
                    BoxDecoration(
                      color: AppTheme
                          .success
                          .withValues(
                          alpha:
                          0.1),
                      borderRadius:
                      BorderRadius
                          .circular(
                          12),
                      border: Border.all(
                          color: AppTheme
                              .success
                              .withValues(
                              alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Row(
                            children: [
                              const Icon(
                                  Icons.check_circle,
                                  color: AppTheme.success,
                                  size: 18),
                              const SizedBox(
                                  width: 8),
                              Text(
                                  'Active Enrollment',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: txt)),
                            ]),
                        const Text(
                            'ACTIVE',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: AppTheme.success)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 20),

            // ── Current Semester Enrollment ────────────────────────
            Container(
              padding:
              const EdgeInsets
                  .all(18),
              decoration:
              BoxDecoration(
                color: card,
                borderRadius:
                BorderRadius
                    .circular(
                    16),
                border: Border.all(
                    color: brd),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    children: [
                      Row(
                          children: [
                            const Icon(
                                Icons.menu_book_outlined,
                                color: AppTheme.primary,
                                size: 18),
                            const SizedBox(
                                width: 8),
                            Text(
                                'Current Semester Enrollment',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: txt)),
                          ]),
                      GestureDetector(
                        onTap:
                            () {},
                        child: const Row(
                            children: [
                              Icon(
                                  Icons.download_outlined,
                                  size: 14,
                                  color: AppTheme.primary),
                              SizedBox(
                                  width: 4),
                              Text(
                                  'Download',
                                  style: TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.w500)),
                            ]),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 14),
                  const _EnrollRow(
                      course:
                      'Advanced Software Engineering',
                      code:
                      'CS482',
                      credits: '3',
                      type: 'CORE',
                      typeColor:
                      AppTheme
                          .info,
                      status:
                      'Registered'),
                  Divider(
                      height: 16,
                      color: brd),
                  const _EnrollRow(
                      course:
                      'Database Systems II',
                      code:
                      'CS485',
                      credits: '3',
                      type: 'CORE',
                      typeColor:
                      AppTheme
                          .info,
                      status:
                      'Registered'),
                  Divider(
                      height: 16,
                      color: brd),
                  const _EnrollRow(
                      course:
                      'Discrete Mathematics',
                      code:
                      'MAT381',
                      credits: '4',
                      type:
                      'REQUIRED',
                      typeColor:
                      AppTheme
                          .warning,
                      status:
                      'Registered'),
                  Divider(
                      height: 16,
                      color: brd),
                  const _EnrollRow(
                      course:
                      'Professional Ethics',
                      code:
                      'HSS281',
                      credits: '2',
                      type:
                      'ELECTIVE',
                      typeColor:
                      AppTheme
                          .success,
                      status:
                      'Registered'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Semester Transcript ────────────────────────────────
            _TranscriptTable(brd: brd, card: card, txt: txt, txtSec: txtSec),
            const SizedBox(height: 20),

            // ── Academic Milestones ────────────────────────────────
            Container(
              padding:
              const EdgeInsets
                  .all(18),
              decoration:
              BoxDecoration(
                color: card,
                borderRadius:
                BorderRadius
                    .circular(
                    16),
                border: Border.all(
                    color: brd),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Row(children: [
                    const Icon(
                        Icons
                            .description_outlined,
                        color: AppTheme
                            .textSecondary,
                        size: 18),
                    const SizedBox(
                        width: 8),
                    Text(
                        'Academic Milestones',
                        style: TextStyle(
                            fontWeight: FontWeight
                                .w700,
                            fontSize:
                            15,
                            color:
                            txt)),
                  ]),
                  const SizedBox(
                      height: 14),

                  // Row 1
                  Row(children: [
                    Expanded(
                      child:
                      _MilestoneCard(
                        title:
                        'Freshman Year',
                        date:
                        'June 2023',
                        status:
                        'COMPLETED',
                        statusColor:
                        AppTheme
                            .success,
                        borderColor:
                        AppTheme
                            .success,
                      ),
                    ),
                    const SizedBox(
                        width: 12),
                    Expanded(
                      child:
                      _MilestoneCard(
                        title:
                        'Sophomore Year',
                        date:
                        'June 2024',
                        status:
                        'COMPLETED',
                        statusColor:
                        AppTheme
                            .success,
                        borderColor:
                        AppTheme
                            .success,
                      ),
                    ),
                  ]),
                  const SizedBox(
                      height: 12),

                  // Row 2
                  Row(children: [
                    Expanded(
                      child:
                      _MilestoneCard(
                        title:
                        'Junior Year',
                        date:
                        '1-4 June 2025',
                        status:
                        'IN PROGRESS',
                        statusColor:
                        AppTheme
                            .info,
                        borderColor:
                        AppTheme
                            .info,
                      ),
                    ),
                    const SizedBox(
                        width: 12),
                    Expanded(
                      child:
                      _MilestoneCard(
                        title:
                        'Senior Project',
                        date: 'Pending',
                        status:
                        'PENDING',
                        statusColor:
                        AppTheme
                            .textLight,
                        borderColor:
                        AppTheme
                            .border,
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(
                height: 16),
          ],
        ),
      ),
    );
  }
}

// ── Transcript Table ──────────────────────────────────────────────

class _TranscriptTable extends StatelessWidget {
  final Color brd, card, txt, txtSec;
  const _TranscriptTable({
    required this.brd,
    required this.card,
    required this.txt,
    required this.txtSec,
  });

  @override
  Widget build(BuildContext context) {
    final rows = [
      {'sem': 'Fall 2022',   'gpa': '3.8', 'credits': '18', 'honor': "Dean's List"},
      {'sem': 'Spring 2023', 'gpa': '3.9', 'credits': '18', 'honor': "Dean's List"},
      {'sem': 'Fall 2023',   'gpa': '3.7', 'credits': '18', 'honor': '—'},
      {'sem': 'Spring 2024', 'gpa': '3.8', 'credits': '18', 'honor': '—'},
      {'sem': 'Fall 2024',   'gpa': '3.9', 'credits': '15', 'honor': "Dean's List"},
    ];
    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: brd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              const Icon(Icons.article_outlined, color: AppTheme.primary, size: 18),
              const SizedBox(width: 8),
              Text('Semester Transcript',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: txt)),
            ]),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.06),
              border: Border(top: BorderSide(color: brd), bottom: BorderSide(color: brd)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(children: [
              Expanded(flex: 2, child: Text('Semester', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: txtSec))),
              Expanded(child: Text('GPA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: txtSec))),
              Expanded(child: Text('Credits', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: txtSec))),
              Expanded(flex: 2, child: Text('Honor', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: txtSec))),
            ]),
          ),
          ...rows.map((r) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: brd.withValues(alpha: 0.5))),
            ),
            child: Row(children: [
              Expanded(flex: 2, child: Text(r['sem']!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: txt))),
              // GPA in green (#00c853) matching web
              Expanded(child: Text(r['gpa']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.success))),
              Expanded(child: Text('${r['credits']!} cr', style: TextStyle(fontSize: 13, color: txtSec))),
              Expanded(flex: 2, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: r['honor'] == 'In Progress'
                      ? AppTheme.info.withValues(alpha: 0.1)
                      : r['honor'] == '—'
                      ? brd.withValues(alpha: 0.5)
                      : AppTheme.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(r['honor']!,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: r['honor'] == 'In Progress'
                            ? AppTheme.info
                            : r['honor'] == '—'
                            ? txtSec
                            : AppTheme.success)),
              )),
            ]),
          )),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────

class _InfoTile
    extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoTile(
      {required this.icon,
        required this.label,
        required this.value});

  @override
  Widget build(
      BuildContext context) {
    final isDark =
        Theme.of(context)
            .brightness ==
            Brightness.dark;
    final txt = isDark
        ? AppTheme.darkText
        : AppTheme.textPrimary;
    final txtSec = isDark
        ? AppTheme.darkTextSec
        : AppTheme.textSecondary;
    final tileBg = isDark
        ? AppTheme.darkBg2
        : AppTheme.background;

    return Container(
      padding: const EdgeInsets
          .symmetric(
          horizontal: 14,
          vertical: 12),
      decoration: BoxDecoration(
        color: tileBg,
        borderRadius:
        BorderRadius.circular(
            10),
      ),
      child: Row(children: [
        Icon(icon,
            size: 16,
            color:
            AppTheme.primary),
        const SizedBox(width: 10),
        Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 10,
                      color:
                      txtSec,
                      fontWeight:
                      FontWeight
                          .w500)),
              Text(value,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                      FontWeight
                          .w600,
                      color: txt)),
            ]),
      ]),
    );
  }
}

class _EnrollRow
    extends StatelessWidget {
  final String course,
      code,
      credits,
      type,
      status;
  final Color typeColor;
  const _EnrollRow(
      {required this.course,
        required this.code,
        required this.credits,
        required this.type,
        required this.typeColor,
        required this.status});

  @override
  Widget build(
      BuildContext context) {
    final isDark =
        Theme.of(context)
            .brightness ==
            Brightness.dark;
    final txt = isDark
        ? AppTheme.darkText
        : AppTheme.textPrimary;
    final txtSec = isDark
        ? AppTheme.darkTextSec
        : AppTheme.textSecondary;

    return Row(children: [
      Expanded(
        flex: 3,
        child: Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Text(course,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                      FontWeight
                          .w600,
                      color: txt)),
              Text(code,
                  style: TextStyle(
                      fontSize: 11,
                      color:
                      txtSec)),
            ]),
      ),
      Text(credits,
          style: TextStyle(
              fontSize: 13,
              color: txtSec)),
      const SizedBox(width: 10),
      Container(
        padding: const EdgeInsets
            .symmetric(
            horizontal: 8,
            vertical: 3),
        decoration: BoxDecoration(
          color:
          typeColor.withValues(
              alpha: 0.1),
          borderRadius:
          BorderRadius
              .circular(6),
        ),
        child: Text(type,
            style: TextStyle(
                fontSize: 10,
                fontWeight:
                FontWeight
                    .w700,
                color: typeColor)),
      ),
      const SizedBox(width: 10),
      Row(children: [
        const Icon(Icons.circle,
            size: 8,
            color:
            AppTheme.success),
        const SizedBox(width: 4),
        Text(status,
            style: const TextStyle(
                fontSize: 12,
                color: AppTheme
                    .success,
                fontWeight:
                FontWeight
                    .w500)),
      ]),
    ]);
  }
}

class _MilestoneCard
    extends StatelessWidget {
  final String title, date, status;
  final Color statusColor,
      borderColor;
  const _MilestoneCard(
      {required this.title,
        required this.date,
        required this.status,
        required this.statusColor,
        required this.borderColor});

  @override
  Widget build(
      BuildContext context) {
    final isDark =
        Theme.of(context)
            .brightness ==
            Brightness.dark;
    final txt = isDark
        ? AppTheme.darkText
        : AppTheme.textPrimary;
    final txtSec = isDark
        ? AppTheme.darkTextSec
        : AppTheme.textSecondary;
    final cardBg = isDark
        ? AppTheme.darkCard
        : Colors.white;
    final brd = isDark
        ? AppTheme.darkBorder
        : AppTheme.border;
    return ClipRRect(
      borderRadius:
      BorderRadius.circular(
          12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: brd),
          borderRadius:
          BorderRadius
              .circular(12),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
            children: [
              Container(
                  width: 3,
                  color:
                  borderColor),
              Expanded(
                child: Container(
                  color: cardBg,
                  padding:
                  const EdgeInsets
                      .all(14),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontWeight: FontWeight
                                  .w600,
                              fontSize:
                              13,
                              color:
                              txt)),
                      const SizedBox(
                          height:
                          4),
                      Text(date,
                          style: TextStyle(
                              fontSize:
                              11,
                              color:
                              txtSec)),
                      const SizedBox(
                          height:
                          6),
                      Text(status,
                          style: TextStyle(
                              fontSize:
                              11,
                              fontWeight: FontWeight
                                  .w700,
                              color:
                              statusColor)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
