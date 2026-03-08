import 'package:flutter/material.dart';
import '../app_theme.dart';

class ComplaintsScreen
    extends StatefulWidget {
  const ComplaintsScreen(
      {super.key});

  @override
  State<ComplaintsScreen>
      createState() =>
          _ComplaintsScreenState();
}

class _ComplaintsScreenState
    extends State<
        ComplaintsScreen> {
  String _selectedCategory =
      'Academic';
  final _messageController =
      TextEditingController();

  final categories = [
    'Academic',
    'Facilities',
    'Financial',
    'Administrative'
  ];

  @override
  Widget build(
      BuildContext context) {
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
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            Text('Complaints',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight
                            .w700,
                    color: txt)),
            Text(
                'Voice your concerns anonymously or officially',
                style: TextStyle(
                    fontSize: 11,
                    color: txtSec)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(
                16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            // New Complaint Form
            Container(
              padding:
                  const EdgeInsets
                      .all(20),
              decoration:
                  BoxDecoration(
                color: card,
                borderRadius:
                    BorderRadius
                        .circular(
                            20),
                border: Border.all(
                    color: border),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Row(
                    children: [
                      const Icon(
                          Icons
                              .send_outlined,
                          color: AppTheme
                              .primary,
                          size:
                              20),
                      const SizedBox(
                          width:
                              8),
                      Text(
                          'New Complaint',
                          style: TextStyle(
                              fontSize:
                                  17,
                              fontWeight: FontWeight
                                  .w700,
                              color: txt)),
                    ],
                  ),
                  const SizedBox(
                      height: 16),
                  Text(
                      'Category',
                      style: TextStyle(
                          fontSize:
                              13,
                          fontWeight:
                              FontWeight
                                  .w600,
                          color: txtSec)),
                  const SizedBox(
                      height: 10),
                  Wrap(
                    spacing: 8,
                    children:
                        categories.map(
                            (cat) {
                      final selected =
                          _selectedCategory ==
                              cat;
                      return GestureDetector(
                        onTap: () =>
                            setState(() =>
                                _selectedCategory = cat),
                        child:
                            Container(
                          padding: const EdgeInsets
                              .symmetric(
                              horizontal:
                                  14,
                              vertical:
                                  8),
                          decoration:
                              BoxDecoration(
                            color: selected
                                ? AppTheme.primary
                                : card,
                            borderRadius:
                                BorderRadius.circular(20),
                            border:
                                Border.all(
                              color: selected
                                  ? AppTheme.primary
                                  : border,
                            ),
                          ),
                          child: Text(
                              cat,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: selected ? Colors.white : txtSec)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                      height: 16),
                  Text(
                      'Your Message',
                      style: TextStyle(
                          fontSize:
                              13,
                          fontWeight:
                              FontWeight
                                  .w600,
                          color: txtSec)),
                  const SizedBox(
                      height: 8),
                  TextField(
                    controller:
                        _messageController,
                    maxLines: 5,
                    style: TextStyle(color: txt),
                    decoration:
                        InputDecoration(
                      hintText:
                          'Describe your issue in detail...',
                      hintStyle: TextStyle(
                          color: txtLight,
                          fontSize:
                              13),
                      filled: true,
                      fillColor: isDark
                          ? AppTheme.darkBg2
                          : AppTheme.background,
                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                12),
                        borderSide:
                            BorderSide(
                                color: border),
                      ),
                      enabledBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                12),
                        borderSide:
                            BorderSide(
                                color: border),
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton
                            .icon(
                          onPressed:
                              () {},
                          icon: const Icon(
                              Icons
                                  .send,
                              size:
                                  16),
                          label: const Text(
                              'Submit Complaint'),
                        ),
                      ),
                      const SizedBox(
                          width:
                              8),
                      OutlinedButton(
                        onPressed:
                            () {},
                        style: OutlinedButton
                            .styleFrom(
                          padding: const EdgeInsets
                              .symmetric(
                              horizontal:
                                  14,
                              vertical:
                                  14),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12)),
                          side: BorderSide(
                              color: border),
                        ),
                        child: Icon(
                            Icons
                                .attach_file,
                            color: txtSec),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 12),
                  Text(
                    'All complaints are treated with strict confidentiality and will be addressed within 3-5 working days.',
                    style: TextStyle(
                        fontSize:
                            11,
                        color: txtLight,
                        fontStyle:
                            FontStyle
                                .italic),
                    textAlign:
                        TextAlign
                            .center,
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 20),

            // Complaint History
            Row(
              children: [
                Icon(Icons.history,
                    size: 18,
                    color: txtSec),
                const SizedBox(width: 6),
                Text(
                    'Complaint History',
                    style: TextStyle(
                        fontSize:
                            17,
                        fontWeight:
                            FontWeight
                                .w700,
                        color: txt)),
              ],
            ),
            const SizedBox(
                height: 12),
            const _HistoryItem(
              icon: Icons
                  .description_outlined,
              iconColor:
                  AppTheme.primary,
              title:
                  'Library Noise Level',
              submittedDate:
                  'Submitted on 20 Sep 2025',
              status: 'RESOLVED',
              statusColor:
                  AppTheme.success,
              response:
                  'Security has been notified to patrol the quiet zones more frequently.',
            ),
            const SizedBox(
                height: 10),
            const _HistoryItem(
              icon: Icons
                  .description_outlined,
              iconColor:
                  AppTheme.primary,
              title:
                  'Portal Login Issue',
              submittedDate:
                  'Submitted on 15 Sep 2025',
              status: 'PENDING',
              statusColor:
                  AppTheme.warning,
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryItem
    extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String submittedDate;
  final String status;
  final Color statusColor;
  final String? response;

  const _HistoryItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.submittedDate,
    required this.status,
    required this.statusColor,
    this.response,
  });

  @override
  Widget build(
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;

    return Container(
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius:
            BorderRadius.circular(
                14),
        border: Border.all(
            color: border),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Row(
            children: [
              Icon(icon,
                  color: iconColor,
                  size: 20),
              const SizedBox(
                  width: 8),
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        fontWeight:
                            FontWeight
                                .w600,
                        fontSize:
                            14,
                        color: txt)),
              ),
              Container(
                padding:
                    const EdgeInsets
                        .symmetric(
                        horizontal:
                            8,
                        vertical:
                            4),
                decoration:
                    BoxDecoration(
                  color: statusColor
                      .withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius
                          .circular(
                              6),
                ),
                child: Text(status,
                    style: TextStyle(
                        fontSize:
                            11,
                        fontWeight:
                            FontWeight
                                .w700,
                        color:
                            statusColor)),
              ),
            ],
          ),
          const SizedBox(
              height: 6),
          Text(submittedDate,
              style: TextStyle(
                  fontSize: 12,
                  color: txtSec)),
          if (response !=
              null) ...[
            const SizedBox(
                height: 10),
            Container(
              padding:
                  const EdgeInsets
                      .all(12),
              decoration:
                  BoxDecoration(
                color: isDark
                    ? AppTheme.darkBg2
                    : AppTheme.background,
                borderRadius:
                    BorderRadius
                        .circular(
                            8),
                border: const Border(
                    left: BorderSide(
                        color: AppTheme
                            .success,
                        width: 3)),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  const Text(
                      'OFFICIAL RESPONSE',
                      style: TextStyle(
                          fontSize:
                              10,
                          fontWeight:
                              FontWeight
                                  .w700,
                          color: AppTheme
                              .success,
                          letterSpacing:
                              0.5)),
                  const SizedBox(
                      height: 4),
                  Text(
                      '"$response"',
                      style: TextStyle(
                          fontSize:
                              12,
                          color: txtSec,
                          fontStyle:
                              FontStyle
                                  .italic)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
