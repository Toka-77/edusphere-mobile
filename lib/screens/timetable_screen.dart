import 'package:flutter/material.dart';
import '../app_theme.dart';

// ── Event data (matches web TTE array exactly) ──────────────────────
class _TimetableEvent {
  final String code;
  final String name;
  final String instructor;
  final String time;
  final int day;
  final double startHour;
  final double duration;
  final Color color;
  final String type;

  const _TimetableEvent({
    required this.code,
    required this.name,
    required this.instructor,
    required this.time,
    required this.day,
    required this.startHour,
    required this.duration,
    required this.color,
    required this.type,
  });
}

// ── Available colors for Add Class picker (matches web COLORS array) ─
const List<Color> _kColors = [
  Color(0xFF2979FF),
  Color(0xFFE91E63),
  Color(0xFFFF6D00),
  Color(0xFF9C27B0),
  Color(0xFF00BCD4),
  Color(0xFF607D8B),
  Color(0xFF00C853),
  Color(0xFFFF5722),
];

// ── Initial events (matches web TTE) ────────────────────────────────
final List<_TimetableEvent> _kInitialEvents = [
  const _TimetableEvent(code: 'CS431',   name: 'Advanced Web Dev',      instructor: 'Dr. Sarah Hassan',   time: '09:00 - 10:30', day: 0, startHour: 9,    duration: 1.5, color: Color(0xFF2979FF), type: 'Lecture'),
  const _TimetableEvent(code: 'CS412',   name: 'Database Systems',       instructor: 'Dr. Ahmed Ali',      time: '11:00 - 12:30', day: 0, startHour: 11,   duration: 1.5, color: Color(0xFFE91E63), type: 'Lecture'),
  const _TimetableEvent(code: 'MATH301', name: 'Linear Algebra',         instructor: 'Prof. Michael Chen', time: '08:00 - 09:30', day: 1, startHour: 8,    duration: 1.5, color: Color(0xFFFF6D00), type: 'Lecture'),
  const _TimetableEvent(code: 'CS302',   name: 'Machine Learning',       instructor: 'Dr. Layla Nour',     time: '10:00 - 11:30', day: 1, startHour: 10,   duration: 1.5, color: Color(0xFF9C27B0), type: 'Lecture'),
  const _TimetableEvent(code: 'CS431',   name: 'Advanced Web Dev',       instructor: 'Dr. Sarah Hassan',   time: '09:00 - 10:30', day: 2, startHour: 9,    duration: 1.5, color: Color(0xFF2979FF), type: 'Lecture'),
  const _TimetableEvent(code: 'CS431L',  name: 'Web Dev Lab',            instructor: 'TA. Michael Chen',   time: '14:00 - 15:30', day: 2, startHour: 14,   duration: 1.5, color: Color(0xFF00BCD4), type: 'Lab'),
  const _TimetableEvent(code: 'MATH301', name: 'Linear Algebra',         instructor: 'Prof. Michael Chen', time: '08:00 - 09:30', day: 3, startHour: 8,    duration: 1.5, color: Color(0xFFFF6D00), type: 'Lecture'),
  const _TimetableEvent(code: 'CS412',   name: 'Database Systems',       instructor: 'Dr. Ahmed Ali',      time: '11:00 - 12:30', day: 3, startHour: 11,   duration: 1.5, color: Color(0xFFE91E63), type: 'Lecture'),
  const _TimetableEvent(code: 'ARBLEET', name: 'Technical Writing',      instructor: 'Dr. Sara Mohamed',   time: '14:30 - 16:00', day: 3, startHour: 14.5, duration: 1.5, color: Color(0xFF607D8B), type: 'Lecture'),
  const _TimetableEvent(code: 'CS431',   name: 'Advanced Web Dev',       instructor: 'Dr. Sarah Hassan',   time: '09:00 - 10:30', day: 4, startHour: 9,    duration: 1.5, color: Color(0xFF2979FF), type: 'Lecture'),
  const _TimetableEvent(code: 'CS412',   name: 'Database Systems',       instructor: 'Dr. Ahmed Ali',      time: '11:00 - 12:30', day: 4, startHour: 11,   duration: 1.5, color: Color(0xFFE91E63), type: 'Lecture'),
];

// ════════════════════════════════════════════════════════════════════
class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  bool _isWeekView = true;
  bool _reminderSet = false;
  String _reminderTime = '15';
  late List<_TimetableEvent> _events;

  // Add class form state
  String _newName = '';
  String _newCode = '';
  String _newRoom = '';
  int _newDay = 0;
  double _newStart = 9;
  double _newDur = 1.5;
  Color _newColor = const Color(0xFF2979FF);

  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  final List<String> _dayDates = ['Jan 13', 'Jan 14', 'Jan 15', 'Jan 16', 'Jan 17'];
  final List<double> _hours = [8, 9, 10, 11, 12, 13, 14, 15];

  @override
  void initState() {
    super.initState();
    _events = List.from(_kInitialEvents);
  }

  void _showToast(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Set Reminder Modal (matches web showReminderModal) ─────────────
  void _showReminderModal(BuildContext ctx) {
    final isDark = Theme.of(ctx).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkCard : Colors.white;
    final borderC = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    String localTime = _reminderTime;

    showDialog(
      context: ctx,
      builder: (ctx2) => StatefulBuilder(
        builder: (ctx2, setS) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: cardBg,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('🔔 Set Reminder',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: txt)),
                    const SizedBox(height: 2),
                    Text('Get notified before your classes',
                        style: TextStyle(fontSize: 12, color: txtSec)),
                  ]),
                  IconButton(
                    icon: Icon(Icons.close, color: txtSec, size: 20),
                    onPressed: () => Navigator.pop(ctx2),
                  ),
                ]),
                const SizedBox(height: 16),
                Text('How many minutes before class should we remind you?',
                    style: TextStyle(fontSize: 13, color: txt)),
                const SizedBox(height: 14),
                // Time chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['5', '10', '15', '20', '30', '60'].map((min) {
                    final selected = localTime == min;
                    return GestureDetector(
                      onTap: () => setS(() => localTime = min),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? AppTheme.primary.withValues(alpha: 0.12) : (isDark ? AppTheme.darkBg2 : AppTheme.background),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected ? AppTheme.primary : borderC,
                            width: selected ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          '$min min',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: selected ? AppTheme.primary : txt,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx2),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: borderC),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: Text('Cancel', style: TextStyle(color: txt, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx2);
                        setState(() {
                          _reminderSet = true;
                          _reminderTime = localTime;
                        });
                        _showToast('Reminder set: $localTime min before each class', AppTheme.blue);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: const Text('🔔 Set Reminder',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Add Class Modal (matches web showAddModal) ─────────────────────
  void _showAddClassModal(BuildContext ctx, {int? preDay}) {
    final isDark = Theme.of(ctx).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkCard : Colors.white;
    final borderC = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final bgField = isDark ? AppTheme.darkBg : AppTheme.background;

    // Reset form
    _newName = '';
    _newCode = '';
    _newRoom = '';
    _newDay = preDay ?? 0;
    _newStart = 9;
    _newDur = 1.5;
    _newColor = const Color(0xFF2979FF);

    final nameCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final roomCtrl = TextEditingController();

    InputDecoration inputDec(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: txtSec, fontSize: 13),
      filled: true,
      fillColor: bgField,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderC)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderC)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.primary, width: 2)),
    );

    showDialog(
      context: ctx,
      builder: (ctx2) => StatefulBuilder(
        builder: (ctx2, setS) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: cardBg,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('📅 Add Class to Timetable',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: txt)),
                    const SizedBox(height: 2),
                    Text('Schedule a new class session',
                        style: TextStyle(fontSize: 12, color: txtSec)),
                  ]),
                  IconButton(
                    icon: Icon(Icons.close, color: txtSec, size: 20),
                    onPressed: () => Navigator.pop(ctx2),
                  ),
                ]),
                const SizedBox(height: 16),

                // Course Name
                Text('Course Name', style: TextStyle(fontSize: 11, color: txtSec, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                TextField(
                  controller: nameCtrl,
                  style: TextStyle(color: txt, fontSize: 14),
                  decoration: inputDec('e.g. Advanced Web Development'),
                  onChanged: (v) => _newName = v,
                ),
                const SizedBox(height: 12),

                // Course Code
                Text('Course Code', style: TextStyle(fontSize: 11, color: txtSec, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                TextField(
                  controller: codeCtrl,
                  style: TextStyle(color: txt, fontSize: 14),
                  decoration: inputDec('e.g. CS431'),
                  onChanged: (v) => _newCode = v,
                ),
                const SizedBox(height: 12),

                // Room
                Text('Room / Location', style: TextStyle(fontSize: 11, color: txtSec, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                TextField(
                  controller: roomCtrl,
                  style: TextStyle(color: txt, fontSize: 14),
                  decoration: inputDec('e.g. CS Lab 101'),
                  onChanged: (v) => _newRoom = v,
                ),
                const SizedBox(height: 12),

                // Day / Start / Duration row
                Row(children: [
                  // Day
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Day', style: TextStyle(fontSize: 11, color: txtSec, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: bgField,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderC),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _newDay,
                            isExpanded: true,
                            dropdownColor: cardBg,
                            style: TextStyle(color: txt, fontSize: 13),
                            items: List.generate(_days.length, (i) => DropdownMenuItem(value: i, child: Text(_days[i]))),
                            onChanged: (v) => setS(() => _newDay = v!),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(width: 8),
                  // Start Hour
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Start Hour', style: TextStyle(fontSize: 11, color: txtSec, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: bgField,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderC),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                            value: _newStart,
                            isExpanded: true,
                            dropdownColor: cardBg,
                            style: TextStyle(color: txt, fontSize: 13),
                            items: _hours.map((h) => DropdownMenuItem(value: h, child: Text('${h.toInt()}:00'))).toList(),
                            onChanged: (v) => setS(() => _newStart = v!),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(width: 8),
                  // Duration
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Duration (h)', style: TextStyle(fontSize: 11, color: txtSec, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: bgField,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderC),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                            value: _newDur,
                            isExpanded: true,
                            dropdownColor: cardBg,
                            style: TextStyle(color: txt, fontSize: 13),
                            items: [1, 1.5, 2, 2.5, 3].map((d) => DropdownMenuItem(value: d.toDouble(), child: Text('${d}h'))).toList(),
                            onChanged: (v) => setS(() => _newDur = v!),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ]),
                const SizedBox(height: 14),

                // Color picker
                Text('Color', style: TextStyle(fontSize: 11, color: txtSec, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: _kColors.map((clr) {
                    final sel = _newColor == clr;
                    return GestureDetector(
                      onTap: () => setS(() => _newColor = clr),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: clr,
                          shape: BoxShape.circle,
                          border: sel
                              ? Border.all(color: txt, width: 3)
                              : Border.all(color: Colors.transparent, width: 2),
                        ),
                        transform: sel
                            ? (Matrix4.diagonal3Values(1.2, 1.2, 1.0))
                            : Matrix4.identity(),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Buttons
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx2),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: borderC),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: Text('Cancel', style: TextStyle(color: txt, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_newName.trim().isEmpty || _newCode.trim().isEmpty) return;
                        final endH = _newStart + _newDur;
                        setState(() {
                          _events.add(_TimetableEvent(
                            code: _newCode.trim().toUpperCase(),
                            name: _newName.trim(),
                            instructor: _newRoom.trim(),
                            time: '${_newStart.toInt()}:00 - ${endH.toInt()}:${(endH % 1 * 60).toInt().toString().padLeft(2, '0')}',
                            day: _newDay,
                            startHour: _newStart,
                            duration: _newDur,
                            color: _newColor,
                            type: 'Lecture',
                          ));
                        });
                        Navigator.pop(ctx2);
                        _showToast('Class added to timetable!', const Color(0xFF00C853));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: const Text('✓ Add to Timetable',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final bg = isDark ? AppTheme.darkBg : AppTheme.background;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: card,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Timetable',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: txt)),
            Text('Spring Semester 2024 - Week 1',
                style: TextStyle(fontSize: 11, color: txtSec)),
          ],
        ),
        // Actions matching web: reminder btn + add btn + download btn
        actions: [
          // 🔔 Reminder button
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: TextButton.icon(
              onPressed: () => _showReminderModal(context),
              style: TextButton.styleFrom(
                backgroundColor: _reminderSet
                    ? AppTheme.blue.withValues(alpha: 0.12)
                    : AppTheme.primary.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              ),
              icon: const Text('🔔', style: TextStyle(fontSize: 13)),
              label: Text(
                _reminderSet ? 'Set' : 'Remind',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _reminderSet ? AppTheme.blue : AppTheme.primary,
                ),
              ),
            ),
          ),
          // ➕ Add class button
          IconButton(
            icon: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 18),
            ),
            onPressed: () => _showAddClassModal(context),
          ),
          // ⬇ Download button
          PopupMenuButton<String>(
            icon: Icon(Icons.download_outlined, color: txt),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (_) => _showToast('Timetable downloaded!', AppTheme.blue),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'download',
                child: Row(children: [
                  Icon(Icons.download_outlined, size: 18),
                  SizedBox(width: 10),
                  Text('Download PDF'),
                ]),
              ),
              const PopupMenuItem(
                value: 'print',
                child: Row(children: [
                  Icon(Icons.print_outlined, size: 18),
                  SizedBox(width: 10),
                  Text('Print Timetable'),
                ]),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Stats (matches web exactly: This Week / Sections / Online / Tutorials)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(child: _TimetableStat(
                  icon: Icons.menu_book_outlined,
                  label: 'This Week',
                  value: '${_events.length}',
                  color: AppTheme.primary,
                )),
                const SizedBox(width: 10),
                const Expanded(child: _TimetableStat(
                  icon: Icons.cast_for_education_outlined,
                  label: 'Sections',
                  value: '8',
                  color: AppTheme.info,
                )),
                const SizedBox(width: 10),
                const Expanded(child: _TimetableStat(
                  icon: Icons.laptop_outlined,
                  label: 'Online',
                  value: '2',
                  color: AppTheme.warning,
                )),
                const SizedBox(width: 10),
                const Expanded(child: _TimetableStat(
                  icon: Icons.people_outline,
                  label: 'Tutorials',
                  value: '1',
                  color: AppTheme.success,
                )),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Week Navigator ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      icon: const Icon(Icons.chevron_left, color: AppTheme.textSecondary, size: 20),
                      onPressed: () {},
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(children: [
                          Icon(Icons.calendar_today_outlined, size: 12, color: AppTheme.primary),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text('Jan 13 - 17, 2025',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primary),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ]),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      icon: const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 20),
                      onPressed: () {},
                    ),
                  ]),
                ),
                Row(children: [
                  _ViewToggle(label: 'Week', selected: _isWeekView, onTap: () => setState(() => _isWeekView = true)),
                  const SizedBox(width: 6),
                  _ViewToggle(label: 'Day', selected: !_isWeekView, onTap: () => setState(() => _isWeekView = false)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ── Timetable Grid ───────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildGrid(isDark),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(bool isDark) {
    const double timeColWidth = 56;
    const double dayColWidth = 130;
    const double hourHeight = 90.0;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time column
        Column(children: [
          const SizedBox(height: 40),
          ..._hours.map((h) => SizedBox(
            height: hourHeight,
            width: timeColWidth,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('${h.toInt()}:00',
                    style: TextStyle(fontSize: 11, color: txtSec)),
              ),
            ),
          )),
        ]),

        // Day columns
        ..._days.asMap().entries.map((entry) {
          final dayIndex = entry.key;
          final day = entry.value;
          final dayDate = _dayDates[dayIndex];
          final dayEvents = _events.where((e) => e.day == dayIndex).toList();

          // ── Overlap detection ────────────────────────────────
          final Map<_TimetableEvent, int> colIndex = {};
          final Map<_TimetableEvent, int> colTotal = {};

          for (int i = 0; i < dayEvents.length; i++) {
            final a = dayEvents[i];
            final overlapping = dayEvents.where((b) {
              final aEnd = a.startHour + a.duration;
              final bEnd = b.startHour + b.duration;
              return a.startHour < bEnd && aEnd > b.startHour;
            }).toList();

            for (int j = 0; j < overlapping.length; j++) {
              if (!colIndex.containsKey(overlapping[j])) {
                colIndex[overlapping[j]] = j;
              }
              colTotal[overlapping[j]] = overlapping.length;
            }
          }
          // ────────────────────────────────────────────────────

          return Container(
            width: dayColWidth,
            margin: const EdgeInsets.only(left: 4),
            child: Column(children: [
              // Day header
              GestureDetector(
                onTap: () => _showAddClassModal(context, preDay: dayIndex),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: border),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(day,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: txt)),
                      Text(dayDate, style: TextStyle(fontSize: 10, color: txtSec)),
                    ],
                  ),
                ),
              ),
              // Time slots
              SizedBox(
                height: hourHeight * _hours.length,
                child: Stack(children: [
                  Column(children: _hours.map((_) => Container(
                    height: hourHeight,
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: border, width: 0.5)),
                    ),
                  )).toList()),

                  ...dayEvents.map((event) {
                    final top = (event.startHour - 8) * hourHeight;
                    final height = event.duration * hourHeight - 4;
                    final total = colTotal[event] ?? 1;
                    final col = colIndex[event] ?? 0;
                    final slotWidth = (dayColWidth - 8) / total;
                    final left = 2 + col * slotWidth;

                    return Positioned(
                      top: top + 2,
                      left: left,
                      width: slotWidth - 2,
                      height: height,
                      child: _EventBlock(event: event),
                    );
                  }),
                ]),
              ),
            ]),
          );
        }),
      ],
    );
  }
}

// ── Event block ──────────────────────────────────────────────────────
class _EventBlock extends StatelessWidget {
  final _TimetableEvent event;
  const _EventBlock({required this.event});

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: ClipRRect prevents bottom overflow when 2 events are side by side
    // and the reduced width causes text to wrap more than the height allows.
    final bool showInstructor = event.duration >= 1.5 && event.instructor.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subColor = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: event.color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: event.color.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: event.color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(event.code,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(height: 2),
            Text(event.name,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: event.color),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            if (showInstructor)
              Text(event.instructor,
                  style: TextStyle(fontSize: 9, color: subColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            Text(event.time,
                style: TextStyle(fontSize: 9, color: subColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

// ── Stat card ────────────────────────────────────────────────────────
class _TimetableStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _TimetableStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.border),
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
        Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 9,
                color: isDark ? AppTheme.darkTextSec : AppTheme.textSecondary)),
      ]),
    );
  }
}

// ── View toggle (Week / Day) ─────────────────────────────────────────
class _ViewToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ViewToggle({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : (isDark ? AppTheme.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppTheme.primary : (isDark ? AppTheme.darkBorder : AppTheme.border),
          ),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : (isDark ? AppTheme.darkText : AppTheme.textPrimary))),
      ),
    );
  }
}