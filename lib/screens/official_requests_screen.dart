import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_theme.dart';
import '../data/models/official_request_model.dart';
import '../data/services/official_request_service.dart';

class OfficialRequestsScreen extends StatefulWidget {
  const OfficialRequestsScreen({super.key});

  @override
  State<OfficialRequestsScreen> createState() => _OfficialRequestsScreenState();
}

class _OfficialRequestsScreenState extends State<OfficialRequestsScreen> {
  List<OfficialRequestModel> _requests = [];
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    try {
      final service = context.read<OfficialRequestService>();
      final list = await service.getMyOfficialRequests();
      if (mounted) setState(() => _requests = list);
    } catch (e) {
      if (mounted) setState(() => _loadError = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showConfirmDialog(String title, String price, String processing) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Request Document'),
        content: Text('Are you sure you want to request "$title"?\n\nPrice: $price\nProcessing: $processing'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _submitRequest(title);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitRequest(String documentTitle) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final service = context.read<OfficialRequestService>();
      await service.submitRequest(documentTitle: documentTitle);
      
      if (mounted) {
        Navigator.pop(context); // close loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request submitted successfully!'),
            backgroundColor: Color(0xFF00C853),
          ),
        );
        _loadRequests();
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // close loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: const Color(0xFFF44336),
          ),
        );
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

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: card,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Official Requests',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: txt)),
            Text('Order certificates and academic documents',
                style: TextStyle(fontSize: 11, color: txtSec)),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadRequests,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Available Documents',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: txt)),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _DocumentCard(
                      title: 'Enrolment Certificate',
                      price: '100 EGP',
                      processing: '1-2 Days',
                      onTap: () => _showConfirmDialog('Enrolment Certificate', '100 EGP', '1-2 Days'),
                  ),
                  _DocumentCard(
                      title: 'Official Transcript',
                      price: '250 EGP',
                      processing: '3-5 Days',
                      onTap: () => _showConfirmDialog('Official Transcript', '250 EGP', '3-5 Days'),
                  ),
                  _DocumentCard(
                      title: 'ID Card Replacement',
                      price: '150 EGP',
                      processing: 'Same Day',
                      onTap: () => _showConfirmDialog('ID Card Replacement', '150 EGP', 'Same Day'),
                  ),
                  _DocumentCard(
                      title: 'Course Description',
                      price: '50 EGP',
                      processing: '1-2 Days',
                      onTap: () => _showConfirmDialog('Course Description', '50 EGP', '1-2 Days'),
                  ),
                  _DocumentCard(
                      title: 'Military Service Form',
                      price: 'Free',
                      processing: '2 Days',
                      onTap: () => _showConfirmDialog('Military Service Form', 'Free', '2 Days'),
                  ),
                  _DocumentCard(
                      title: 'Graduation Statement',
                      price: '300 EGP',
                      processing: '5 Days',
                      onTap: () => _showConfirmDialog('Graduation Statement', '300 EGP', '5 Days'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Text('Recent Orders',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: txt)),
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
              else if (_requests.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('No documents requested yet.', style: TextStyle(color: txtSec)),
                  ),
                )
              else
                ..._requests.map((req) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _OrderItem(request: req),
                  );
                }),
                
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Track Outside Requests?',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    const Text(
                      'If you requested documents from the campus office, you can track their status using your request ID.',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.5),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'ID: REQ-000',
                              hintStyle: const TextStyle(
                                  color: Colors.white54, fontSize: 13),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Track',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final String title;
  final String price;
  final String processing;
  final VoidCallback onTap;

  const _DocumentCard({
    required this.title,
    required this.price,
    required this.processing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final txtLight = isDark ? AppTheme.darkTextLight : AppTheme.textLight;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;

    final isFree = price == 'Free';
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.primary.withValues(alpha: 0.15)
                        : AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.description_outlined,
                      color: AppTheme.primary, size: 18),
                ),
                Text(price,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isFree ? AppTheme.success : AppTheme.primary)),
              ],
            ),
            const Spacer(),
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: txt),
                maxLines: 2),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time_outlined, size: 11, color: txtLight),
                const SizedBox(width: 3),
                Text('Processing: $processing',
                    style: TextStyle(fontSize: 11, color: txtSec)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final OfficialRequestModel request;

  const _OrderItem({required this.request});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;

    final (statusColor, statusBg) = switch (request.status) {
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

    final canDownload = request.status == 'approved';

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.documentName,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: txt)),
                    Text(request.formattedDate,
                        style: TextStyle(fontSize: 12, color: txtSec)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      request.status == 'approved'
                          ? Icons.check_circle
                          : request.status == 'rejected' ? Icons.cancel : Icons.access_time,
                      size: 14,
                      color: statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(request.status.toUpperCase(),
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: statusColor)),
                  ],
                ),
              ),
            ],
          ),
          
          if (request.comment != null && request.comment!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('Note: ${request.comment}', style: TextStyle(color: txtSec, fontSize: 12, fontStyle: FontStyle.italic)),
          ],

          if (canDownload) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading document...')),
                  );
                },
                icon: const Icon(Icons.download_outlined, size: 16),
                label: const Text('Download E-Copy'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: border),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  foregroundColor: txtSec,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
