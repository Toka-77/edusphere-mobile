import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'home_screen.dart';
import 'medical_excuses_screen.dart';
import 'complaints_screen.dart';
import 'academic_warnings_screen.dart';
import 'official_requests_screen.dart';

class StudentServicesScreen
    extends StatelessWidget {
  const StudentServicesScreen(
      {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.darkBg : AppTheme.background;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final card = isDark ? AppTheme.darkCard : Colors.white;
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
            Text('Student Services',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: txt)),
            Text('Manage your academic requests & needs',
                style: TextStyle(fontSize: 11, color: txtSec)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(
            16),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                // Medical — web: #26c6da (cyan)
                _ServiceCard(
                  icon: Icons.medical_services_outlined,
                  iconColor: const Color(0xFF26C6DA),
                  iconBg: const Color(0xFF26C6DA).withValues(alpha: 0.12),
                  title: 'Medical Excuse',
                  description:
                  'Submit and track your medical excuses for missed classes.',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MedicalExcusesScreen())),
                ),
                // Complaints — web: #ff9100 (orange)
                _ServiceCard(
                  icon: Icons.feedback_outlined,
                  iconColor: const Color(0xFFFF9100),
                  iconBg: const Color(0xFFFF9100).withValues(alpha: 0.12),
                  title: 'Complaints',
                  description:
                  'Submit academic or general complaints to the administration.',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ComplaintsScreen())),
                ),
                // Warning — web: #ffd600 (yellow)
                _ServiceCard(
                  icon: Icons.warning_amber_outlined,
                  iconColor: const Color(0xFFFFD600),
                  iconBg: const Color(0xFFFFD600).withValues(alpha: 0.12),
                  title: 'Warning',
                  description:
                  'View any academic warnings or attendance notifications.',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AcademicWarningsScreen())),
                ),
                // Requests — web: #aa00ff (purple)
                _ServiceCard(
                  icon: Icons.help_outline,
                  iconColor: const Color(0xFFAA00FF),
                  iconBg: const Color(0xFFAA00FF).withValues(alpha: 0.12),
                  title: 'Requests',
                  description:
                  'Submit general requests for certificates and documents.',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const OfficialRequestsScreen())),
                ),
              ],
            ),
            const SizedBox(
                height: 16),
            Container(
              padding:
              const EdgeInsets
                  .all(20),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkCard : AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                            "Can't find what you're looking for?",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: txt)),
                        const SizedBox(
                            height:
                            4),
                        Text(
                            'Our student affairs office is ready to help you.',
                            style: TextStyle(
                                fontSize: 12,
                                color: txtSec)),
                      ],
                    ),
                  ),
                  const SizedBox(
                      width: 12),
                  ElevatedButton(
                    onPressed:
                        () {},
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets
                            .symmetric(
                            horizontal:
                            12,
                            vertical:
                            10)),
                    child: const Text(
                        'Contact',
                        style: TextStyle(
                            fontSize:
                            12)),
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

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String title, description;
  final VoidCallback onTap;
  const _ServiceCard(
      {required this.icon,
        required this.iconColor,
        required this.iconBg,
        required this.title,
        required this.description,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 10),
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: txt)),
            const SizedBox(height: 4),
            Expanded(
              child: Text(description,
                  style: TextStyle(fontSize: 11, color: txtSec),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
