import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../widgets/stat_card.dart';
import 'home_screen.dart';

class CurriculumScreen
    extends StatelessWidget {
  const CurriculumScreen(
      {super.key});

  @override
  Widget build(
      BuildContext context) {
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
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration:
                  BoxDecoration(
               color: isDark ? AppTheme.darkCard : AppTheme.primaryLight,
                borderRadius:
                    BorderRadius
                        .circular(
                            10),
              ),
              child: const Icon(
                  Icons
                      .menu_book_outlined,
                  color: AppTheme
                      .primary,
                  size: 18),
            ),
            const SizedBox(
                width: 10),
          Column(
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
                'Bachelor of Science in Computer Science',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AppTheme.darkTextSec : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(
                16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            // Stats
            Container(
              padding:
                  const EdgeInsets
                      .all(16),
              decoration:
                  BoxDecoration(
                color: card,
border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  const Text(
                      'Overall Progress',
                      style: TextStyle(
                          fontSize:
                              13,
                          color: AppTheme
                              .primary,
                          fontWeight:
                              FontWeight
                                  .w600)),
                  const SizedBox(
                      height: 4),
              Text(
  '63%',
  style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: txt,
  ),
),
                  const SizedBox(
                      height: 8),
                  ClipRRect(
                    borderRadius:
                        BorderRadius
                            .circular(
                                4),
                    child:
                        LinearProgressIndicator(
                      value: 0.63,
                          backgroundColor: isDark 
    ? AppTheme.darkBorder 
    : const Color(0xFFE5E7EB),
                      valueColor: AlwaysStoppedAnimation<
                              Color>(
                          AppTheme
                              .primary),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 12),
            const Row(
              children: [
                Expanded(
                  child:
                      _MiniStatCard(
                    label:
                        'Credits Completed',
                    value: '75',
                    sub:
                        'of 120 required',
                  ),
                ),
                SizedBox(
                    width: 12),
                Expanded(
                  child:
                      _MiniStatCard(
                    label:
                        'Current GPA',
                    value: '3.8',
                    sub:
                        'Required: 2.5',
                  ),
                ),
                SizedBox(
                    width: 12),
                Expanded(
                  child:
                      _MiniStatCard(
                    label:
                        'Remaining',
                    value: '45',
                    sub:
                        'credits to graduate',
                  ),
                ),
              ],
            ),
            const SizedBox(
                height: 20),

            // Years
            const _YearSection(
              year: 'First Year',
              semesters: [
                _SemesterData(
                  title:
                      'Fall 2021',
                  courses: [
                    _CourseData(
                        'CS101',
                        'Introduction to Programming',
                        3,
                        'A',
                        CourseStatus
                            .completed),
                    _CourseData(
                        'MATH101',
                        'Calculus I',
                        4,
                        'A-',
                        CourseStatus
                            .completed),
                    _CourseData(
                        'ENG101',
                        'English Composition',
                        3,
                        'B+',
                        CourseStatus
                            .completed),
                    _CourseData(
                        'PHY101',
                        'Physics I',
                        4,
                        'A',
                        CourseStatus
                            .completed),
                  ],
                ),
                _SemesterData(
                  title:
                      'Spring 2022',
                  courses: [
                    _CourseData(
                        'CS102',
                        'Data Structures',
                        3,
                        'A',
                        CourseStatus
                            .completed),
                    _CourseData(
                        'MATH102',
                        'Calculus II',
                        4,
                        'B+',
                        CourseStatus
                            .completed),
                    _CourseData(
                        'ENG102',
                        'Technical Writing',
                        3,
                        'A-',
                        CourseStatus
                            .completed),
                    _CourseData(
                        'PHY102',
                        'Physics II',
                        4,
                        'B+',
                        CourseStatus
                            .completed),
                  ],
                ),
              ],
            ),
            const _YearSection(
              year: 'Second Year',
              semesters: [
                _SemesterData(
                  title:
                      'Fall 2022',
                  courses: [
                    _CourseData(
                        'CS201',
                        'Algorithms',
                        3,
                        'A',
                        CourseStatus
                            .completed),
                    _CourseData(
                        'CS202',
                        'Computer Architecture',
                        3,
                        'A-',
                        CourseStatus
                            .completed),
                    _CourseData(
                        'MATH201',
                        'Linear Algebra',
                        3,
                        'B+',
                        CourseStatus
                            .completed),
                    _CourseData(
                        'STAT201',
                        'Statistics',
                        3,
                        'A',
                        CourseStatus
                            .completed),
                  ],
                ),
                _SemesterData(
                  title:
                      'Spring 2023',
                  courses: [
                    _CourseData(
                        'CS203',
                        'Operating Systems',
                        3,
                        'A',
                        CourseStatus
                            .completed),
                    _CourseData(
                        'CS204',
                        'Database Systems',
                        3,
                        'A-',
                        CourseStatus
                            .completed),
                    _CourseData(
                        'MATH202',
                        'Discrete Mathematics',
                        3,
                        'A',
                        CourseStatus
                            .completed),
                    _CourseData(
                        'HUM201',
                        'Humanities Elective',
                        3,
                        'B+',
                        CourseStatus
                            .completed),
                  ],
                ),
              ],
            ),
            const _YearSection(
              year: 'Third Year',
              semesters: [
                _SemesterData(
                  title:
                      'Fall 2023',
                  courses: [
                    _CourseData(
                        'CS301',
                        'Software Engineering',
                        3,
                        'A',
                        CourseStatus
                            .completed),
                    _CourseData(
                        'CS302',
                        'Computer Networks',
                        3,
                        'A-',
                        CourseStatus
                            .completed),
                    _CourseData(
                        'CS303',
                        'Artificial Intelligence',
                        3,
                        'A',
                        CourseStatus
                            .completed),
                    _CourseData(
                        'HUM301',
                        'Humanities Elective',
                        3,
                        'B+',
                        CourseStatus
                            .completed),
                  ],
                ),
                _SemesterData(
                  title:
                      'Spring 2024',
                  courses: [
                    _CourseData(
                        'CS401',
                        'Advanced Web Development',
                        3,
                        '',
                        CourseStatus
                            .inProgress),
                    _CourseData(
                        'CS501',
                        'Machine Learning',
                        3,
                        '',
                        CourseStatus
                            .inProgress),
                    _CourseData(
                        'MATH301',
                        'Advanced Mathematics',
                        4,
                        '',
                        CourseStatus
                            .inProgress),
                    _CourseData(
                        'ENG201',
                        'Technical Communication',
                        3,
                        '',
                        CourseStatus
                            .inProgress),
                  ],
                ),
              ],
            ),
            const _YearSection(
              year: 'Fourth Year',
              semesters: [
                _SemesterData(
                  title:
                      'Fall 2024',
                  courses: [
                    _CourseData(
                        'CS402',
                        'Database Advanced Topics',
                        3,
                        '',
                        CourseStatus
                            .planned),
                    _CourseData(
                        'CS403',
                        'Cybersecurity',
                        3,
                        '',
                        CourseStatus
                            .planned),
                    _CourseData(
                        'CS404',
                        'Cloud Computing',
                        3,
                        '',
                        CourseStatus
                            .planned),
                    _CourseData(
                        'CS499',
                        'Senior Project I',
                        3,
                        '',
                        CourseStatus
                            .planned),
                  ],
                ),
                _SemesterData(
                  title:
                      'Spring 2025',
                  courses: [
                    _CourseData(
                        'CS405',
                        'Mobile Development',
                        3,
                        '',
                        CourseStatus
                            .locked),
                    _CourseData(
                        'CS406',
                        'Data Science',
                        3,
                        '',
                        CourseStatus
                            .locked),
                    _CourseData(
                        'CS499B',
                        'Senior Project II',
                        3,
                        '',
                        CourseStatus
                            .locked),
                    _CourseData(
                        'ELEC401',
                        'Technical Elective',
                        3,
                        '',
                        CourseStatus
                            .locked),
                  ],
                ),
              ],
            ),
            const SizedBox(
                height: 16),
            // Legend
            Container(
              padding:
                  const EdgeInsets
                      .all(16),
              decoration:
                  BoxDecoration(
                color: card,
border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.border),
              ),
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceAround,
                children: [
                  _LegendItem(
                      icon: Icons
                          .check_circle_outline,
                      color: AppTheme
                          .success,
                      label:
                          'Completed'),
                  _LegendItem(
                      icon: Icons
                          .access_time_outlined,
                      color:
                          AppTheme
                              .info,
                      label:
                          'In Progress'),
                  _LegendItem(
                      icon: Icons
                          .star_outline,
                      color: AppTheme
                          .warning,
                      label:
                          'Planned'),
                  _LegendItem(
                      icon: Icons
                          .lock_outline,
                      color: AppTheme
                          .textLight,
                      label:
                          'Locked'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStatCard
    extends StatelessWidget {
  final String label;
  final String value;
  final String sub;

  const _MiniStatCard({required this.label,
    required this.value,
    required this.sub});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
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
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: txt)),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10,
                  color: txtSec,
                  fontWeight: FontWeight.w500)),
          Text(sub,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 9,
                  color: txtSec)),
        ],
      ),
    );
  }
}
enum CourseStatus {
  completed,
  inProgress,
  planned,
  locked
}

class _CourseData {
  final String code;
  final String name;
  final int credits;
  final String grade;
  final CourseStatus status;

  const _CourseData(
      this.code,
      this.name,
      this.credits,
      this.grade,
      this.status);
}

class _SemesterData {
  final String title;
  final List<_CourseData> courses;

  const _SemesterData(
      {required this.title,
      required this.courses});
}

class _YearSection
    extends StatelessWidget {
  final String year;
  final List<_SemesterData>
      semesters;

  const _YearSection(
      {required this.year,
      required this.semesters});

  @override
  Widget build(
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final cardBg = isDark ? AppTheme.darkCard : Colors.white;
    final brd = isDark ? AppTheme.darkBorder : AppTheme.border;
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets
              .only(bottom: 12),
          child: Text(year,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight
                          .w700,
                  color: txt)),
        ),
        Row(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children:
              semesters.map((sem) {
            return Expanded(
              child: Container(
                margin: EdgeInsets
                    .only(
                  right: semesters.indexOf(
                              sem) ==
                          0
                      ? 6
                      : 0,
                  left: semesters.indexOf(
                              sem) ==
                          1
                      ? 6
                      : 0,
                  bottom: 16,
                ),
                padding:
                    const EdgeInsets
                        .all(14),
                decoration:
                    BoxDecoration(
                  color: cardBg,
                  borderRadius:
                      BorderRadius
                          .circular(
                              14),
                  border: Border.all(
                      color: brd),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(sem.title,
                        style: TextStyle(
                            fontWeight: FontWeight
                                .w600,
                            fontSize:
                                13,
                            color: txt)),
                    const SizedBox(
                        height:
                            10),
                    ...sem.courses.map((c) =>
                        _CourseRow(
                            course:
                                c)),
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

// 🔴 أهم تعديل كان في _CourseRow و Legend

class _CourseRow extends StatelessWidget {
  final _CourseData course;

  const _CourseRow({required this.course});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    IconData icon;
    Color color;
    Widget? trailing;

    switch (course.status) {
      case CourseStatus.completed:
        icon = Icons.check_circle_outline;
        color = AppTheme.success;
        trailing = Text(
          course.grade,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: txt,
          ),
        );
        break;

      case CourseStatus.inProgress:
        icon = Icons.access_time_outlined;
        color = AppTheme.info;
        trailing = Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCard : const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'In Progress',
            style: TextStyle(
              fontSize: 9,
              color: AppTheme.info,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
        break;

      case CourseStatus.planned:
        icon = Icons.star_outline;
        color = AppTheme.warning;
        trailing = Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCard : const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Planned',
            style: TextStyle(
              fontSize: 9,
              color: AppTheme.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
        break;

      case CourseStatus.locked:
        icon = Icons.lock_outline;
        color = AppTheme.textLight;
        trailing = Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCard : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Locked',
            style: TextStyle(
              fontSize: 9,
              color: AppTheme.textLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
        break;
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
                  course.code,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: txt,
                  ),
                ),
                Text(
                  course.name,
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
          trailing!,
        ],
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
    final txtSec =
        isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

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
