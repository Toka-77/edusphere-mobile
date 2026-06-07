import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_theme.dart';
import '../data/models/timetable_model.dart';
import '../logic/timetable/timetable_bloc.dart';
import '../logic/timetable/timetable_event.dart';
import '../logic/timetable/timetable_state.dart';

// ── Color palette assigned per course code ──────────────────────────
const List<Color> _kPalette = [
  Color(0xFF2979FF),
  Color(0xFFE91E63),
  Color(0xFFFF6D00),
  Color(0xFF9C27B0),
  Color(0xFF00BCD4),
  Color(0xFF607D8B),
  Color(0xFF00C853),
  Color(0xFFFF5722),
];

Color _colorFor(String code) => _kPalette[code.hashCode.abs() % _kPalette.length];

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

  // Week starts on Saturday for ERU
  final List<String> _days = ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  final List<double> _hours = [8, 9, 10, 11, 12, 13, 14, 15, 16];

  @override
  void initState() {
    super.initState();
    context.read<TimetableBloc>().add(LoadTimetable());
  }

  void _showToast(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
    ));
  }

  // ── Reminder Modal ─────────────────────────────────────────────────
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
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: ['5', '10', '15', '20', '30', '60'].map((min) {
                    final selected = localTime == min;
                    return GestureDetector(
                      onTap: () => setS(() => localTime = min),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? AppTheme.primary.withValues(alpha: 0.12)
                              : (isDark ? AppTheme.darkBg2 : AppTheme.background),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected ? AppTheme.primary : borderC,
                            width: selected ? 2 : 1,
                          ),
                        ),
                        child: Text('$min min',
                            style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 13,
                              color: selected ? AppTheme.primary : txt,
                            )),
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
                        setState(() { _reminderSet = true; _reminderTime = localTime; });
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
        title: Text('My Timetable',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: txt)),
        actions: [
          TextButton.icon(
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
                fontSize: 11, fontWeight: FontWeight.w700,
                color: _reminderSet ? AppTheme.blue : AppTheme.primary,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: txt, size: 20),
            tooltip: 'Refresh',
            onPressed: () => context.read<TimetableBloc>().add(LoadTimetable()),
          ),
        ],
      ),
      body: BlocBuilder<TimetableBloc, TimetableState>(
        builder: (context, state) {
          if (state is TimetableInitial || state is TimetableLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TimetableError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: AppTheme.error, size: 48),
                  const SizedBox(height: 12),
                  Text('Failed to load timetable',
                      style: TextStyle(fontWeight: FontWeight.w700, color: txt)),
                  const SizedBox(height: 6),
                  Text(state.message, style: TextStyle(color: txtSec, fontSize: 12),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<TimetableBloc>().add(LoadTimetable()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TimetableLoaded) {
            final events = state.events;

            if (events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64, height: 64,
                      decoration: const BoxDecoration(
                          color: AppTheme.primaryLight, shape: BoxShape.circle),
                      child: const Icon(Icons.calendar_today_outlined,
                          color: AppTheme.primary, size: 30),
                    ),
                    const SizedBox(height: 12),
                    Text('No classes scheduled yet',
                        style: TextStyle(fontWeight: FontWeight.w700, color: txt)),
                    const SizedBox(height: 4),
                    Text('Your timetable will appear here once courses are assigned.',
                        style: TextStyle(color: txtSec, fontSize: 12),
                        textAlign: TextAlign.center),
                  ],
                ),
              );
            }

            // Stats
            final lectures = events.where((e) => e.sessionType.toLowerCase().contains('lecture')).length;
            final labs = events.where((e) => e.sessionType.toLowerCase().contains('lab')).length;
            final tutorials = events.where((e) =>
                e.sessionType.toLowerCase().contains('tutorial') ||
                e.sessionType.toLowerCase().contains('ta')).length;

            return Column(
              children: [
                // ── Stats Row ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(children: [
                    Expanded(child: _TimetableStat(
                      icon: Icons.menu_book_outlined,
                      label: 'Sessions',
                      value: '${events.length}',
                      color: AppTheme.primary,
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: _TimetableStat(
                      icon: Icons.cast_for_education_outlined,
                      label: 'Lectures',
                      value: '$lectures',
                      color: AppTheme.info,
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: _TimetableStat(
                      icon: Icons.science_outlined,
                      label: 'Labs',
                      value: '$labs',
                      color: AppTheme.warning,
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: _TimetableStat(
                      icon: Icons.people_outline,
                      label: 'Tutorials',
                      value: '$tutorials',
                      color: AppTheme.success,
                    )),
                  ]),
                ),
                const SizedBox(height: 12),

                // ── View toggle ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _ViewToggle(label: 'Week', selected: _isWeekView, onTap: () => setState(() => _isWeekView = true)),
                      const SizedBox(width: 6),
                      _ViewToggle(label: 'Day', selected: !_isWeekView, onTap: () => setState(() => _isWeekView = false)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // ── Grid ─────────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildGrid(isDark, events),
                      ),
                    ),
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

  Widget _buildGrid(bool isDark, List<TimetableModel> events) {
    const double timeColWidth = 56;
    const double dayColWidth = 130;
    const double hourHeight = 90.0;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;

    // Determine which days to show (only days with events, capped to Mon-Fri unless Sat/Sun has events)
    final daysToShow = _days.asMap().entries.where((entry) {
      return true; // show all 5 by default
    }).toList();

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
        ...daysToShow.map((entry) {
          final dayIndex = entry.key; // 0=Mon,1=Tue...
          final dayName = entry.value;
          final dayEvents = events.where((e) => e.day == dayIndex).toList();

          // Overlap detection
          final Map<TimetableModel, int> colIndex = {};
          final Map<TimetableModel, int> colTotal = {};

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

          return Container(
            width: dayColWidth,
            margin: const EdgeInsets.only(left: 4),
            child: Column(children: [
              // Day header
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: border),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(dayName,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: txt)),
                    if (dayEvents.isNotEmpty)
                      Text('${dayEvents.length} class${dayEvents.length > 1 ? 'es' : ''}',
                          style: TextStyle(fontSize: 9, color: AppTheme.primary)),
                  ],
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
                    // clamp to visible range
                    final topOffset = (event.startHour - 8).clamp(0.0, (_hours.length).toDouble());
                    final top = topOffset * hourHeight;
                    final height = (event.duration * hourHeight - 4).clamp(20.0, double.infinity);
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
  final TimetableModel event;
  const _EventBlock({required this.event});

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(event.code);
    final isLab = event.sessionType.toLowerCase().contains('lab');
    final isTutorial = event.sessionType.toLowerCase().contains('tutorial')
        || event.sessionType.toLowerCase().contains('ta');

    return GestureDetector(
      onTap: () => _showDetail(context, event, color),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border(left: BorderSide(color: color, width: 3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text(event.code,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color)),
                ),
                if (isLab || isTutorial)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(isLab ? 'Lab' : 'TA',
                        style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: color)),
                  ),
              ]),
              const SizedBox(height: 2),
              Flexible(
                child: Text(event.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppTheme.darkText
                            : AppTheme.textPrimary)),
              ),
              if (event.duration >= 1.0) ...[
                const SizedBox(height: 2),
                Row(children: [
                  const Icon(Icons.access_time, size: 9, color: AppTheme.textSecondary),
                  const SizedBox(width: 2),
                  Flexible(
                    child: Text(event.time,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary)),
                  ),
                ]),
                if (event.room != 'TBA') ...[
                  const SizedBox(height: 1),
                  Row(children: [
                    const Icon(Icons.location_on_outlined, size: 9, color: AppTheme.textSecondary),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(event.room,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary)),
                    ),
                  ]),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, TimetableModel event, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final days = ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: card,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
                  child: Text(event.code,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(event.sessionType,
                      style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 11)),
                ),
              ]),
              const SizedBox(height: 12),
              Text(event.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: txt)),
              const SizedBox(height: 16),
              _DetailRow(icon: Icons.person_outline, label: 'Instructor', value: event.instructor, txtSec: txtSec, txt: txt),
              _DetailRow(icon: Icons.calendar_today_outlined, label: 'Day', value: event.day < days.length ? days[event.day] : 'N/A', txtSec: txtSec, txt: txt),
              _DetailRow(icon: Icons.access_time, label: 'Time', value: event.time, txtSec: txtSec, txt: txt),
              _DetailRow(icon: Icons.timelapse_outlined, label: 'Duration', value: '${(event.duration * 60).toInt()} minutes', txtSec: txtSec, txt: txt),
              _DetailRow(icon: Icons.location_on_outlined, label: 'Room', value: event.room, txtSec: txtSec, txt: txt),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color txtSec, txt;
  const _DetailRow({required this.icon, required this.label, required this.value, required this.txtSec, required this.txt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Icon(icon, size: 16, color: txtSec),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 10, color: txtSec, fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(fontSize: 13, color: txt, fontWeight: FontWeight.w500)),
        ]),
      ]),
    );
  }
}

// ── Stat chip ─────────────────────────────────────────────────────────
class _TimetableStat extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _TimetableStat({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: TextStyle(fontSize: 9, color: txtSec), overflow: TextOverflow.ellipsis),
      ]),
    );
  }
}

// ── View toggle ───────────────────────────────────────────────────────
class _ViewToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ViewToggle({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? AppTheme.primary : AppTheme.border),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppTheme.textSecondary)),
      ),
    );
  }
}