import 'package:flutter/material.dart';
import '../app_theme.dart';

class TimetableScreen
    extends StatefulWidget {
  const TimetableScreen(
      {super.key});

  @override
  State<TimetableScreen>
      createState() =>
          _TimetableScreenState();
}

class _TimetableScreenState
    extends State<
        TimetableScreen> {
  bool _isWeekView = true;

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];
  final List<String> _dayDates = [
    'Jan 15',
    'Jan 16',
    'Jan 17',
    'Jan 18',
    'Jan 19'
  ];
  final List<String> _times = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00'
  ];

  final List<_TimetableEvent>
      _events = const [
    _TimetableEvent(
        code: 'CS401',
        name:
            'Advanced Web Development',
        instructor:
            'Dr. Sarah Johnson',
        time: '09:00 - 10:30',
        day: 0,
        startHour: 9,
        duration: 1.5,
        color: Color(0xFFE53935),
        type: 'Lecture'),
    _TimetableEvent(
        code: 'CS402',
        name: 'Database Systems',
        instructor:
            'Dr. Emily Rodriguez',
        time: '11:00 - 12:30',
        day: 0,
        startHour: 11,
        duration: 1.5,
        color: Color(0xFF8B5CF6),
        type: 'Lecture'),
    _TimetableEvent(
        code: 'CS401L',
        name: 'Web Dev Lab',
        instructor:
            'TA. Michael Chen',
        time: '14:00 - 16:00',
        day: 0,
        startHour: 14,
        duration: 2,
        color: Color(0xFF3B82F6),
        type: 'Lab'),
    _TimetableEvent(
        code: 'MATH301',
        name: 'Linear Algebra',
        instructor:
            'Prof. Michael Chen',
        time: '08:00 - 09:30',
        day: 1,
        startHour: 8,
        duration: 1.5,
        color: Color(0xFFF59E0B),
        type: 'Lecture'),
    _TimetableEvent(
        code: 'CS501',
        name: 'Machine Learning',
        instructor:
            'Dr. James Wilson',
        time: '10:00 - 11:30',
        day: 1,
        startHour: 10,
        duration: 1.5,
        color: Color(0xFFF97316),
        type: 'Lecture'),
    _TimetableEvent(
        code: 'CS401',
        name:
            'Advanced Web Development',
        instructor:
            'Dr. Sarah Johnson',
        time: '09:00 - 10:30',
        day: 2,
        startHour: 9,
        duration: 1.5,
        color: Color(0xFFE53935),
        type: 'Lecture'),
    _TimetableEvent(
        code: 'Lunch',
        name: 'Lunch Break',
        instructor: '',
        time: '13:00 - 14:00',
        day: 2,
        startHour: 13,
        duration: 1,
        color: Color(0xFF9CA3AF),
        type: 'Break'),
    _TimetableEvent(
        code: 'MATH301',
        name: 'Linear Algebra',
        instructor:
            'Prof. Michael Chen',
        time: '08:00 - 09:30',
        day: 3,
        startHour: 8,
        duration: 1.5,
        color: Color(0xFFF59E0B),
        type: 'Lecture'),
    _TimetableEvent(
        code: 'CS402L',
        name: 'Database Lab',
        instructor:
            'TA. Alex Johnson',
        time: '11:00 - 13:00',
        day: 3,
        startHour: 11,
        duration: 2,
        color: Color(0xFF8B5CF6),
        type: 'Lab'),
    _TimetableEvent(
        code: 'CS401',
        name:
            'Advanced Web Development',
        instructor:
            'Dr. Sarah Johnson',
        time: '09:00 - 10:30',
        day: 4,
        startHour: 9,
        duration: 1.5,
        color: Color(0xFFE53935),
        type: 'Lecture'),
    _TimetableEvent(
        code: 'CS402',
        name: 'Database Systems',
        instructor:
            'Dr. Emily Rodriguez',
        time: '11:00 - 12:30',
        day: 4,
        startHour: 11,
        duration: 1.5,
        color: Color(0xFF8B5CF6),
        type: 'Lecture'),
  ];

  @override
  Widget build(
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final bg = isDark ? AppTheme.darkBg : AppTheme.background;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            Text('My Timetable',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight
                            .w700)),
            Text(
                'Spring Semester 2024 - Week 1',
                style: TextStyle(
                    fontSize: 11,
                    color: txtSec)),
          ],
        ),
        // ✅ Fixed overflow: replaced 3 separate widgets with 1 PopupMenuButton
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
                Icons.more_vert),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius
                        .circular(
                            12)),
            onSelected: (_) {},
            itemBuilder:
                (context) => [
              const PopupMenuItem(
                value: 'print',
                child:
                    Row(children: [
                  Icon(
                      Icons
                          .print_outlined,
                      size: 18),
                  SizedBox(
                      width: 10),
                  Text(
                      'Print Timetable'),
                ]),
              ),
              const PopupMenuItem(
                value: 'download',
                child:
                    Row(children: [
                  Icon(
                      Icons
                          .download_outlined,
                      size: 18),
                  SizedBox(
                      width: 10),
                  Text(
                      'Download PDF'),
                ]),
              ),
              const PopupMenuItem(
                value: 'reminders',
                child:
                    Row(children: [
                  Icon(
                      Icons
                          .notifications_outlined,
                      size: 18,
                      color: AppTheme
                          .primary),
                  SizedBox(
                      width: 10),
                  Text('Reminders',
                      style: TextStyle(
                          color: AppTheme
                              .primary)),
                ]),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats
          const Padding(
            padding: EdgeInsets
                .fromLTRB(
                    16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                    child: _TimetableStat(
                        icon: Icons
                            .menu_book_outlined,
                        label:
                            'Total Classes',
                        value:
                            '11',
                        color: AppTheme
                            .primary)),
                SizedBox(
                    width: 10),
                Expanded(
                    child: _TimetableStat(
                        icon: Icons
                            .cast_for_education_outlined,
                        label:
                            'Lectures',
                        value: '8',
                        color: AppTheme
                            .info)),
                SizedBox(
                    width: 10),
                Expanded(
                    child: _TimetableStat(
                        icon: Icons
                            .science_outlined,
                        label:
                            'Labs',
                        value: '2',
                        color: AppTheme
                            .warning)),
                SizedBox(
                    width: 10),
                Expanded(
                    child: _TimetableStat(
                        icon: Icons
                            .people_outline,
                        label:
                            'Tutorials',
                        value: '1',
                        color: AppTheme
                            .success)),
              ],
            ),
          ),
          const SizedBox(
              height: 12),

          // Week Navigator
          Padding(
            padding:
                const EdgeInsets
                    .symmetric(
                    horizontal:
                        16),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                          Icons
                              .chevron_left,
                          color: AppTheme
                              .textSecondary),
                      onPressed:
                          () {},
                    ),
                    Container(
                      padding: const EdgeInsets
                          .symmetric(
                          horizontal:
                              12,
                          vertical:
                              6),
                      decoration:
                          BoxDecoration(
                        color: AppTheme
                            .primaryLight,
                        borderRadius:
                            BorderRadius.circular(
                                8),
                      ),
                      child:
                          const Row(
                        children: [
                          Icon(
                              Icons
                                  .calendar_today_outlined,
                              size:
                                  14,
                              color:
                                  AppTheme.primary),
                          SizedBox(
                              width:
                                  6),
                          Text(
                              'Jan 15 - 19, 2024',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                          Icons
                              .chevron_right,
                          color: AppTheme
                              .textSecondary),
                      onPressed:
                          () {},
                    ),
                  ],
                ),
                Row(
                  children: [
                    _ViewToggle(
                        label:
                            'Week',
                        selected:
                            _isWeekView,
                        onTap: () =>
                            setState(() =>
                                _isWeekView = true)),
                    const SizedBox(
                        width: 6),
                    _ViewToggle(
                        label:
                            'Day',
                        selected:
                            !_isWeekView,
                        onTap: () =>
                            setState(() =>
                                _isWeekView = false)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
              height: 8),

          // Timetable Grid
          Expanded(
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets
                      .only(
                      bottom: 16),
              child:
                  SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal,
                child: Padding(
                  padding:
                      const EdgeInsets
                          .symmetric(
                          horizontal:
                              16),
                  child:
                      _buildGrid(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    const double timeColWidth = 56;
    const double dayColWidth = 130;
    const double hourHeight = 70.0;
    final isDark = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // Time column
        Column(
          children: [
            Container(height: 40),
            ..._times.map((t) =>
                Container(
                  height:
                      hourHeight,
                  width:
                      timeColWidth,
                  alignment:
                      Alignment
                          .topCenter,
                  padding:
                      const EdgeInsets
                          .only(
                          top: 4),
                  child: Text(t,
                      style: TextStyle(
                          fontSize:
                              11,
                          color: txtSec)),
                )),
          ],
        ),

        // Day columns
        ..._days
            .asMap()
            .entries
            .map((entry) {
          final dayIndex =
              entry.key;
          final day = entry.value;
          final dayDate =
              _dayDates[dayIndex];
          final dayEvents = _events
              .where((e) =>
                  e.day ==
                  dayIndex)
              .toList();

          return Container(
            width: dayColWidth,
            margin:
                const EdgeInsets
                    .only(left: 4),
            child: Column(
              children: [
                // Day header
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: border),
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      Text(day,
                          style: TextStyle(
                              fontSize:
                                  12,
                              fontWeight: FontWeight
                                  .w700,
                              color: isDark ? AppTheme.darkText :
                                  AppTheme.textPrimary)),
                      Text(dayDate,
                          style: TextStyle(
                              fontSize:
                                  10,
                              color: txtSec)),
                    ],
                  ),
                ),

                // Time slots
                SizedBox(
                  height: hourHeight *
                      _times
                          .length,
                  child: Stack(
                    children: [
                      Column(
                        children: _times
                            .map((_) => Container(
                                  height: hourHeight,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: border, width: 0.5),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      ...dayEvents.map(
                          (event) {
                        final top =
                            (event.startHour - 8) *
                                hourHeight;
                        final height =
                            event.duration * hourHeight -
                                4;
                        return Positioned(
                          top: top +
                              2,
                          left: 2,
                          right: 2,
                          height:
                              height,
                          child: _EventBlock(
                              event:
                                  event),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

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

class _EventBlock
    extends StatelessWidget {
  final _TimetableEvent event;
  const _EventBlock(
      {required this.event});

  @override
  Widget build(
      BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: event.color
            .withValues(
                alpha: 0.15),
        borderRadius:
            BorderRadius.circular(
                8),
        border: Border.all(
            color: event.color
                .withValues(
                    alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Container(
            padding:
                const EdgeInsets
                    .symmetric(
                    horizontal: 5,
                    vertical: 2),
            decoration:
                BoxDecoration(
              color: event.color,
              borderRadius:
                  BorderRadius
                      .circular(4),
            ),
            child: Text(event.code,
                style: const TextStyle(
                    fontSize: 9,
                    fontWeight:
                        FontWeight
                            .w700,
                    color: Colors
                        .white)),
          ),
          const SizedBox(
              height: 3),
          Text(event.name,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight:
                      FontWeight
                          .w600,
                  color:
                      event.color),
              maxLines: 2,
              overflow:
                  TextOverflow
                      .ellipsis),
          if (event.instructor
              .isNotEmpty)
            Text(event.instructor,
                style: TextStyle(
                    fontSize: 9,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppTheme.darkTextSec
                        : AppTheme.textSecondary),
                maxLines: 1,
                overflow:
                    TextOverflow
                        .ellipsis),
          Text(event.time,
              style: TextStyle(
                  fontSize: 9,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.darkTextSec
                      : AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

class _TimetableStat
    extends StatelessWidget {
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
  Widget build(
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets
          .symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : Colors.white,
        borderRadius:
            BorderRadius.circular(
                12),
        border: Border.all(
            color: isDark
                ? AppTheme.darkBorder
                : AppTheme.border),
      ),
      child: Column(
        children: [
          Icon(icon,
              color: color,
              size: 20),
          const SizedBox(
              height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight
                          .w800,
                  color: color)),
          Text(label,
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                  fontSize: 9,
                  color: isDark
                      ? AppTheme.darkTextSec
                      : AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

class _ViewToggle
    extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ViewToggle({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets
            .symmetric(
            horizontal: 14,
            vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primary
              : isDark ? AppTheme.darkCard : Colors.white,
          borderRadius:
              BorderRadius
                  .circular(8),
          border: Border.all(
              color: selected
                  ? AppTheme
                      .primary
                  : isDark
                      ? AppTheme.darkBorder
                      : AppTheme.border),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight:
                    FontWeight
                        .w600,
                color: selected
                    ? Colors.white
                    : isDark
                        ? AppTheme.darkTextSec
                        : AppTheme.textSecondary)),
      ),
    );
  }
}
