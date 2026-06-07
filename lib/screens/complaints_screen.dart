import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../app_theme.dart';
import '../data/models/complaint_model.dart';
import '../data/services/complaint_service.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  String _selectedCategory = 'Academic';
  final _messageController = TextEditingController();
  
  final _picker = ImagePicker();
  XFile? _pickedImage;
  
  bool _isSubmitting = false;
  String? _submitError;

  List<ComplaintModel> _complaints = [];
  bool _isLoading = true;
  String? _loadError;

  final categories = [
    'Academic',
    'Facilities',
    'Financial',
    'Administrative'
  ];

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadComplaints() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    try {
      final service = context.read<ComplaintService>();
      final list = await service.getMyComplaints();
      if (mounted) setState(() => _complaints = list);
    } catch (e) {
      if (mounted) setState(() => _loadError = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (file != null) {
      setState(() => _pickedImage = file);
    }
  }

  Future<void> _submit() async {
    final msg = _messageController.text.trim();
    if (msg.isEmpty) {
      setState(() => _submitError = 'Please describe your issue.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      final service = context.read<ComplaintService>();
      await service.submitComplaint(
        category: _selectedCategory,
        message: msg,
        attachment: _pickedImage,
      );
      
      if (mounted) {
        _messageController.clear();
        _pickedImage = null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Complaint submitted successfully!'),
            backgroundColor: Color(0xFF00C853),
          ),
        );
        _loadComplaints();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _submitError = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
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
            Text('Complaints',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: txt)),
            Text('Voice your concerns anonymously or officially',
                style: TextStyle(fontSize: 11, color: txtSec)),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadComplaints,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // New Complaint Form
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.send_outlined,
                            color: AppTheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text('New Complaint',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: txt)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Category',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: txtSec)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((cat) {
                        final selected = _selectedCategory == cat;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected ? AppTheme.primary : card,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected ? AppTheme.primary : border,
                              ),
                            ),
                            child: Text(cat,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: selected ? Colors.white : txtSec)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text('Your Message',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: txtSec)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _messageController,
                      maxLines: 5,
                      style: TextStyle(color: txt),
                      decoration: InputDecoration(
                        hintText: 'Describe your issue in detail...',
                        hintStyle: TextStyle(color: txtLight, fontSize: 13),
                        filled: true,
                        fillColor:
                            isDark ? AppTheme.darkBg2 : AppTheme.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: border),
                        ),
                      ),
                    ),
                    
                    if (_pickedImage != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.image, size: 16, color: AppTheme.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _pickedImage!.name,
                              style: TextStyle(fontSize: 12, color: txtSec),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () => setState(() => _pickedImage = null),
                          )
                        ],
                      ),
                    ],

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

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isSubmitting ? null : _submit,
                            icon: _isSubmitting 
                                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Icon(Icons.send, size: 16),
                            label: const Text('Submit Complaint'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: _pickImage,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: border),
                          ),
                          child: Icon(Icons.attach_file, color: txtSec),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'All complaints are treated with strict confidentiality and will be addressed within 3-5 working days.',
                      style: TextStyle(
                          fontSize: 11,
                          color: txtLight,
                          fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Complaint History
              Row(
                children: [
                  Icon(Icons.history, size: 18, color: txtSec),
                  const SizedBox(width: 6),
                  Text('Complaint History',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: txt)),
                ],
              ),
              const SizedBox(height: 12),
              
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_loadError != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('Failed to load history', style: TextStyle(color: txtSec)),
                  ),
                )
              else if (_complaints.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('No complaints submitted yet.', style: TextStyle(color: txtSec)),
                  ),
                )
              else
                ..._complaints.map((c) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _HistoryItem(complaint: c),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final ComplaintModel complaint;

  const _HistoryItem({required this.complaint});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;

    final (statusColor, statusBg) = switch (complaint.status) {
      'approved' => (
          const Color(0xFF00E676),
          isDark
              ? const Color(0xFF00E676).withValues(alpha: 0.12)
              : const Color(0xFFE8FDF5),
        ),
      'rejected' => (
          const Color(0xFFF44336),
          isDark
              ? const Color(0xFFF44336).withValues(alpha: 0.12)
              : const Color(0xFFFFEBEE),
        ),
      _ => (
          const Color(0xFFFF9100),
          isDark
              ? const Color(0xFFFF9100).withValues(alpha: 0.12)
              : const Color(0xFFFFF7ED),
        ),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_outlined,
                  color: AppTheme.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(complaint.category,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: txt)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  complaint.status.toUpperCase(),
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('Submitted on ${complaint.formattedDate}',
              style: TextStyle(fontSize: 12, color: txtSec)),
          
          const SizedBox(height: 8),
          Text(complaint.message,
              style: TextStyle(fontSize: 13, color: txt)),
              
          if (complaint.comment != null && complaint.comment!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkBg2 : AppTheme.background,
                borderRadius: BorderRadius.circular(8),
                border: const Border(
                    left: BorderSide(color: AppTheme.success, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('OFFICIAL RESPONSE',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.success,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text('"${complaint.comment}"',
                      style: TextStyle(
                          fontSize: 12,
                          color: txtSec,
                          fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
