import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'home_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w700, color: txt)),
            Text('Manage university services',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Stats grid ─────────────────────────────────────────
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _StatBox(
                    icon: Icons.people_outline,
                    iconColor: AppTheme.info,
                    label: 'Total Students',
                    value: '2,450',
                    card: card,
                    border: border,
                    txt: txt,
                    txtSec: txtSec),
                _StatBox(
                    icon: Icons.description_outlined,
                    iconColor: AppTheme.warning,
                    label: 'Pending Excuses',
                    value: '18',
                    card: card,
                    border: border,
                    txt: txt,
                    txtSec: txtSec),
                _StatBox(
                    icon: Icons.chat_bubble_outline,
                    iconColor: AppTheme.primary,
                    label: 'New Complaints',
                    value: '5',
                    card: card,
                    border: border,
                    txt: txt,
                    txtSec: txtSec),
                _StatBox(
                    icon: Icons.warning_amber_outlined,
                    iconColor: AppTheme.orange,
                    label: 'Warnings Issued',
                    value: '12',
                    card: card,
                    border: border,
                    txt: txt,
                    txtSec: txtSec),
              ],
            ),
            const SizedBox(height: 20),

            // ── Tabs card ──────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      unselectedLabelColor: txtSec,
                      indicator: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelStyle: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700),
                      unselectedLabelStyle: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                      tabs: const [
                        Tab(text: 'Medical'),
                        Tab(text: 'Complaints'),
                        Tab(text: 'Students'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 280,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _MedicalExcusesTab(
                            card: card,
                            border: border,
                            txt: txt,
                            txtSec: txtSec),
                        _ComplaintsTab(txtSec: txtSec),
                        _StudentsTab(txtSec: txtSec),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Recent Logs ────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history, size: 18, color: txtSec),
                      const SizedBox(width: 8),
                      Text('Recent Logs',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: txt)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _LogItem(
                      color: AppTheme.success,
                      timeAgo: '2M AGO',
                      actor: 'Admin Sarah',
                      action: 'Approved Excuse #092',
                      txt: txt,
                      txtSec: txtSec),
                  const SizedBox(height: 10),
                  _LogItem(
                      color: AppTheme.warning,
                      timeAgo: '1H AGO',
                      actor: 'System',
                      action: 'Issued Warning (Attendance)',
                      txt: txt,
                      txtSec: txtSec),
                  const SizedBox(height: 10),
                  _LogItem(
                      color: AppTheme.info,
                      timeAgo: '3H AGO',
                      actor: 'Admin Mike',
                      action: 'Responded to Complaint',
                      txt: txt,
                      txtSec: txtSec),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text('View All Activity Logs',
                          style: TextStyle(color: txtSec, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── University Policy Card ─────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('University Policy',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  const Text(
                    'Administrative actions must comply with the 2026 EduSphere Academic Charter.',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 12, height: 1.5),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white30),
                    ),
                    child: const Text('Download Charter'),
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

// ── Inline stat box ───────────────────────────────────────────────

class _StatBox extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color card;
  final Color border;
  final Color txt;
  final Color txtSec;

  const _StatBox({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.card,
    required this.border,
    required this.txt,
    required this.txtSec,
  });

  @override
  Widget build(BuildContext context) {
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
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800, color: txt)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(fontSize: 11, color: txtSec),
              overflow: TextOverflow.ellipsis,
              maxLines: 1),
        ],
      ),
    );
  }
}

// ── Medical Excuses Tab ───────────────────────────────────────────

class _MedicalExcusesTab extends StatelessWidget {
  final Color card;
  final Color border;
  final Color txt;
  final Color txtSec;

  const _MedicalExcusesTab({
    required this.card,
    required this.border,
    required this.txt,
    required this.txtSec,
  });

  @override
  Widget build(BuildContext context) {
    final rows = [
      {
        'name': 'Ahmed Ali',
        'id': '223001',
        'issue': 'Severe Flu',
        'date': '15 Oct'
      },
      {
        'name': 'Sarah Smith',
        'id': '223045',
        'issue': 'Medical Surgery',
        'date': '14 Oct'
      },
      {
        'name': 'Omar Hassan',
        'id': '224112',
        'issue': 'Dental Apt.',
        'date': '14 Oct'
      },
    ];
    return ListView(
      padding: const EdgeInsets.all(10),
      children: rows
          .map((r) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: _AdminRow(
          name: r['name']!,
          id: 'ID: ${r['id']}',
          issue: r['issue']!,
          date: r['date']!,
          border: border,
          txt: txt,
          txtSec: txtSec,
        ),
      ))
          .toList(),
    );
  }
}

// ── Complaints Tab ────────────────────────────────────────────────

class _ComplaintsTab extends StatelessWidget {
  final Color txtSec;
  const _ComplaintsTab({required this.txtSec});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
      Text('No new complaints', style: TextStyle(color: txtSec)),
    );
  }
}

// ── Students Tab ──────────────────────────────────────────────────

class _StudentsTab extends StatelessWidget {
  final Color txtSec;
  const _StudentsTab({required this.txtSec});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
      Text('Students list coming soon', style: TextStyle(color: txtSec)),
    );
  }
}

// ── Admin Row — fixed overflow + working 3-dot menu ───────────────

class _AdminRow extends StatelessWidget {
  final String name;
  final String id;
  final String issue;
  final String date;
  final Color border;
  final Color txt;
  final Color txtSec;

  const _AdminRow({
    required this.name,
    required this.id,
    required this.issue,
    required this.date,
    required this.border,
    required this.txt,
    required this.txtSec,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBg2 : AppTheme.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          // Avatar circle with initial
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0] : '?',
                style: const TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Name + details — Expanded prevents overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: txt),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                Text('$id · $issue',
                    style: TextStyle(fontSize: 11, color: txtSec),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // Date label
          Text(date, style: TextStyle(fontSize: 11, color: txtSec)),
          // ✅ Working 3-dot menu
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, size: 18, color: txtSec),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            onSelected: (v) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$v — $name'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'Approve',
                child: Row(children: [
                  Icon(Icons.check_circle_outline,
                      color: AppTheme.success, size: 18),
                  SizedBox(width: 10),
                  Text('Approve'),
                ]),
              ),
              PopupMenuItem(
                value: 'Reject',
                child: Row(children: [
                  Icon(Icons.cancel_outlined,
                      color: AppTheme.primary, size: 18),
                  SizedBox(width: 10),
                  Text('Reject'),
                ]),
              ),
              PopupMenuItem(
                value: 'View Details',
                child: Row(children: [
                  Icon(Icons.open_in_new_outlined, size: 18),
                  SizedBox(width: 10),
                  Text('View Details'),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Log Item ──────────────────────────────────────────────────────

class _LogItem extends StatelessWidget {
  final Color color;
  final String timeAgo;
  final String actor;
  final String action;
  final Color txt;
  final Color txtSec;

  const _LogItem({
    required this.color,
    required this.timeAgo,
    required this.actor,
    required this.action,
    required this.txt,
    required this.txtSec,
  });

  @override
  Widget build(BuildContext context) {
    final txtLight = Theme.of(context).brightness == Brightness.dark
        ? AppTheme.darkTextLight
        : AppTheme.textLight;
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
          BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(timeAgo,
                  style: TextStyle(
                      fontSize: 10,
                      color: txtLight,
                      fontWeight: FontWeight.w500)),
              Text(actor,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: txt)),
              Text(action,
                  style: TextStyle(fontSize: 12, color: txtSec)),
            ],
          ),
        ),
      ],
    );
  }
}
