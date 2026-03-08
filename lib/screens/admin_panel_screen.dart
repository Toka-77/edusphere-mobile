import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../widgets/stat_card.dart';
import 'home_screen.dart';

class AdminPanelScreen
    extends StatefulWidget {
  const AdminPanelScreen(
      {super.key});

  @override
  State<AdminPanelScreen>
      createState() =>
          _AdminPanelScreenState();
}

class _AdminPanelScreenState
    extends State<AdminPanelScreen>
    with
        SingleTickerProviderStateMixin {
  late TabController
      _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final bg = isDark ? AppTheme.darkBg : AppTheme.background;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
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
            Text('Admin Dashboard',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: txt)),
            Text('Manage university services and student requests',
                style: TextStyle(fontSize: 11, color: txtSec)),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                  icon: Icon(Icons.notifications_outlined, color: txt),
                  onPressed: () {}),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                      color: AppTheme.primary, shape: BoxShape.circle),
                  child: const Center(
                    child: Text('3',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(
                16),
        child: Column(
          children: [
            // Stats
            GridView.count(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio:
                  1.5,
              children: const [
                StatCard(
                    icon: Icons
                        .people_outline,
                    iconColor:
                        AppTheme
                            .info,
                    label:
                        'Total Students',
                    value:
                        '2,450'),
                StatCard(
                    icon: Icons
                        .description_outlined,
                    iconColor:
                        AppTheme
                            .warning,
                    label:
                        'Pending Excuses',
                    value: '18'),
                StatCard(
                    icon: Icons
                        .chat_bubble_outline,
                    iconColor:
                        AppTheme
                            .primary,
                    label:
                        'New Complaints',
                    value: '5'),
                StatCard(
                    icon: Icons
                        .warning_amber_outlined,
                    iconColor:
                        AppTheme
                            .orange,
                    label:
                        'Warning Issued',
                    value: '12'),
              ],
            ),
            const SizedBox(
                height: 20),

            // Tabs
            Container(
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  TabBar(
                    controller:
                        _tabController,
                    indicatorSize:
                        TabBarIndicatorSize
                            .label,
                    labelColor:
                        Colors
                            .white,
                    unselectedLabelColor:
                        AppTheme
                            .textSecondary,
                    indicator:
                        BoxDecoration(
                      color: AppTheme
                          .primary,
                      borderRadius:
                          BorderRadius
                              .circular(
                                  8),
                    ),
                    tabs: const [
                      Tab(
                          text:
                              'Medical Excuses'),
                      Tab(
                          text:
                              'Complaints'),
                      Tab(
                          text:
                              'Students'),
                    ],
                    padding:
                        const EdgeInsets
                            .all(
                            8),
                  ),
                  SizedBox(
                    height: 280,
                    child:
                        TabBarView(
                      controller:
                          _tabController,
                      children: [
                        _MedicalExcusesTab(),
                        _ComplaintsTab(),
                        _StudentsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 20),

            // Recent Logs
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Row(
                    children: [
                      Icon(
                          Icons
                              .history,
                          size: 18,
                          color: txtSec),
                      const SizedBox(
                          width:
                              8),
                      Text(
                          'Recent Logs',
                          style: TextStyle(
                              fontWeight: FontWeight
                                  .w700,
                              fontSize:
                                  15,
                              color:
                                  txt)),
                    ],
                  ),
                  const SizedBox(
                      height: 14),
                  const _LogItem(
                    color: AppTheme
                        .success,
                    timeAgo:
                        '2M AGO',
                    actor:
                        'Admin Sarah',
                    action:
                        'Approved Excuse #092',
                  ),
                  const SizedBox(
                      height: 10),
                  const _LogItem(
                    color: AppTheme
                        .warning,
                    timeAgo:
                        '1H AGO',
                    actor:
                        'System',
                    action:
                        'Issued Warning (Attendance)',
                  ),
                  const SizedBox(
                      height: 10),
                  const _LogItem(
                    color: AppTheme
                        .info,
                    timeAgo:
                        '3H AGO',
                    actor:
                        'Admin Mike',
                    action:
                        'Responded to Complaint',
                  ),
                  const SizedBox(
                      height: 12),
                  Center(
                    child:
                        TextButton(
                      onPressed:
                          () {},
                      child: const Text(
                          'View All Activity Logs',
                          style: TextStyle(
                              color: AppTheme
                                  .textSecondary,
                              fontSize:
                                  13)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 16),

            // University Policy Card
            Container(
              padding:
                  const EdgeInsets
                      .all(20),
              decoration:
                  BoxDecoration(
                color: const Color(
                    0xFF7C3AED),
                borderRadius:
                    BorderRadius
                        .circular(
                            16),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  const Text(
                      'University Policy',
                      style: TextStyle(
                          color: Colors
                              .white,
                          fontSize:
                              18,
                          fontWeight:
                              FontWeight
                                  .w700)),
                  const SizedBox(
                      height: 6),
                  const Text(
                    'Administrative actions must comply with the 2026 EduSphere Academic Charter.',
                    style: TextStyle(
                        color: Colors
                            .white70,
                        fontSize:
                            12,
                        height:
                            1.5),
                  ),
                  const SizedBox(
                      height: 14),
                  ElevatedButton(
                    onPressed:
                        () {},
                    style: ElevatedButton
                        .styleFrom(
                      backgroundColor: Colors
                          .white
                          .withOpacity(
                              0.2),
                      foregroundColor:
                          Colors
                              .white,
                      side: const BorderSide(
                          color: Colors
                              .white30),
                    ),
                    child: const Text(
                        'Download Charter'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicalExcusesTab
    extends StatelessWidget {
  @override
  Widget build(
      BuildContext context) {
    return ListView(
      padding:
          const EdgeInsets.all(12),
      children: const [
        _AdminRow(
          name: 'Ahmed Ali',
          id: 'ID: 223001',
          tag: 'MEDICAL',
          issue: 'Severe Flu',
          date: '15 Oct',
        ),
        SizedBox(height: 8),
        _AdminRow(
          name: 'Sarah Smith',
          id: 'ID: 223045',
          tag: 'MEDICAL',
          issue: 'Medical Surgery',
          date: '14 Oct',
        ),
        SizedBox(height: 8),
        _AdminRow(
          name: 'Omar Hassan',
          id: 'ID: 224112',
          tag: 'MEDICAL',
          issue:
              'Dental Appointment',
          date: '14 Oct',
        ),
      ],
    );
  }
}

class _ComplaintsTab
    extends StatelessWidget {
  @override
  Widget build(
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Text(
          'No new complaints',
          style: TextStyle(
              color: isDark ? AppTheme.darkTextSec : AppTheme.textLight)),
    );
  }
}

class _StudentsTab
    extends StatelessWidget {
  @override
  Widget build(
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Text('Students list',
          style: TextStyle(
              color: isDark ? AppTheme.darkTextSec : AppTheme.textLight)),
    );
  }
}

class _AdminRow
    extends StatelessWidget {
  final String name;
  final String id;
  final String tag;
  final String issue;
  final String date;

  const _AdminRow({
    required this.name,
    required this.id,
    required this.tag,
    required this.issue,
    required this.date,
  });

  @override
  Widget build(
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBg2 : AppTheme.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(name,
                    style: TextStyle(
                        fontWeight:
                            FontWeight
                                .w600,
                        fontSize:
                            13,
                        color: txt)),
                Text(id,
                    style: TextStyle(
                        fontSize:
                            11,
                        color: txtSec)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets
                    .symmetric(
                    horizontal: 6,
                    vertical: 3),
            decoration:
                BoxDecoration(
              color: AppTheme
                  .primaryLight,
              borderRadius:
                  BorderRadius
                      .circular(4),
            ),
            child: Text(tag,
                style: const TextStyle(
                    fontSize: 9,
                    fontWeight:
                        FontWeight
                            .w700,
                    color: AppTheme
                        .primary)),
          ),
          const SizedBox(width: 8),
          Text(issue,
              style: TextStyle(
                  fontSize: 12,
                  color: txt)),
          const SizedBox(width: 8),
          Text(date,
              style: TextStyle(
                  fontSize: 11,
                  color: txtSec)),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(
                Icons.check,
                color: AppTheme
                    .success,
                size: 18),
            onPressed: () {},
            constraints:
                const BoxConstraints(),
            padding:
                EdgeInsets.zero,
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(
                Icons.close,
                color: AppTheme
                    .primary,
                size: 18),
            onPressed: () {},
            constraints:
                const BoxConstraints(),
            padding:
                EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _LogItem
    extends StatelessWidget {
  final Color color;
  final String timeAgo;
  final String actor;
  final String action;

  const _LogItem({
    required this.color,
    required this.timeAgo,
    required this.actor,
    required this.action,
  });

  @override
  Widget build(
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final txtLight = isDark ? AppTheme.darkTextLight : AppTheme.textLight;
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
              BoxDecoration(
                  color: color,
                  shape: BoxShape
                      .circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Text(timeAgo,
                  style: TextStyle(
                      fontSize: 10,
                      color: txtLight,
                      fontWeight:
                          FontWeight
                              .w500)),
              Text(actor,
                  style: TextStyle(
                      fontWeight:
                          FontWeight
                              .w600,
                      fontSize: 13,
                      color: txt)),
              Text(action,
                  style: TextStyle(
                      fontSize: 12,
                      color: txtSec)),
            ],
          ),
        ),
      ],
    );
  }
}
