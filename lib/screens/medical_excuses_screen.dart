import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../app_theme.dart';
import '../data/services/medical_excuse_service.dart';
import '../data/models/medical_excuse_model.dart';

class MedicalExcusesScreen extends StatefulWidget {
  const MedicalExcusesScreen({super.key});

  @override
  State<MedicalExcusesScreen> createState() => _MedicalExcusesScreenState();
}

class _MedicalExcusesScreenState extends State<MedicalExcusesScreen> {
  List<MedicalExcuseModel> _excuses = [];
  bool _isLoading = true;
  String? _error;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _loadExcuses();
  }

  Future<void> _loadExcuses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final service = context.read<MedicalExcuseService>();
      final list = await service.getMyExcuses();
      if (mounted) setState(() => _excuses = list);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<MedicalExcuseModel> get _filtered {
    if (_search.isEmpty) return _excuses;
    final q = _search.toLowerCase();
    return _excuses
        .where((e) => e.details.toLowerCase().contains(q))
        .toList();
  }

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search excuses...',
                hintStyle: TextStyle(color: txtLight),
                prefixIcon: Icon(Icons.search, color: txtLight),
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
          Expanded(child: _buildBody(isDark, txt, txtSec, border)),
        ],
      ),
    );
  }

  Widget _buildBody(
      bool isDark, Color txt, Color txtSec, Color border) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 48, color: const Color(0xFFF44336)),
            const SizedBox(height: 12),
            Text('Failed to load excuses',
                style: TextStyle(color: txt, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextButton.icon(
              onPressed: _loadExcuses,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (_filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 56, color: AppTheme.primary.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text('No excuses found',
                style: TextStyle(color: txt, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Tap "+ New" to submit your first excuse',
                style: TextStyle(color: txtSec, fontSize: 12)),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadExcuses,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: _filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _ExcuseItem(excuse: _filtered[i]),
      ),
    );
  }

  void _showSubmitDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _SubmitExcuseSheet(
        onSubmitted: _loadExcuses,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stateful bottom-sheet
// ---------------------------------------------------------------------------
class _SubmitExcuseSheet extends StatefulWidget {
  final VoidCallback onSubmitted;
  const _SubmitExcuseSheet({required this.onSubmitted});

  @override
  State<_SubmitExcuseSheet> createState() => _SubmitExcuseSheetState();
}

class _SubmitExcuseSheetState extends State<_SubmitExcuseSheet> {
  final _descController = TextEditingController();
  final _detailsController = TextEditingController();
  final _picker = ImagePicker();
  XFile? _pickedImage;
  bool _isSubmitting = false;
  String? _submitError;

  @override
  void dispose() {
    _descController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (file != null) {
      setState(() => _pickedImage = file);
    }
  }

  void _showImageSourceSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;

    showModalBottomSheet(
      context: context,
      backgroundColor: card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.camera_alt_outlined,
                      color: AppTheme.primary),
                ),
                title: Text('Take a Photo', style: TextStyle(color: txt)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.photo_library_outlined,
                      color: AppTheme.primary),
                ),
                title:
                    Text('Choose from Gallery', style: TextStyle(color: txt)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_pickedImage != null)
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF44336).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.delete_outline,
                        color: Color(0xFFF44336)),
                  ),
                  title: const Text('Remove Image',
                      style: TextStyle(color: Color(0xFFF44336))),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _pickedImage = null);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final desc = _descController.text.trim();
    final details = _detailsController.text.trim();

    if (desc.isEmpty) {
      setState(() => _submitError = 'Please enter a description & reason.');
      return;
    }
    if (details.isEmpty) {
      setState(() => _submitError = 'Please enter details / notes.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      final service = context.read<MedicalExcuseService>();
      await service.submitExcuse(
        description: desc,
        details: details,
        imageFile: _pickedImage,
      );
      if (mounted) {
        Navigator.pop(context);
        widget.onSubmitted();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Medical excuse submitted successfully!'),
            backgroundColor: Color(0xFF00C853),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _submitError = e.toString().replaceFirst('Exception: ', '');
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: border),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppTheme.primary, width: 2),
    );

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
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

            // Description & Reason
            TextField(
              controller: _descController,
              style: TextStyle(color: txt),
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Description & Reason *',
                alignLabelWithHint: true,
                labelStyle: TextStyle(color: txtSec),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: focusedBorder,
              ),
            ),
            const SizedBox(height: 12),

            // Details / Notes
            TextField(
              controller: _detailsController,
              style: TextStyle(color: txt),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'DETAILS / NOTES',
                alignLabelWithHint: true,
                labelStyle: TextStyle(color: txtSec),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: focusedBorder,
              ),
            ),
            const SizedBox(height: 16),

            // ── Image attachment area ─────────────────────────────────────
            Text('Attach Image',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: txt)),
            const SizedBox(height: 8),

            if (_pickedImage == null)
              GestureDetector(
                onTap: _showImageSourceSheet,
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.primary.withValues(alpha: 0.07)
                        : AppTheme.primaryLight.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.35),
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_outlined,
                          color: AppTheme.primary, size: 32),
                      const SizedBox(height: 8),
                      Text('Tap to upload medical report',
                          style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('Camera or Gallery',
                          style: TextStyle(color: txtSec, fontSize: 11)),
                    ],
                  ),
                ),
              )
            else
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: kIsWeb
                        ? Image.network(
                            _pickedImage!.path,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(_pickedImage!.path),
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Row(
                      children: [
                        _ImageActionBtn(
                          icon: Icons.edit_outlined,
                          label: 'Change',
                          onTap: _showImageSourceSheet,
                        ),
                        const SizedBox(width: 6),
                        _ImageActionBtn(
                          icon: Icons.delete_outline,
                          label: 'Remove',
                          isDestructive: true,
                          onTap: () =>
                              setState(() => _pickedImage = null),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            // Error message
            if (_submitError != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF44336).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFFF44336).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Color(0xFFF44336), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(_submitError!,
                          style: const TextStyle(
                              color: Color(0xFFF44336), fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Submit Excuse'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Small action button shown over image preview
class _ImageActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ImageActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFF44336) : Colors.white;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Excuse list item — data-driven from API
// ---------------------------------------------------------------------------
class _ExcuseItem extends StatelessWidget {
  final MedicalExcuseModel excuse;

  const _ExcuseItem({required this.excuse});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final txtLight = isDark ? AppTheme.darkTextLight : AppTheme.textLight;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;

    final (statusColor, statusBg, statusIcon) = switch (excuse.status) {
      'approved' => (
          const Color(0xFF00E676),
          isDark
              ? const Color(0xFF00E676).withValues(alpha: 0.12)
              : const Color(0xFFE8FDF5),
          Icons.check_circle_outline,
        ),
      'rejected' => (
          const Color(0xFFF44336),
          isDark
              ? const Color(0xFFF44336).withValues(alpha: 0.12)
              : const Color(0xFFFFEBEE),
          Icons.cancel_outlined,
        ),
      _ => (
          const Color(0xFFFF9100),
          isDark
              ? const Color(0xFFFF9100).withValues(alpha: 0.12)
              : const Color(0xFFFFF7ED),
          Icons.access_time_outlined,
        ),
    };

    // Show a trimmed preview of the details
    final preview = excuse.details.length > 60
        ? '${excuse.details.substring(0, 60)}...'
        : excuse.details;

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
            child: const Icon(Icons.description_outlined,
                color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(preview,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: txt)),
                Row(children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 12, color: txtLight),
                  const SizedBox(width: 4),
                  Text(excuse.formattedDate,
                      style: TextStyle(fontSize: 12, color: txtSec)),
                ]),
              ],
            ),
          ),
          const SizedBox(width: 8),
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
                Icon(statusIcon, size: 13, color: statusColor),
                const SizedBox(width: 4),
                Text(
                  excuse.status[0].toUpperCase() +
                      excuse.status.substring(1),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}