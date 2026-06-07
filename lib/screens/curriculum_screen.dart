import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_theme.dart';
import 'home_screen.dart';
import '../logic/auth/auth_bloc.dart';
import '../logic/auth/auth_state.dart';
import '../logic/curriculum/curriculum_bloc.dart';
import '../logic/curriculum/curriculum_event.dart';
import '../logic/curriculum/curriculum_state.dart';
import '../data/models/curriculum_model.dart';

class CurriculumScreen extends StatefulWidget {
  const CurriculumScreen({super.key});

  @override
  State<CurriculumScreen> createState() => _CurriculumScreenState();
}

class _CurriculumScreenState extends State<CurriculumScreen> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated && authState.user.studentNumericId != null) {
      context.read<CurriculumBloc>().add(FetchCurriculum(authState.user.studentNumericId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final bg = isDark ? AppTheme.darkBg : AppTheme.background;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: card,
        leading: IconButton(
          icon: Icon(Icons.menu, color: txt),
          onPressed: HomeScreen.openDrawer,
        ),
        title: BlocBuilder<CurriculumBloc, CurriculumState>(
          builder: (context, state) {
            String programName = 'Loading...';
            if (state is CurriculumLoaded) {
              programName = state.curriculum.program ?? 'General Program';
            }
            return Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkCard : AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.menu_book_outlined,
                      color: AppTheme.primary, size: 18),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Curriculum Management',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: txt,
                        ),
                      ),
                      Text(
                        programName,
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? AppTheme.darkTextSec : AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: BlocBuilder<CurriculumBloc, CurriculumState>(
        builder: (context, state) {
          if (state is CurriculumInitial || state is CurriculumLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CurriculumError) {
            return Center(
                child: Text('Error: ${state.message}',
                    style: TextStyle(color: txt)));
          }

          final curriculum = (state as CurriculumLoaded).curriculum;
          
          // Calculate Progress
          int totalCredits = 0;
          int completedCredits = 0;
          for (var courseCode in curriculum.courses.keys) {
            int credits = curriculum.courses[courseCode]?.credits ?? 0;
            totalCredits += credits;
            if (curriculum.statuses[courseCode] == 'done') {
              completedCredits += credits;
            }
          }
          double progress = totalCredits > 0 ? (completedCredits / totalCredits) : 0.0;
          int remainingCredits = totalCredits - completedCredits;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: card,
                    border: Border.all(
                        color: isDark ? AppTheme.darkBorder : AppTheme.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Overall Progress',
                          style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: txt,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: isDark
                              ? AppTheme.darkBorder
                              : const Color(0xFFE5E7EB),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _MiniStatCard(
                        label: 'Credits Completed',
                        value: '$completedCredits',
                        sub: 'of $totalCredits required',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MiniStatCard(
                        label: 'Remaining',
                        value: '$remainingCredits',
                        sub: 'credits to graduate',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Years
                ...curriculum.schedule.map((year) => _YearSection(
                      yearData: year,
                      curriculum: curriculum,
                    )),

                const SizedBox(height: 16),
                // Legend
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: card,
                    border: Border.all(
                        color: isDark ? AppTheme.darkBorder : AppTheme.border),
                  ),
                  child: const Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      _LegendItem(
                          icon: Icons.check_circle_outline,
                          color: AppTheme.success,
                          label: 'Completed'),
                      _LegendItem(
                          icon: Icons.access_time_outlined,
                          color: AppTheme.info,
                          label: 'In Progress'),
                      _LegendItem(
                          icon: Icons.star_outline,
                          color: AppTheme.warning,
                          label: 'Planned'),
                      _LegendItem(
                          icon: Icons.lock_outline,
                          color: AppTheme.textLight,
                          label: 'Locked'),
                      _LegendItem(
                          icon: Icons.cancel_outlined,
                          color: AppTheme.error,
                          label: 'Failed'),
                      _LegendItem(
                          icon: Icons.remove_circle_outline,
                          color: Colors.grey,
                          label: 'Dropped'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;

  const _MiniStatCard(
      {required this.label, required this.value, required this.sub});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800, color: txt)),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10,
                  color: txtSec,
                  fontWeight: FontWeight.w500)),
          Text(sub,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 9, color: txtSec)),
        ],
      ),
    );
  }
}

class _YearSection extends StatelessWidget {
  final CurriculumYear yearData;
  final CurriculumModel curriculum;

  const _YearSection({required this.yearData, required this.curriculum});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final cardBg = isDark ? AppTheme.darkCard : Colors.white;
    final brd = isDark ? AppTheme.darkBorder : AppTheme.border;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(yearData.label,
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700, color: txt)),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: yearData.sems.map((sem) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: yearData.sems.indexOf(sem) == 0 ? 6 : 0,
                  left: yearData.sems.indexOf(sem) == 1 ? 6 : 0,
                  bottom: 16,
                ),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: brd),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sem.label,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: txt)),
                    const SizedBox(height: 10),
                    ...sem.courses.map((code) => _CourseRow(
                          courseCode: code,
                          curriculum: curriculum,
                        )),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CourseRow extends StatelessWidget {
  final String courseCode;
  final CurriculumModel curriculum;

  const _CourseRow({required this.courseCode, required this.curriculum});

  bool _isLocked() {
    final prereqs = curriculum.courses[courseCode]?.prereqs ?? [];
    for (var pre in prereqs) {
      if (curriculum.statuses[pre] != 'done') {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    final courseData = curriculum.courses[courseCode];
    if (courseData == null) return const SizedBox.shrink();

    final status = curriculum.statuses[courseCode];
    final isLocked = status == null && _isLocked();

    IconData icon;
    Color color;
    Widget? trailing;

    if (status == 'done') {
      icon = Icons.check_circle_outline;
      color = AppTheme.success;
      trailing = const SizedBox();
    } else if (status == 'prog') {
      icon = Icons.access_time_outlined;
      color = AppTheme.info;
      trailing = _badge('In Progress', AppTheme.info,
          isDark ? AppTheme.darkCard : const Color(0xFFEFF6FF));
    } else if (status == 'failed') {
      icon = Icons.cancel_outlined;
      color = AppTheme.error;
      trailing = _badge('Failed', AppTheme.error,
          isDark ? AppTheme.darkCard : const Color(0xFFFEF2F2));
    } else if (status == 'dropped') {
      icon = Icons.remove_circle_outline;
      color = Colors.grey;
      trailing = _badge('Dropped', Colors.grey,
          isDark ? AppTheme.darkCard : const Color(0xFFF3F4F6));
    } else if (isLocked) {
      icon = Icons.lock_outline;
      color = AppTheme.textLight;
      trailing = _badge('Locked', AppTheme.textLight,
          isDark ? AppTheme.darkCard : const Color(0xFFF3F4F6));
    } else {
      icon = Icons.star_outline;
      color = AppTheme.warning;
      trailing = _badge('Planned', AppTheme.warning,
          isDark ? AppTheme.darkCard : const Color(0xFFFFFBEB));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseCode,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: txt,
                  ),
                ),
                Text(
                  courseData.name,
                  style: TextStyle(
                    fontSize: 9,
                    color: txtSec,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _badge(String label, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _LegendItem({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: txtSec,
          ),
        ),
      ],
    );
  }
}
