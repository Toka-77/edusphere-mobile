import 'package:flutter/material.dart';
import '../app_theme.dart';

// ── Public getter used by Dashboard ──────────────────────────────
int get kPendingCount => 4;

// ── Screen ────────────────────────────────────────────────────────
class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  String _selectedStatus = 'All Status';
  final _searchController = TextEditingController();

  // ── Data defined inside State ─────────────────────────────────
  late final List<Map<String, dynamic>> _all;

  @override
  void initState() {
    super.initState();
    _all = [
      {
        'title': 'Web Development Project 3',
        'course': 'CS401 - Advanced Web Development',
        'desc': 'Build a full-stack web application using React and Node.js',
        'due': 'Due: Dec 15, 2024',
        'time': '11:59 PM',
        'pts': '100 points',
        'status': 'Pending',
      },
      {
        'title': 'Linear Algebra Problem Set',
        'course': 'MATH301 - Advanced Mathematics',
        'desc': 'Complete problems 1-20 from Chapter 5',
        'due': 'Due: Dec 18, 2024',
        'time': '5:00 PM',
        'pts': '50 points',
        'status': 'Pending',
      },
      {
        'title': 'Technical Writing Essay',
        'course': 'ENG201 - Technical Communication',
        'desc': 'Write a 2000-word essay on emerging technologies',
        'due': 'Due: Dec 20, 2024',
        'time': '11:59 PM',
        'pts': '75 points',
        'status': 'Pending',
      },
      {
        'title': 'Machine Learning Assignment 2',
        'course': 'CS501 - Machine Learning',
        'desc': 'Implement and train a neural network model',
        'due': 'Due: Dec 12, 2024',
        'time': '11:59 PM',
        'pts': '100 points',
        'status': 'Submitted',
      },
      {
        'title': 'Database Design Project',
        'course': 'CS402 - Database Systems',
        'desc': 'Design and implement a relational database',
        'due': 'Due: Dec 22, 2024',
        'time': '11:59 PM',
        'pts': '80 points',
        'status': 'Pending',
      },
      {
        'title': 'Research Paper Draft',
        'course': 'CS503 - Research Methods',
        'desc': 'Submit first draft of research paper',
        'due': 'Due: Dec 10, 2024',
        'time': '11:59 PM',
        'pts': '60 points',
        'status': 'Graded',
      },
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered => _all.where((a) {
    final matchStatus = _selectedStatus == 'All Status' ||
        a['status'] == _selectedStatus;
    final matchSearch = (a['title'] as String)
        .toLowerCase()
        .contains(_searchController.text.toLowerCase());
    return matchStatus && matchSearch;
  }).toList();

  int _count(String status) =>
      _all.where((a) => a['status'] == status).length;

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
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
            Text('All Assignments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: txt)),
            Text('Manage and track all your course assignments', style: TextStyle(fontSize: 11, color: txtSec)),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Search + Filter ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(color: txt),
                    decoration: InputDecoration(
                      hintText: 'Search assignments...',
                      hintStyle: TextStyle(color: txtSec, fontSize: 13),
                      prefixIcon: Icon(Icons.search, color: txtSec, size: 20),
                      filled: true,
                      fillColor: card,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
                        borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedStatus,
                      isDense: true,
                      dropdownColor: card,
                      icon: Icon(Icons.keyboard_arrow_down, size: 18, color: txt),
                      style: TextStyle(fontSize: 13, color: txt),
                      items: ['All Status', 'Pending', 'Submitted', 'Graded']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedStatus = v!),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Stats ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _StatBox(
                    label: 'Total',
                    value: '${_all.length}',
                    color: AppTheme.textPrimary,
                    bg: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatBox(
                    label: 'Pending',
                    value: '${_count('Pending')}',
                    color: AppTheme.warning,
                    bg: const Color(0xFFFFFBEB),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatBox(
                    label: 'Submitted',
                    value: '${_count('Submitted')}',
                    color: AppTheme.info,
                    bg: const Color(0xFFEFF6FF),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatBox(
                    label: 'Graded',
                    value: '${_count('Graded')}',
                    color: AppTheme.success,
                    bg: const Color(0xFFECFDF5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── List ─────────────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _AssignmentCard(item: items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat box ──────────────────────────────────────────────────────
class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color bg;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800, color: color),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 9, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ── Assignment Card ───────────────────────────────────────────────
class _AssignmentCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _AssignmentCard({required this.item});

  Color get _leftBorder {
    switch (item['status'] as String) {
      case 'Pending':   return AppTheme.warning;
      case 'Submitted': return AppTheme.info;
      case 'Graded':    return AppTheme.success;
      default:          return AppTheme.border;
    }
  }

  Color get _badgeColor {
    switch (item['status'] as String) {
      case 'Pending':   return AppTheme.warning;
      case 'Submitted': return AppTheme.info;
      case 'Graded':    return AppTheme.success;
      default:          return AppTheme.textSecondary;
    }
  }

  Color get _badgeBg {
    switch (item['status'] as String) {
      case 'Pending':   return const Color(0xFFFFFBEB);
      case 'Submitted': return const Color(0xFFEFF6FF);
      case 'Graded':    return const Color(0xFFECFDF5);
      default:          return AppTheme.background;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = item['status'] as String;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Colored left accent strip
              Container(width: 4, color: _leftBorder),

              // Card content
              Expanded(
                child: Container(
                  color: card,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item['title'] as String,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: txt,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _badgeBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: _badgeColor.withValues(alpha: 0.35)),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _badgeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Course
                      Text(
                        item['course'] as String,
                        style: const TextStyle(
                            fontSize: 12, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 6),

                      // Description
                      Text(
                        item['desc'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          color: txt,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Meta + button
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 13, color: AppTheme.textLight),
                          const SizedBox(width: 4),
                          Text(item['due'] as String,
                              style: const TextStyle(
                                  fontSize: 12, color: AppTheme.textSecondary)),
                          const SizedBox(width: 10),
                          const Icon(Icons.access_time_outlined,
                              size: 13, color: AppTheme.textLight),
                          const SizedBox(width: 4),
                          Text(item['time'] as String,
                              style: const TextStyle(
                                  fontSize: 12, color: AppTheme.textSecondary)),
                          const SizedBox(width: 10),
                          Text(item['pts'] as String,
                              style: const TextStyle(
                                  fontSize: 12, color: AppTheme.textSecondary)),
                          const Spacer(),
                          if (status == 'Pending')
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                textStyle: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Submit'),
                            ),
                          if (status == 'Submitted')
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                side: const BorderSide(color: AppTheme.border),
                                foregroundColor: AppTheme.textSecondary,
                                textStyle: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('View'),
                            ),
                          if (status == 'Graded')
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                side:
                                    const BorderSide(color: AppTheme.success),
                                foregroundColor: AppTheme.success,
                                textStyle: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('View Grade'),
                            ),
                        ],
                      ),
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