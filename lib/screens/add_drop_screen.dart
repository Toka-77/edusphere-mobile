import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_theme.dart';
import '../logic/registration/registration_bloc.dart';
import '../logic/registration/registration_event.dart';
import '../logic/registration/registration_state.dart';
import '../data/models/registration_model.dart';
import '../logic/auth/auth_bloc.dart';
import '../logic/auth/auth_state.dart';

class AddDropScreen extends StatefulWidget {
  const AddDropScreen({super.key});

  @override
  State<AddDropScreen> createState() => _AddDropState();
}

class _AddDropState extends State<AddDropScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _searchCtrl = TextEditingController();

  int? _studentId;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _studentId = authState.user.studentNumericId;
      if (_studentId != null) {
        context.read<RegistrationBloc>().add(LoadAvailableCourses(_studentId!));
      }
    }
  }

  @override
  void dispose() {
    _tab.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _add(AvailableCourse c) {
    if (_studentId == null) return;
    if (!c.canRegister) {
      if (c.validationErrors.isNotEmpty) {
        _snack(c.validationErrors.first, AppTheme.error);
      }
      return;
    }
    context.read<RegistrationBloc>().add(RegisterCourse(_studentId!, c.teacherCourseId));
  }

  void _drop(CourseInfo c) {
    if (_studentId == null || c.studentCourseId == null) return;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Drop Course',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text('Are you sure you want to drop "${c.title}"?',
            style: const TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<RegistrationBloc>().add(DropCourse(_studentId!, c.studentCourseId!));
            },
            child: const Text('Drop'),
          ),
        ],
      ),
    );
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500)),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.darkBg : AppTheme.background;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: card,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Courses',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700, color: txt)),
            Text('Manage your enrollment',
                style: TextStyle(fontSize: 11, color: txtSec)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: card,
            child: BlocConsumer<RegistrationBloc, RegistrationState>(
              listener: (context, state) {
                if (state is RegistrationActionSuccess) {
                  _snack(state.message, AppTheme.success);
                  _tab.animateTo(0);
                } else if (state is RegistrationActionFailure) {
                  _snack(state.message, AppTheme.error);
                }
              },
              builder: (context, state) {
                int myCoursesCount = 0;
                int availableCount = 0;

                if (state is RegistrationLoaded) {
                  myCoursesCount = state.myCourses.length;
                  availableCount = state.courses.length;
                }

                return TabBar(
                  controller: _tab,
                  labelColor: AppTheme.primary,
                  unselectedLabelColor: AppTheme.textSecondary,
                  indicatorColor: AppTheme.primary,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('My Courses'),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('$myCoursesCount',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Available'),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.info,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('$availableCount',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
          if (state is RegistrationInitial || state is RegistrationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RegistrationError) {
            return Center(
              child: Text(
                'Failed to load data: ${state.message}',
                style: TextStyle(color: txt),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state is RegistrationLoaded) {
            final myCourses = state.myCourses;
            final allAvailable = state.courses;
            
            final q = _searchCtrl.text.toLowerCase();
            final available = allAvailable.where((c) {
              if (q.isEmpty) return true;
              return c.course.title.toLowerCase().contains(q) ||
                  c.course.code.toLowerCase().contains(q) ||
                  (c.teacher?.name.toLowerCase().contains(q) ?? false);
            }).toList();

            final isRegistering = state is RegistrationActionInProgress;
            final registeringId = isRegistering ? state.registeringCourseId : null;

            return Column(
              children: [
                // ── Stats ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: Row(children: [
                    _StatChip(
                        icon: Icons.menu_book_outlined,
                        color: AppTheme.primary,
                        label: 'Enrolled',
                        value: '${myCourses.length}'),
                    const SizedBox(width: 10),
                    _StatChip(
                        icon: Icons.check_circle_outline,
                        color: AppTheme.success,
                        label: 'Available',
                        value: '${available.length}'),
                  ]),
                ),
                const SizedBox(height: 14),

                // ── Tab views ──────────────────────────────────────────
                Expanded(
                  child: TabBarView(
                    controller: _tab,
                    children: [
                      // ── Tab 1: My Courses ─────────────────────────
                      myCourses.isEmpty
                          ? const _Empty(
                              icon: Icons.menu_book_outlined,
                              msg: 'No courses enrolled yet.\nSwitch to "Available" tab to add courses.')
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                              itemCount: myCourses.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (_, i) {
                                final c = myCourses[i];
                                return _MyCard(
                                  c: c,
                                  isLoading: registeringId == c.studentCourseId,
                                  onDrop: () => _drop(c),
                                );
                              },
                            ),

                      // ── Tab 2: Available ──────────────────────────
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: (_) => setState(() {}),
                            style: TextStyle(color: txt),
                            decoration: InputDecoration(
                              hintText: 'Search courses...',
                              hintStyle: TextStyle(color: txtSec, fontSize: 13),
                              prefixIcon: Icon(Icons.search, color: txtSec, size: 20),
                              filled: true,
                              fillColor: card,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: AppTheme.primary, width: 2),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: available.isEmpty
                              ? const _Empty(
                                  icon: Icons.search_off,
                                  msg: 'No courses found.')
                              : ListView.separated(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 20),
                                  itemCount: available.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 10),
                                  itemBuilder: (_, i) {
                                    final c = available[i];
                                    return _AvailCard(
                                      c: c,
                                      isLoading: registeringId == c.teacherCourseId,
                                      onAdd: () => _add(c),
                                    );
                                  },
                                ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label, value;
  const _StatChip({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final iconBg = isDark ? AppTheme.darkBg : AppTheme.background;

    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Row(children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: color)),
                Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10, color: txtSec)),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _MyCard extends StatelessWidget {
  final CourseInfo c;
  final VoidCallback onDrop;
  final bool isLoading;
  const _MyCard({required this.c, required this.onDrop, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    // Use a hash for consistent colors
    final colors = [
      const Color(0xFF8B5CF6),
      const Color(0xFF3B82F6),
      const Color(0xFF10B981),
      const Color(0xFFF97316),
      const Color(0xFFF59E0B),
    ];
    final codeColor = colors[c.code.hashCode.abs() % colors.length];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: codeColor,
                  borderRadius: BorderRadius.circular(6)),
              child: Text(c.code,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ),
            const Spacer(),
            GestureDetector(
              onTap: isLoading ? null : onDrop,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: isLoading 
                    ? const SizedBox(
                        width: 18, 
                        height: 18, 
                        child: CircularProgressIndicator(color: AppTheme.error, strokeWidth: 2)
                      )
                    : const Icon(Icons.delete_outline,
                        color: AppTheme.error, size: 18),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          Text(c.title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: txt)),
          if (c.description != null && c.description!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(c.description!,
                style: TextStyle(fontSize: 12, color: txtSec)),
          ],
        ],
      ),
    );
  }
}

class _AvailCard extends StatelessWidget {
  final AvailableCourse c;
  final VoidCallback onAdd;
  final bool isLoading;
  
  const _AvailCard({required this.c, required this.onAdd, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    final capacity = c.capacity > 0 ? c.capacity : 1; // avoid div by 0
    final pct = c.enrolledCount / capacity;
    final isFull = c.enrolledCount >= c.capacity;
    final almostFull = pct >= 0.8 && !isFull;
    final barColor = isFull
        ? AppTheme.primary
        : almostFull
            ? AppTheme.warning
            : AppTheme.success;

    final colors = [
      const Color(0xFF8B5CF6),
      const Color(0xFF3B82F6),
      const Color(0xFF10B981),
      const Color(0xFFF97316),
      const Color(0xFFF59E0B),
    ];
    final codeColor = colors[c.course.code.hashCode.abs() % colors.length];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: codeColor,
                  borderRadius: BorderRadius.circular(6)),
              child: Text(c.course.code,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 8),
            Text('${c.course.creditHours} credits',
                style: TextStyle(fontSize: 11, color: txtSec)),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: isFull
                    ? AppTheme.primary.withValues(alpha: 0.1)
                    : AppTheme.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: isFull
                        ? AppTheme.primary.withValues(alpha: 0.3)
                        : AppTheme.success.withValues(alpha: 0.3)),
              ),
              child: Text(
                isFull ? 'Full' : 'Available',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isFull ? AppTheme.primary : AppTheme.success),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: (!c.canRegister || isFull || isLoading) ? null : onAdd,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: (!c.canRegister || isFull) ? AppTheme.border : AppTheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isLoading 
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Icon(Icons.add,
                        color: (!c.canRegister || isFull) ? AppTheme.textLight : Colors.white,
                        size: 20),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          Text(c.course.title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: txt)),
          const SizedBox(height: 2),
          Text(c.teacher?.name ?? 'TBA',
              style: TextStyle(fontSize: 12, color: txtSec)),
          const SizedBox(height: 8),
          _InfoRow(icon: Icons.access_time_outlined, text: c.schedule ?? 'TBA', txtSec: txtSec),
          const SizedBox(height: 4),
          _InfoRow(icon: Icons.location_on_outlined, text: c.room ?? 'TBA', txtSec: txtSec),
          
          if (!c.canRegister && c.validationErrors.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline, size: 14, color: AppTheme.error),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      c.validationErrors.first,
                      style: const TextStyle(fontSize: 11, color: AppTheme.error),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.people_outline, size: 13, color: txtSec),
              const SizedBox(width: 4),
              Text(
                '${c.enrolledCount}/${c.capacity} enrolled',
                style: TextStyle(
                    fontSize: 11,
                    color: almostFull ? AppTheme.warning : txtSec,
                    fontWeight: almostFull ? FontWeight.w600 : FontWeight.normal),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: isDark
                  ? AppTheme.darkBorder
                  : const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color txtSec;
  const _InfoRow({
    required this.icon,
    required this.text,
    required this.txtSec,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 13, color: txtSec),
      const SizedBox(width: 5),
      Flexible(
        child: Text(text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: txtSec)),
      ),
    ]);
  }
}

class _Empty extends StatelessWidget {
  final IconData icon;
  final String msg;
  const _Empty({required this.icon, required this.msg});

  @override
  Widget build(BuildContext context) {
    final txtSec = Theme.of(context).brightness == Brightness.dark
        ? AppTheme.darkTextSec
        : AppTheme.textSecondary;

    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                  color: AppTheme.primaryLight, shape: BoxShape.circle),
              child: Icon(icon, color: AppTheme.primary, size: 28),
            ),
            const SizedBox(height: 12),
            Text(msg,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13, color: txtSec, height: 1.5)),
          ]),
    );
  }
}