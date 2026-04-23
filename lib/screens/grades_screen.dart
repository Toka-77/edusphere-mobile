import 'package:flutter/material.dart';
import '../app_theme.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  // ── Semester selector ──────────────────────────────────────────────
  final List<String> _semesters = [
    'Fall 2024',
    'Summer 2024',
    'Spring 2024',
    'Fall 2023',
    'Spring 2023',
  ];
  String _selectedSemester = 'Fall 2024';

  void _showSemesterPicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;

    showModalBottomSheet(
      context: context,
      backgroundColor: card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    children: [
                      Text('Select Semester',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: txt)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ..._semesters.map((s) {
                  final isSelected = s == _selectedSemester;
                  return ListTile(
                    title: Text(s,
                        style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? AppTheme.primary : txt,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.normal)),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle,
                        color: AppTheme.primary, size: 20)
                        : Icon(Icons.radio_button_unchecked,
                        color: txtSec, size: 20),
                    onTap: () {
                      setState(() => _selectedSemester = s);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

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
            Text('My Grades',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: txt)),
            Text('Track your academic performance',
                style: TextStyle(fontSize: 11, color: txtSec)),
          ],
        ),
        actions: [
          // ── Clickable semester selector ──────────────────────────
          GestureDetector(
            onTap: _showSemesterPicker,
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: border),
              ),
              child: Row(
                children: [
                  Text(_selectedSemester,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: txt)),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 16, color: txtSec),
                ],
              ),
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
                Expanded(
                    child: _StatBox(
                        label: 'Overall GPA',
                        value: '3.61',
                        sub: 'Out of 4.0',
                        color: AppTheme.primary,
                        isDark: isDark,
                        border: border)),
                const SizedBox(width: 10),
                Expanded(
                    child: _StatBox(
                        label: 'Avg Score',
                        value: '90.4%',
                        sub: '↑ +2.5% from last sem',
                        color: AppTheme.success,
                        isDark: isDark,
                        border: border)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: _StatBox(
                        label: 'Total Credits',
                        value: '16',
                        sub: 'This semester',
                        color: AppTheme.blue,
                        isDark: isDark,
                        border: border)),
                const SizedBox(width: 10),
                Expanded(
                    child: _StatBox(
                        label: 'Courses',
                        value: '5',
                        sub: 'Currently enrolled',
                        color: AppTheme.orange,
                        isDark: isDark,
                        border: border)),
              ],
            ),
            const SizedBox(height: 20),

            _CourseGradeCard(
              code: 'CS431',
              credits: '4 credits',
              name: 'Advanced Web Development',
              instructor: 'Dr. Sarah Johnson',
              percent: 0.95,
              grade: '95%',
              gradeLabel: 'Grade: A',
              color: const Color(0xFF2979FF),
              items: [
                _GradeBreakdownItem(
                    label: 'Project 1',
                    score: '90/100',
                    percent: 0.90,
                    weight: '25%'),
                _GradeBreakdownItem(
                    label: 'Project 2',
                    score: '86/100',
                    percent: 0.86,
                    weight: '25%'),
                _GradeBreakdownItem(
                    label: 'Midterm Exam',
                    score: '82/100',
                    percent: 0.82,
                    weight: '25%'),
                _GradeBreakdownItem(
                    label: 'Final Project',
                    score: '95/100',
                    percent: 0.95,
                    weight: '25%'),
              ],
            ),
            const SizedBox(height: 16),

            _CourseGradeCard(
              code: 'MATH301',
              credits: '4 credits',
              name: 'Advanced Mathematics',
              instructor: 'Prof. Michael Chen',
              percent: 0.88,
              grade: '88%',
              gradeLabel: 'Grade: B+',
              color: const Color(0xFFFF6D00),
              items: [
                _GradeBreakdownItem(
                    label: 'Problem Set 1',
                    score: '82/100',
                    percent: 0.82,
                    weight: '25%'),
                _GradeBreakdownItem(
                    label: 'Problem Set 2',
                    score: '86/100',
                    percent: 0.86,
                    weight: '25%'),
                _GradeBreakdownItem(
                    label: 'Midterm Exam',
                    score: '88/100',
                    percent: 0.88,
                    weight: '25%'),
                _GradeBreakdownItem(
                    label: 'Final Quiz',
                    score: '87/100',
                    percent: 0.87,
                    weight: '25%'),
              ],
            ),
            const SizedBox(height: 16),

            _CourseGradeCard(
              code: 'CS302',
              credits: '4 credits',
              name: 'Machine Learning',
              instructor: 'Dr. James Wilson',
              percent: 0.92,
              grade: '92%',
              gradeLabel: 'Grade: A',
              color: const Color(0xFF9C27B0),
              items: [
                _GradeBreakdownItem(
                    label: 'Assignment 1',
                    score: '88/100',
                    percent: 0.88,
                    weight: '25%'),
                _GradeBreakdownItem(
                    label: 'Assignment 2',
                    score: '89/100',
                    percent: 0.89,
                    weight: '25%'),
                _GradeBreakdownItem(
                    label: 'Project',
                    score: '92/100',
                    percent: 0.92,
                    weight: '25%'),
                _GradeBreakdownItem(
                    label: 'Final Exam',
                    score: '95/100',
                    percent: 0.95,
                    weight: '25%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stat box ──────────────────────────────────────────────────────────
class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color color;
  final Color? bg;
  final bool isDark;
  final Color? border;

  const _StatBox({
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
    this.bg,
    this.isDark = false,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final actualIsDark = Theme.of(context).brightness == Brightness.dark;
    final borderC = actualIsDark ? AppTheme.darkBorder : AppTheme.border;
    final txtSec =
    actualIsDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final bgColor = actualIsDark
        ? color.withValues(alpha: 0.12)
        : (bg ?? color.withValues(alpha: 0.08));
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border ?? borderC),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: txtSec)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: color)),
          Text(sub, style: TextStyle(fontSize: 11, color: txtSec)),
        ],
      ),
    );
  }
}

// ── Grade breakdown item data ──────────────────────────────────────────
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

// ── Course grade card ──────────────────────────────────────────────────
class _CourseGradeCard extends StatefulWidget {
  final String code;
  final String credits;
  final String name;
  final String instructor;
  final double percent;
  final String grade;
  final String gradeLabel;
  final Color color;
  final List<_GradeBreakdownItem> items;

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
  State<_CourseGradeCard> createState() => _CourseGradeCardState();
}

class _CourseGradeCardState extends State<_CourseGradeCard> {
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
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.menu_book_outlined,
                      color: widget.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: widget.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(widget.code,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: widget.color)),
                          ),
                          const SizedBox(width: 6),
                          Text(widget.credits,
                              style:
                              TextStyle(fontSize: 11, color: txtSec)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(widget.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: txt)),
                      Text(widget.instructor,
                          style: TextStyle(fontSize: 12, color: txtSec)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(widget.grade,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: widget.color)),
                    Text(widget.gradeLabel,
                        style: TextStyle(
                            fontSize: 12,
                            color: widget.color,
                            fontWeight: FontWeight.w500)),
                    Row(
                      children: [
                        const Icon(Icons.trending_up,
                            size: 12, color: AppTheme.success),
                        const SizedBox(width: 2),
                        Text('Improving',
                            style: const TextStyle(
                                fontSize: 11, color: AppTheme.success)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Grade Breakdown toggle
          GestureDetector(
            onTap: () =>
                setState(() => _expanded = !_expanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: bg,
                border: Border(
                  top: BorderSide(color: border),
                  bottom: _expanded
                      ? BorderSide(color: border)
                      : BorderSide.none,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Grade Breakdown',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: txt)),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: txtSec,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          if (_expanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: widget.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.label,
                                style:
                                TextStyle(fontSize: 13, color: txt)),
                            Row(
                              children: [
                                Text(item.score,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: txt)),
                                const SizedBox(width: 8),
                                Text(item.weight,
                                    style: TextStyle(
                                        fontSize: 11, color: txtSec)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: item.percent,
                            backgroundColor: const Color(0xFFE5E7EB),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                widget.color),
                            minHeight: 6,
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
