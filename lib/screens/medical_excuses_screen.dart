import 'package:flutter/material.dart';
import '../app_theme.dart';

class MedicalExcusesScreen extends StatelessWidget {
  const MedicalExcusesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.darkBg : AppTheme.background;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final txtLight = isDark ? AppTheme.darkTextLight : AppTheme.textLight;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: card,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Medical Excuses',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700, color: txt)),
            Text('Manage and submit your medical reports',
                style: TextStyle(fontSize: 11, color: txtSec)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () => _showSubmitDialog(context),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('New', style: TextStyle(fontSize: 13)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              style: TextStyle(color: txt),
              decoration: InputDecoration(
                hintText: 'Search excuses...',
                hintStyle: TextStyle(color: txtLight),
                prefixIcon: Icon(Icons.search, color: txtLight),
                suffixIcon: Icon(Icons.filter_list, color: txtLight),
                filled: true,
                fillColor: card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: border),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _ExcuseItem(
                  icon: Icons.description_outlined,
                  title: 'Severe Flu and Fever',
                  date: '15 Oct 2025',
                  status: 'Pending',
                  statusColor: const Color(0xFFFF9100),
                  statusBg: isDark
                      ? const Color(0xFFFF9100).withValues(alpha: 0.12)
                      : const Color(0xFFFFF7ED),
                ),
                const SizedBox(height: 10),
                _ExcuseItem(
                  icon: Icons.description_outlined,
                  title: 'Dental Emergency',
                  date: '05 Oct 2025',
                  status: 'Approved',
                  statusColor: const Color(0xFF00E676),
                  statusBg: isDark
                      ? const Color(0xFF00E676).withValues(alpha: 0.12)
                      : const Color(0xFFE8FDF5),
                ),
                const SizedBox(height: 10),
                _ExcuseItem(
                  icon: Icons.description_outlined,
                  title: 'Food Poisoning',
                  date: '01 Oct 2025',
                  status: 'Rejected',
                  statusColor: const Color(0xFFF44336),
                  statusBg: isDark
                      ? const Color(0xFFF44336).withValues(alpha: 0.12)
                      : const Color(0xFFFFEBEE),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSubmitDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // ✅ FIX: read card color BEFORE opening the sheet so we can pass it
    // as backgroundColor — this fills the entire sheet area uniformly.
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // ✅ KEY FIX: set backgroundColor here so the entire sheet —
      // including the area behind the rounded corners — uses card color.
      backgroundColor: card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          // ✅ No extra Container needed — the sheet itself is already card color
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text('Submit New Excuse',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: txt)),
              const SizedBox(height: 16),
              TextField(
                style: TextStyle(color: txt),
                decoration: InputDecoration(
                  labelText: 'Issue Description',
                  labelStyle: TextStyle(color: txtSec),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: border)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: border)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      const BorderSide(color: AppTheme.primary, width: 2)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                style: TextStyle(color: txt),
                decoration: InputDecoration(
                  labelText: 'Date',
                  labelStyle: TextStyle(color: txtSec),
                  prefixIcon: Icon(Icons.calendar_today_outlined, color: txtSec),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: border)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: border)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      const BorderSide(color: AppTheme.primary, width: 2)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Submit Excuse'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ExcuseItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String status;
  final Color statusColor;
  final Color statusBg;

  const _ExcuseItem({
    required this.icon,
    required this.title,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.statusBg,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final txtLight = isDark ? AppTheme.darkTextLight : AppTheme.textLight;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.primary.withValues(alpha: 0.15)
                  : AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: txt)),
                Row(children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 12, color: txtLight),
                  const SizedBox(width: 4),
                  Text(date,
                      style: TextStyle(fontSize: 12, color: txtSec)),
                ]),
              ],
            ),
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(20),
              border:
              Border.all(color: statusColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  status == 'Approved'
                      ? Icons.check_circle_outline
                      : status == 'Rejected'
                      ? Icons.cancel_outlined
                      : Icons.access_time_outlined,
                  size: 13,
                  color: statusColor,
                ),
                const SizedBox(width: 4),
                Text(status,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}