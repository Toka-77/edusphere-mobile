import 'package:flutter/material.dart';
import '../app_theme.dart';

// ─── Model ────────────────────────────────────────────────────────
class _Course {
  final String code,
      name,
      instructor,
      schedule,
      location;
  final int credits,
      enrolled,
      capacity;
  final Color codeColor;
  const _Course({
    required this.code,
    required this.name,
    required this.instructor,
    required this.schedule,
    required this.location,
    required this.credits,
    required this.enrolled,
    required this.capacity,
    required this.codeColor,
  });
  bool get isFull =>
      enrolled >= capacity;
}

// ─── Screen ───────────────────────────────────────────────────────
class AddDropScreen
    extends StatefulWidget {
  const AddDropScreen({super.key});
  @override
  State<AddDropScreen>
  createState() =>
      _AddDropState();
}

class _AddDropState
    extends State<AddDropScreen>
    with
        SingleTickerProviderStateMixin {
  late TabController _tab;
  final _searchCtrl =
  TextEditingController();

  final List<_Course> _all = const [
    _Course(
        code: 'CS412',
        name: 'Database Systems',
        instructor: 'Dr. Ahmed Ali',
        schedule: 'MWF 11:00-12:30 PM',
        location: 'CS Building 305',
        credits: 3,
        enrolled: 22,
        capacity: 30,
        codeColor: Color(0xFF8B5CF6)),
    _Course(
        code: 'CS302',
        name: 'Machine Learning',
        instructor: 'Dr. Layla Nour',
        schedule: 'TTh 10:00-11:30 AM',
        location: 'IT Lab 411',
        credits: 3,
        enrolled: 30,
        capacity: 30,
        codeColor: Color(0xFF3B82F6)),
    _Course(
        code: 'ARBLEET',
        name: 'Arabic Language',
        instructor: 'Dr. Hany Fahmy',
        schedule: 'MWF 9:00-10:00 AM',
        location: 'Arts Building 102',
        credits: 2,
        enrolled: 15,
        capacity: 25,
        codeColor: Color(0xFF10B981)),
    _Course(
        code: 'IT205',
        name: 'Information Systems',
        instructor: 'Dr. Sara Khaled',
        schedule: 'TTh 1:00-2:30 PM',
        location: 'IT Building 210',
        credits: 3,
        enrolled: 12,
        capacity: 28,
        codeColor: Color(0xFFF97316)),
    _Course(
        code: 'MATH401',
        name: 'Numerical Methods',
        instructor: 'Prof. Michael Chen',
        schedule: 'MWF 2:00-3:00 PM',
        location: 'Math Hall 201',
        credits: 3,
        enrolled: 10,
        capacity: 30,
        codeColor: Color(0xFFF59E0B)),
    _Course(
        code: 'CS350',
        name: 'Computer Networks',
        instructor: 'Dr. Ahmed Taha',
        schedule: 'TTh 3:00-4:30 PM',
        location: 'CS Lab 405',
        credits: 3,
        enrolled: 20,
        capacity: 30,
        codeColor: Color(0xFF6366F1)),
    _Course(
        code: 'ENG201',
        name: 'Technical Writing',
        instructor: 'Prof. Lisa Adams',
        schedule: 'MWF 9:00-10:00 AM',
        location: 'Arts Building 102',
        credits: 2,
        enrolled: 15,
        capacity: 25,
        codeColor: Color(0xFF10B981)),
  ];

  late Set<String> _enrolled;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _enrolled = {'CS431', 'MATH301'};
  }

  @override
  void dispose() {
    _tab.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_Course> get _myCourses =>
      _all.where((c) => _enrolled.contains(c.code)).toList();

  List<_Course> get _available {
    final q = _searchCtrl.text.toLowerCase();
    return _all.where((c) {
      if (_enrolled.contains(c.code)) return false;
      if (q.isEmpty) return true;
      return c.name.toLowerCase().contains(q) ||
          c.code.toLowerCase().contains(q) ||
          c.instructor.toLowerCase().contains(q);
    }).toList();
  }

  int get _totalCredits =>
      _myCourses.fold(0, (s, c) => s + c.credits);

  void _add(_Course c) {
    if (c.isFull) return;
    setState(() => _enrolled.add(c.code));
    _snack('${c.code} added to your courses ✓', AppTheme.success);
    _tab.animateTo(0);
  }

  void _drop(_Course c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Drop Course',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text('Are you sure you want to drop "${c.name}"?',
            style: const TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _enrolled.remove(c.code));
              _snack('${c.code} dropped', AppTheme.primary);
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
      duration: const Duration(seconds: 2),
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
            Text('Add / Drop Courses',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700, color: txt)),
            Text('Manage your enrollment for Spring 2024',
                style: TextStyle(fontSize: 11, color: txtSec)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: card,
            child: TabBar(
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
                        child: Text('${_myCourses.length}',
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
                        child: Text('${_available.length}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Stats ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(children: [
              _StatChip(
                  icon: Icons.menu_book_outlined,
                  color: AppTheme.primary,
                  label: 'Enrolled',
                  value: '${_myCourses.length}'),
              const SizedBox(width: 10),
              _StatChip(
                  icon: Icons.star_outline,
                  color: AppTheme.warning,
                  label: 'Credits',
                  value: '$_totalCredits'),
              const SizedBox(width: 10),
              _StatChip(
                  icon: Icons.check_circle_outline,
                  color: AppTheme.success,
                  label: 'Available',
                  value: '${_available.length}'),
            ]),
          ),
          const SizedBox(height: 14),

          // ── Tab views ──────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                // ── Tab 1: My Courses ─────────────────────────
                _myCourses.isEmpty
                    ? const _Empty(
                    icon: Icons.menu_book_outlined,
                    msg: 'No courses enrolled yet.\nSwitch to "Available" tab to add courses.')
                    : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                  itemCount: _myCourses.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
                  itemBuilder: (_, i) => _MyCard(
                      c: _myCourses[i],
                      onDrop: () => _drop(_myCourses[i])),
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
                    child: _available.isEmpty
                        ? const _Empty(
                        icon: Icons.search_off,
                        msg: 'No courses found.')
                        : ListView.separated(
                      padding:
                      const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      itemCount: _available.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                      itemBuilder: (_, i) => _AvailCard(
                          c: _available[i],
                          onAdd: () => _add(_available[i])),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stat chip ────────────────────────────────────────────────────
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

// ─── My Course Card ───────────────────────────────────────────────
class _MyCard extends StatelessWidget {
  final _Course c;
  final VoidCallback onDrop;
  const _MyCard({required this.c, required this.onDrop});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

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
                  color: c.codeColor,
                  borderRadius: BorderRadius.circular(6)),
              child: Text(c.code,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 8),
            Text('${c.credits} credits',
                style: TextStyle(fontSize: 11, color: txtSec)),
            const Spacer(),
            GestureDetector(
              onTap: onDrop,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete_outline,
                    color: AppTheme.primary, size: 18),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          Text(c.name,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: txt)),           // ← dark-aware
          const SizedBox(height: 2),
          Text(c.instructor,
              style: TextStyle(fontSize: 12, color: txtSec)),  // ← dark-aware
          const SizedBox(height: 8),
          _InfoRow(icon: Icons.access_time_outlined, text: c.schedule, txtSec: txtSec),
          const SizedBox(height: 4),
          _InfoRow(icon: Icons.location_on_outlined, text: c.location, txtSec: txtSec),
        ],
      ),
    );
  }
}

// ─── Available Course Card ────────────────────────────────────────
class _AvailCard extends StatelessWidget {
  final _Course c;
  final VoidCallback onAdd;
  const _AvailCard({required this.c, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    final pct = c.enrolled / c.capacity;
    final almostFull = pct >= 0.8 && !c.isFull;
    final barColor = c.isFull
        ? AppTheme.primary
        : almostFull
        ? AppTheme.warning
        : AppTheme.success;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,                          // ← dark-aware
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),    // ← dark-aware
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: c.codeColor,
                  borderRadius: BorderRadius.circular(6)),
              child: Text(c.code,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 8),
            Text('${c.credits} credits',
                style: TextStyle(fontSize: 11, color: txtSec)),  // ← dark-aware
            const SizedBox(width: 8),
            // status badge
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: c.isFull
                    ? AppTheme.primary.withOpacity(0.1)
                    : AppTheme.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: c.isFull
                        ? AppTheme.primary.withOpacity(0.3)
                        : AppTheme.success.withOpacity(0.3)),
              ),
              child: Text(
                c.isFull ? 'Full' : 'Available',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: c.isFull ? AppTheme.primary : AppTheme.success),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: c.isFull ? null : onAdd,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: c.isFull ? AppTheme.border : AppTheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.add,
                    color: c.isFull ? AppTheme.textLight : Colors.white,
                    size: 20),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          Text(c.name,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: txt)),           // ← dark-aware
          const SizedBox(height: 2),
          Text(c.instructor,
              style: TextStyle(fontSize: 12, color: txtSec)),  // ← dark-aware
          const SizedBox(height: 8),
          _InfoRow(icon: Icons.access_time_outlined, text: c.schedule, txtSec: txtSec),
          const SizedBox(height: 4),
          _InfoRow(icon: Icons.location_on_outlined, text: c.location, txtSec: txtSec),
          const SizedBox(height: 10),
          // enrollment bar
          Row(
            children: [
              Icon(Icons.people_outline, size: 13, color: txtSec),
              const SizedBox(width: 4),
              Text(
                '${c.enrolled}/${c.capacity} enrolled',
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
                  : const Color(0xFFE5E7EB),     // ← dark-aware
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared info row ──────────────────────────────────────────────
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
            style: TextStyle(fontSize: 12, color: txtSec)),  // ← dark-aware
      ),
    ]);
  }
}

// ─── Empty state ──────────────────────────────────────────────────
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