import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_theme.dart';
import '../logic/auth/auth_bloc.dart';
import '../logic/auth/auth_state.dart';
import '../logic/grade/grade_bloc.dart';
import '../logic/grade/grade_event.dart';
import '../logic/grade/grade_state.dart';
import '../data/models/grade_model.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  SemesterGrade? _selectedSemester;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      if (user.studentNumericId != null) {
        context.read<GradeBloc>().add(LoadTranscript(user.studentNumericId!));
      }
    }
  }

  void _showSemesterPicker(List<SemesterGrade> semesters) {
    if (semesters.isEmpty) return;

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
                ...semesters.map((s) {
                  final isSelected = s.semesterId == (_selectedSemester?.semesterId ?? semesters.last.semesterId);
                  return ListTile(
                    title: Text(s.semesterName,
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
          BlocBuilder<GradeBloc, GradeState>(
            builder: (context, state) {
              if (state is GradeLoaded) {
                final semesters = state.transcript.semesters;
                if (semesters.isNotEmpty) {
                  final currentSem = _selectedSemester ?? semesters.last;
                  return GestureDetector(
                    onTap: () => _showSemesterPicker(semesters),
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
                          Text(currentSem.semesterName,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: txt)),
                          const SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down, size: 16, color: txtSec),
                        ],
                      ),
                    ),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<GradeBloc, GradeState>(
        builder: (context, state) {
          if (state is GradeInitial || state is GradeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GradeError) {
            return Center(
              child: Text(
                'Failed to load grades: ${state.message}',
                style: TextStyle(color: txt),
              ),
            );
          }

          if (state is GradeLoaded) {
            final transcript = state.transcript;
            final semesters = transcript.semesters;
            
            if (semesters.isEmpty) {
              return Center(
                child: Text('No grades available yet.',
                    style: TextStyle(color: txtSec)),
              );
            }

            final currentSem = _selectedSemester ?? semesters.last;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: _StatBox(
                              label: 'Overall CGPA',
                              value: transcript.cgpa.toStringAsFixed(2),
                              sub: 'Out of 4.0',
                              color: AppTheme.primary,
                              isDark: isDark,
                              border: border)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _StatBox(
                              label: 'Semester GPA',
                              value: currentSem.gpa.toStringAsFixed(2),
                              sub: 'Out of 4.0',
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
                              value: '${transcript.totalCredits}',
                              sub: 'Earned so far',
                              color: AppTheme.blue,
                              isDark: isDark,
                              border: border)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _StatBox(
                              label: 'Sem Courses',
                              value: '${currentSem.courses.length}',
                              sub: 'Attempted',
                              color: AppTheme.orange,
                              isDark: isDark,
                              border: border)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ...currentSem.courses.map((course) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _CourseGradeCard(
                        code: course.courseCode,
                        credits: '${course.creditHours} credits',
                        name: course.courseTitle,
                        percent: course.totalScore / 100,
                        grade: course.totalScore.toStringAsFixed(1),
                        gradeLabel: 'Grade: ${course.letterGrade}',
                        color: _getColorForGrade(course.letterGrade),
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Color _getColorForGrade(String grade) {
    if (grade.startsWith('A')) return const Color(0xFF2979FF);
    if (grade.startsWith('B')) return const Color(0xFF00C853);
    if (grade.startsWith('C')) return const Color(0xFFFF9100);
    if (grade.startsWith('D')) return const Color(0xFFFF3D00);
    return const Color(0xFFD50000); // F or other
  }
}

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

class _CourseGradeCard extends StatelessWidget {
  final String code;
  final String credits;
  final String name;
  final double percent;
  final String grade;
  final String gradeLabel;
  final Color color;

  const _CourseGradeCard({
    required this.code,
    required this.credits,
    required this.name,
    required this.percent,
    required this.grade,
    required this.gradeLabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.menu_book_outlined,
                  color: color, size: 20),
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
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(code,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: color)),
                      ),
                      const SizedBox(width: 6),
                      Text(credits,
                          style:
                              TextStyle(fontSize: 11, color: txtSec)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(name,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: txt)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(grade,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: color)),
                Text(gradeLabel,
                    style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
