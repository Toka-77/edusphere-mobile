import 'package:flutter/material.dart';
import '../app_theme.dart';

class OfficialRequestsScreen
    extends StatelessWidget {
  const OfficialRequestsScreen(
      {super.key});

  @override
  Widget build(
      BuildContext context) {
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
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            Text(
                'Official Requests',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight
                            .w700,
                    color: txt)),
            Text(
                'Order certificates and academic documents',
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
            Text(
                'Available Documents',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight
                            .w700,
                    color: txt)),
            const SizedBox(
                height: 12),
            GridView.count(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio:
                  1.2,
              children: const [
                _DocumentCard(
                    title:
                        'Enrolment Certificate',
                    price:
                        '100 EGP',
                    processing:
                        '1-2 Days'),
                _DocumentCard(
                    title:
                        'Official Transcript',
                    price:
                        '250 EGP',
                    processing:
                        '3-5 Days'),
                _DocumentCard(
                    title:
                        'ID Card Replacement',
                    price:
                        '150 EGP',
                    processing:
                        'Same Day'),
                _DocumentCard(
                    title:
                        'Course Description',
                    price:
                        '50 EGP',
                    processing:
                        '1-2 Days'),
                _DocumentCard(
                    title:
                        'Military Service Form',
                    price: 'Free',
                    processing:
                        '2 Days'),
                _DocumentCard(
                    title:
                        'Graduation Statement',
                    price:
                        '300 EGP',
                    processing:
                        '5 Days'),
              ],
            ),
            const SizedBox(
                height: 20),
            Text(
                'Recent Orders',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight
                            .w700,
                    color: txt)),
            const SizedBox(
                height: 12),
            const _OrderItem(
              title:
                  'Official Transcript',
              date: '10 Oct 2025',
              status: 'COMPLETED',
              statusColor:
                  AppTheme.success,
              canDownload: true,
            ),
            const SizedBox(
                height: 10),
            const _OrderItem(
              title:
                  'Enrolment Certificate',
              date: '16 Oct 2025',
              status:
                  'IN PROGRESS',
              statusColor:
                  AppTheme.warning,
            ),
            const SizedBox(
                height: 20),
            Container(
              padding:
                  const EdgeInsets
                      .all(20),
              decoration:
                  BoxDecoration(
                color: AppTheme
                    .primary,
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
                      'Track Outside Requests?',
                      style: TextStyle(
                          color: Colors
                              .white,
                          fontSize:
                              16,
                          fontWeight:
                              FontWeight
                                  .w700)),
                  const SizedBox(
                      height: 6),
                  const Text(
                    'If you requested documents from the campus office, you can track their status using your request ID.',
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
                  Row(
                    children: [
                      Expanded(
                        child:
                            TextField(
                          decoration:
                              InputDecoration(
                            hintText:
                                'ID: REQ-000',
                            hintStyle: const TextStyle(
                                color: Colors.white54,
                                fontSize: 13),
                            filled:
                                true,
                            fillColor: Colors
                                .white
                                .withValues(alpha: 0.15),
                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(10),
                              borderSide:
                                  BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets
                                .symmetric(
                                horizontal: 14,
                                vertical: 12),
                          ),
                          style: const TextStyle(
                              color:
                                  Colors.white),
                        ),
                      ),
                      const SizedBox(
                          width:
                              8),
                      ElevatedButton(
                        onPressed:
                            () {},
                        style: ElevatedButton
                            .styleFrom(
                          backgroundColor:
                              Colors
                                  .white,
                          foregroundColor:
                              AppTheme
                                  .primary,
                          padding: const EdgeInsets
                              .symmetric(
                              horizontal:
                                  16,
                              vertical:
                                  14),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10)),
                        ),
                        child: const Text(
                            'Track',
                            style:
                                TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ],
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

class _DocumentCard
    extends StatelessWidget {
  final String title;
  final String price;
  final String processing;

  const _DocumentCard({
    required this.title,
    required this.price,
    required this.processing,
  });

  @override
  Widget build(
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final txtLight = isDark ? AppTheme.darkTextLight : AppTheme.textLight;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;

    final isFree = price == 'Free';
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding:
            const EdgeInsets.all(
                16),
        decoration: BoxDecoration(
          color: card,
          borderRadius:
              BorderRadius
                  .circular(14),
          border: Border.all(
              color: border),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration:
                      BoxDecoration(
                    color: isDark
                        ? AppTheme.primary.withValues(alpha: 0.15)
                        : AppTheme.primaryLight,
                    borderRadius:
                        BorderRadius
                            .circular(
                                10),
                  ),
                  child: const Icon(
                      Icons
                          .description_outlined,
                      color: AppTheme
                          .primary,
                      size: 18),
                ),
                Text(price,
                    style: TextStyle(
                        fontSize:
                            12,
                        fontWeight:
                            FontWeight
                                .w700,
                        color: isFree
                            ? AppTheme
                                .success
                            : AppTheme
                                .primary)),
              ],
            ),
            const Spacer(),
            Text(title,
                style: TextStyle(
                    fontWeight:
                        FontWeight
                            .w600,
                    fontSize: 13,
                    color: txt),
                maxLines: 2),
            const SizedBox(
                height: 4),
            Row(
              children: [
                Icon(
                    Icons
                        .access_time_outlined,
                    size: 11,
                    color: txtLight),
                const SizedBox(
                    width: 3),
                Text(
                    'Processing: $processing',
                    style: TextStyle(
                        fontSize:
                            11,
                        color: txtSec)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderItem
    extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final Color statusColor;
  final bool canDownload;

  const _OrderItem({
    required this.title,
    required this.date,
    required this.status,
    required this.statusColor,
    this.canDownload = false,
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
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight
                                .w600,
                            fontSize:
                                14,
                            color: txt)),
                    Text(date,
                        style: TextStyle(
                            fontSize:
                                12,
                            color: txtSec)),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(
                    status ==
                            'COMPLETED'
                        ? Icons
                            .check_circle
                        : Icons
                            .access_time,
                    size: 14,
                    color:
                        statusColor,
                  ),
                  const SizedBox(
                      width: 4),
                  Text(status,
                      style: TextStyle(
                          fontSize:
                              12,
                          fontWeight:
                              FontWeight
                                  .w700,
                          color:
                              statusColor)),
                ],
              ),
            ],
          ),
          if (canDownload) ...[
            const SizedBox(
                height: 10),
            SizedBox(
              width:
                  double.infinity,
              child: OutlinedButton
                  .icon(
                onPressed: () {},
                icon: const Icon(
                    Icons
                        .download_outlined,
                    size: 16),
                label: const Text(
                    'Download E-Copy'),
                style:
                    OutlinedButton
                        .styleFrom(
                  side: BorderSide(
                      color: border),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                                  10)),
                  foregroundColor: txtSec,
                  padding:
                      const EdgeInsets
                          .symmetric(
                          vertical:
                              10),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
