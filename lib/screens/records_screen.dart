import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_theme.dart';
import 'home_screen.dart';
import '../logic/auth/auth_bloc.dart';
import '../logic/auth/auth_state.dart';
import '../logic/grade/grade_bloc.dart';
import '../logic/grade/grade_state.dart';
import '../logic/grade/grade_event.dart';
import '../data/models/grade_model.dart';
import '../data/models/user_model.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch LoadTranscript when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated && authState.user.studentNumericId != null) {
        context.read<GradeBloc>().add(LoadTranscript(authState.user.studentNumericId!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final bg = isDark ? AppTheme.darkBg : AppTheme.background;
    final brd = isDark ? AppTheme.darkBorder : AppTheme.border;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: card,
        leading: IconButton(
          icon: Icon(Icons.menu, color: txt),
          onPressed: HomeScreen.openDrawer,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Records & Enrollment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: txt)),
            Text('Your official academic record and status',
                style: TextStyle(fontSize: 11, color: txtSec)),
          ],
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final user = (authState is AuthAuthenticated) ? authState.user : null;
          
          return BlocBuilder<GradeBloc, GradeState>(
            builder: (context, gradeState) {
              if (gradeState is GradeLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (gradeState is GradeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: AppTheme.error, size: 48),
                      const SizedBox(height: 16),
                      Text('Failed to load records', style: TextStyle(color: txt, fontSize: 16)),
                      Text(gradeState.message, style: TextStyle(color: txtSec, fontSize: 13)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (user?.studentNumericId != null) {
                            context.read<GradeBloc>().add(LoadTranscript(user!.studentNumericId!));
                          }
                        },
                        child: const Text('Retry'),
                      )
                    ],
                  ),
                );
              }

              TranscriptModel? transcript;
              if (gradeState is GradeLoaded) {
                transcript = gradeState.transcript;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // ── Student ID Card ────────────────────────────────────
                    _buildStudentCard(user, transcript, txt, txtSec, card, brd),
                    const SizedBox(height: 20),

                    // ── Current Semester Enrollment ────────────────────────
                    if (transcript != null && transcript.semesters.isNotEmpty)
                      _buildCurrentEnrollment(transcript.semesters.last, txt, txtSec, card, brd),
                    if (transcript != null && transcript.semesters.isNotEmpty)
                      const SizedBox(height: 20),

                    // ── Semester Transcript ────────────────────────────────
                    if (transcript != null)
                      _TranscriptTable(
                        transcript: transcript,
                        brd: brd,
                        card: card,
                        txt: txt,
                        txtSec: txtSec,
                      ),
                    const SizedBox(height: 20),

                    // ── Academic Milestones ────────────────────────────────
                    _buildMilestones(user, transcript, txt, txtSec, card, brd),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStudentCard(UserModel? user, TranscriptModel? transcript, Color txt, Color txtSec, Color card, Color brd) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: brd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 12),
          Text(user?.name.toUpperCase() ?? 'UNKNOWN STUDENT',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: txt), textAlign: TextAlign.center),
          Text('ID: ${user?.studentCode ?? '-'}',
              style: TextStyle(fontSize: 13, color: txtSec, fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          _InfoTile(icon: Icons.school_outlined, label: 'Faculty', value: 'Business Technology'), // Static for now
          const SizedBox(height: 8),
          _InfoTile(icon: Icons.menu_book_outlined, label: 'Program', value: user?.program ?? 'N/A'),
          const SizedBox(height: 8),
          _InfoTile(icon: Icons.calendar_today_outlined, label: 'Level', value: 'Level ${user?.level ?? 1}'),
          const SizedBox(height: 8),
          _InfoTile(icon: Icons.grade_outlined, label: 'CGPA', value: '${transcript?.cgpa.toStringAsFixed(2) ?? '0.00'} / 4.0'),
          const SizedBox(height: 8),
          _InfoTile(icon: Icons.credit_card_outlined, label: 'Credits', value: '${transcript?.totalCredits ?? 0} / 120'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.check_circle, color: AppTheme.success, size: 18),
                  const SizedBox(width: 8),
                  Text('Active Enrollment',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: txt)),
                ]),
                const Text('ACTIVE',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.success)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentEnrollment(SemesterGrade currentSem, Color txt, Color txtSec, Color card, Color brd) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: brd),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book_outlined, color: AppTheme.primary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Current Enrollment (${currentSem.semesterName})',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: txt)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (currentSem.courses.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('No courses found for this semester.', style: TextStyle(color: txtSec)),
            ),
          ...currentSem.courses.map((course) {
            return Column(
              children: [
                _EnrollRow(
                  course: course.courseTitle,
                  code: course.courseCode,
                  credits: course.creditHours.toString(),
                  type: 'COURSE', // Model doesn't have type
                  typeColor: AppTheme.info,
                  status: course.status,
                ),
                if (course != currentSem.courses.last) Divider(height: 16, color: brd),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMilestones(UserModel? user, TranscriptModel? transcript, Color txt, Color txtSec, Color card, Color brd) {
    int credits = transcript?.totalCredits ?? 0;
    
    // Simple mock logic for milestones based on credits
    String getStatus(int requiredCredits) {
      if (credits >= requiredCredits) return 'COMPLETED';
      if (credits >= requiredCredits - 30) return 'IN PROGRESS';
      return 'PENDING';
    }
    
    Color getStatusColor(String status) {
      if (status == 'COMPLETED') return AppTheme.success;
      if (status == 'IN PROGRESS') return AppTheme.info;
      return AppTheme.textLight;
    }
    
    Color getBorderColor(String status) {
      if (status == 'COMPLETED') return AppTheme.success;
      if (status == 'IN PROGRESS') return AppTheme.info;
      return AppTheme.border;
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: brd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.description_outlined, color: AppTheme.textSecondary, size: 18),
            const SizedBox(width: 8),
            Text('Academic Milestones',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: txt)),
          ]),
          const SizedBox(height: 14),

          Row(children: [
            Expanded(
              child: _MilestoneCard(
                title: 'Freshman Year',
                date: '30 Credits',
                status: getStatus(30),
                statusColor: getStatusColor(getStatus(30)),
                borderColor: getBorderColor(getStatus(30)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MilestoneCard(
                title: 'Sophomore Year',
                date: '60 Credits',
                status: getStatus(60),
                statusColor: getStatusColor(getStatus(60)),
                borderColor: getBorderColor(getStatus(60)),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: _MilestoneCard(
                title: 'Junior Year',
                date: '90 Credits',
                status: getStatus(90),
                statusColor: getStatusColor(getStatus(90)),
                borderColor: getBorderColor(getStatus(90)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MilestoneCard(
                title: 'Senior Year',
                date: '120 Credits',
                status: getStatus(120),
                statusColor: getStatusColor(getStatus(120)),
                borderColor: getBorderColor(getStatus(120)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _TranscriptTable extends StatelessWidget {
  final TranscriptModel transcript;
  final Color brd, card, txt, txtSec;
  const _TranscriptTable({
    required this.transcript,
    required this.brd,
    required this.card,
    required this.txt,
    required this.txtSec,
  });

  @override
  Widget build(BuildContext context) {
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
            ]),
          ),
          if (transcript.semesters.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('No transcript records available.', style: TextStyle(color: txtSec)),
            ),
          ...transcript.semesters.map((sem) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: brd.withValues(alpha: 0.5))),
            ),
            child: Row(children: [
              Expanded(flex: 2, child: Text(sem.semesterName, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: txt))),
              Expanded(child: Text(sem.gpa.toStringAsFixed(2), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.success))),
              Expanded(child: Text('${sem.totalCredits} cr', style: TextStyle(fontSize: 13, color: txtSec))),
            ]),
          )),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final tileBg = isDark ? AppTheme.darkBg2 : AppTheme.background;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: tileBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        Icon(icon, size: 16, color: AppTheme.primary),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 10, color: txtSec, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: txt)),
        ]),
      ]),
    );
  }
}

class _EnrollRow extends StatelessWidget {
  final String course, code, credits, type, status;
  final Color typeColor;
  const _EnrollRow(
      {required this.course,
      required this.code,
      required this.credits,
      required this.type,
      required this.typeColor,
      required this.status});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    return Row(children: [
      Expanded(
        flex: 3,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(course, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: txt)),
          Text(code, style: TextStyle(fontSize: 11, color: txtSec)),
        ]),
      ),
      Text(credits, style: TextStyle(fontSize: 13, color: txtSec)),
      const SizedBox(width: 10),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: typeColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(type, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: typeColor)),
      ),
      const SizedBox(width: 10),
      Row(children: [
        Icon(status.toLowerCase() == 'completed' ? Icons.check_circle : Icons.circle,
            size: 12,
            color: status.toLowerCase() == 'completed' ? AppTheme.success : AppTheme.info),
        const SizedBox(width: 4),
        Text(status,
            style: TextStyle(
                fontSize: 12,
                color: status.toLowerCase() == 'completed' ? AppTheme.success : AppTheme.info,
                fontWeight: FontWeight.w500)),
      ]),
    ]);
  }
}

class _MilestoneCard extends StatelessWidget {
  final String title, date, status;
  final Color statusColor, borderColor;
  const _MilestoneCard(
      {required this.title,
      required this.date,
      required this.status,
      required this.statusColor,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final cardBg = isDark ? AppTheme.darkCard : Colors.white;
    final brd = isDark ? AppTheme.darkBorder : AppTheme.border;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: brd),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 3, color: borderColor),
              Expanded(
                child: Container(
                  color: cardBg,
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: txt)),
                      const SizedBox(height: 4),
                      Text(date, style: TextStyle(fontSize: 11, color: txtSec)),
                      const SizedBox(height: 6),
                      Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor)),
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
