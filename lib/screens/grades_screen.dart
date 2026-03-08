import 'package:flutter/material.dart';
import '../app_theme.dart';

class GradesScreen
    extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.darkBg : AppTheme.background;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: card,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Grades', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: txt)),
            Text('Track your academic performance', style: TextStyle(fontSize: 11, color: txtSec)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                Text('Fall 2024', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: txt)),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 16, color: txtSec),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _StatBox(label: 'Current GPA', value: '3.61', sub: 'Out of 4.0', color: AppTheme.primary, bg: AppTheme.primaryLight)),
                const SizedBox(width: 10),
                Expanded(child: _StatBox(label: 'Overall Average', value: '90.4%', sub: '↑ +2.5% from last semester', color: AppTheme.success, bg: const Color(0xFFECFDF5))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _StatBox(label: 'Total Credits', value: '16', sub: 'This semester', color: AppTheme.info, bg: const Color(0xFFEFF6FF))),
                const SizedBox(width: 10),
                Expanded(child: _StatBox(label: 'Courses', value: '5', sub: 'Currently enrolled', color: AppTheme.purple, bg: const Color(0xFFF5F3FF))),
              ],
            ),
            const SizedBox(height: 20),

            // CS401
            _CourseGradeCard(
              code: 'CS401',
              credits: '3 credits',
              name:
                  'Advanced Web Development',
              instructor:
                  'Dr. Sarah Johnson',
              percent: 0.95,
              grade: '95%',
              gradeLabel:
                  'Grade: A',
              color:
                  AppTheme.primary,
              items: [
                _GradeBreakdownItem(
                    label:
                        'Project 1',
                    score:
                        '95/100',
                    percent: 0.95,
                    weight: '20%'),
                _GradeBreakdownItem(
                    label:
                        'Project 2',
                    score:
                        '98/100',
                    percent: 0.98,
                    weight: '20%'),
                _GradeBreakdownItem(
                    label:
                        'Midterm Exam',
                    score:
                        '92/100',
                    percent: 0.92,
                    weight: '25%'),
                _GradeBreakdownItem(
                    label:
                        'Final Project',
                    score:
                        '95/100',
                    percent: 0.95,
                    weight: '35%'),
              ],
            ),
            SizedBox(height: 16),

            // MATH301
            _CourseGradeCard(
              code: 'MATH301',
              credits: '4 credits',
              name:
                  'Advanced Mathematics',
              instructor:
                  'Prof. Michael Chen',
              percent: 0.88,
              grade: '88%',
              gradeLabel:
                  'Grade: B+',
              color: AppTheme.info,
              items: [
                _GradeBreakdownItem(
                    label:
                        'Problem Set 1',
                    score:
                        '85/100',
                    percent: 0.85,
                    weight: '15%'),
                _GradeBreakdownItem(
                    label:
                        'Problem Set 2',
                    score:
                        '90/100',
                    percent: 0.90,
                    weight: '15%'),
                _GradeBreakdownItem(
                    label:
                        'Midterm Exam',
                    score:
                        '88/100',
                    percent: 0.88,
                    weight: '30%'),
                _GradeBreakdownItem(
                    label:
                        'Final Exam',
                    score:
                        '89/100',
                    percent: 0.89,
                    weight: '40%'),
              ],
            ),
            SizedBox(height: 16),

            // ENG201
            _CourseGradeCard(
              code: 'ENG201',
              credits: '3 credits',
              name:
                  'Technical Communication',
              instructor:
                  'Prof. Lisa Anderson',
              percent: 0.92,
              grade: '92%',
              gradeLabel:
                  'Grade: A-',
              color:
                  AppTheme.success,
              items: [
                _GradeBreakdownItem(
                    label:
                        'Essay 1',
                    score:
                        '90/100',
                    percent: 0.90,
                    weight: '25%'),
                _GradeBreakdownItem(
                    label:
                        'Essay 2',
                    score:
                        '94/100',
                    percent: 0.94,
                    weight: '25%'),
                _GradeBreakdownItem(
                    label:
                        'Presentation',
                    score:
                        '92/100',
                    percent: 0.92,
                    weight: '50%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox
    extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color color;
  final Color bg;

  const _StatBox({
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: txtSec)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
          Text(sub, style: TextStyle(fontSize: 11, color: txtSec)),
        ],
      ),
    );
  }
}

class _GradeBreakdownItem {
  final String label;
  final String score;
  final double percent;
  final String weight;

  const _GradeBreakdownItem({
    required this.label,
    required this.score,
    required this.percent,
    required this.weight,
  });
}

class _CourseGradeCard
    extends StatefulWidget {
  final String code;
  final String credits;
  final String name;
  final String instructor;
  final double percent;
  final String grade;
  final String gradeLabel;
  final Color color;
  final List<_GradeBreakdownItem>
      items;

  const _CourseGradeCard({
    required this.code,
    required this.credits,
    required this.name,
    required this.instructor,
    required this.percent,
    required this.grade,
    required this.gradeLabel,
    required this.color,
    required this.items,
  });

  @override
  State<_CourseGradeCard>
      createState() =>
          _CourseGradeCardState();
}

class _CourseGradeCardState
    extends State<
        _CourseGradeCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final bg = isDark ? AppTheme.darkBg : AppTheme.background;
    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding:
                const EdgeInsets
                    .all(16),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration:
                      BoxDecoration(
                    color: widget
                        .color
                        .withValues(
                            alpha:
                                0.1),
                    borderRadius:
                        BorderRadius
                            .circular(
                                10),
                  ),
                  child: Icon(
                      Icons
                          .menu_book_outlined,
                      color: widget
                          .color,
                      size: 20),
                ),
                const SizedBox(
                    width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets
                                .symmetric(
                                horizontal: 8,
                                vertical: 3),
                            decoration:
                                BoxDecoration(
                              color:
                                  widget.color.withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(6),
                            ),
                            child: Text(
                                widget.code,
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: widget.color)),
                          ),
                          const SizedBox(
                              width:
                                  6),
                          Text(
                              widget
                                  .credits,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: txtSec)),
                        ],
                      ),
                      const SizedBox(
                          height:
                              4),
                      Text(widget.name,
                          style: TextStyle(
                              fontWeight: FontWeight
                                  .w600,
                              fontSize:
                                  14,
                              color:
                                  txt)),
                      Text(
                          widget
                              .instructor,
                          style: TextStyle(
                              fontSize:
                                  12,
                              color:
                                  txtSec)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .end,
                  children: [
                    Text(
                        widget
                            .grade,
                        style: TextStyle(
                            fontSize:
                                22,
                            fontWeight: FontWeight
                                .w800,
                            color:
                                widget.color)),
                    Text(
                        widget
                            .gradeLabel,
                        style: TextStyle(
                            fontSize:
                                12,
                            color: widget
                                .color,
                            fontWeight:
                                FontWeight.w500)),
                    const Row(
                      children: [
                        Icon(
                            Icons
                                .trending_up,
                            size:
                                12,
                            color:
                                AppTheme.success),
                        SizedBox(
                            width:
                                2),
                        Text(
                            'Improving',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.success)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Grade Breakdown
          GestureDetector(
            onTap: () => setState(
                () => _expanded =
                    !_expanded),
            child: Container(
              padding:
                  const EdgeInsets
                      .symmetric(
                      horizontal:
                          16,
                      vertical:
                          10),
              decoration:
                  BoxDecoration(
                color: bg,
                border: Border(
                  top: BorderSide(
                      color: border),
                  bottom: _expanded
                      ? BorderSide(
                          color: border)
                      : BorderSide
                          .none,
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Text(
                      'Grade Breakdown',
                      style: TextStyle(
                          fontSize:
                              13,
                          fontWeight:
                              FontWeight
                                  .w600,
                          color: txt)),
                  Icon(
                    _expanded
                        ? Icons
                            .keyboard_arrow_up
                        : Icons
                            .keyboard_arrow_down,
                    color: txtSec,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          if (_expanded)
            Padding(
              padding:
                  const EdgeInsets
                      .all(16),
              child: Column(
                children: widget
                    .items
                    .map((item) {
                  return Padding(
                    padding:
                        const EdgeInsets
                            .only(
                            bottom:
                                12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            Text(
                                item.label,
                                style: TextStyle(fontSize: 13, color: txt)),
                            Row(
                              children: [
                                Text(item.score, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: txt)),
                                const SizedBox(width: 8),
                                Text(item.weight, style: TextStyle(fontSize: 11, color: txtSec)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                            height:
                                6),
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                                  4),
                          child:
                              LinearProgressIndicator(
                            value:
                                item.percent,
                            backgroundColor:
                                const Color(0xFFE5E7EB),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(widget.color),
                            minHeight:
                                6,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
