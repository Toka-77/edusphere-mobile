import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mobile_scanner/mobile_scanner.dart';
import '../app_theme.dart';
import 'home_screen.dart';

class AttendanceQRScreen
    extends StatefulWidget {
  const AttendanceQRScreen(
      {super.key});

  @override
  State<AttendanceQRScreen>
      createState() =>
          _AttendanceQRScreenState();
}

class _AttendanceQRScreenState
    extends State<
        AttendanceQRScreen> with SingleTickerProviderStateMixin {
  bool _scanning = false;
  bool _scanComplete = false;
  String _scannedData = '';
  late AnimationController _scanLineController;
  MobileScannerController? _cameraController;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  void _startScan() {
    if (kIsWeb) {
      // Web fallback: simulate scan
      _startSimulatedScan();
    } else {
      // Mobile: use real camera
      setState(() {
        _scanning = true;
        _scanComplete = false;
        _scannedData = '';
        _cameraController = MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.back,
        );
      });
    }
  }

  void _startSimulatedScan() {
    setState(() {
      _scanning = true;
      _scanComplete = false;
    });
    _scanLineController.repeat();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _scanLineController.stop();
        setState(() {
          _scanning = false;
          _scanComplete = true;
          _scannedData = 'CS402-LECTURE-2025-10-15';
        });
      }
    });
  }

  void _onQRDetected(BarcodeCapture capture) {
    if (_scanComplete) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode != null && barcode.rawValue != null) {
      _cameraController?.stop();
      setState(() {
        _scanning = false;
        _scanComplete = true;
        _scannedData = barcode.rawValue!;
      });
    }
  }

  void _resetScan() {
    _cameraController?.dispose();
    _cameraController = null;
    setState(() {
      _scanning = false;
      _scanComplete = false;
      _scannedData = '';
    });
  }

  @override
  Widget build(
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.darkBg : AppTheme.background;
    final card = isDark ? AppTheme.darkCard : Colors.white;
    final border = isDark ? AppTheme.darkBorder : AppTheme.border;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final txtLight = isDark ? AppTheme.darkTextLight : AppTheme.textLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: card,
        leading: IconButton(
          icon: Icon(Icons.menu, color: txt),
          onPressed: HomeScreen.openDrawer,
        ),
        title: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            Text('QR Attendance',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight
                            .w700,
                    color: txt)),
            Text(
                'EduSphere Smart Attendance System',
                style: TextStyle(
                    fontSize: 11,
                    color: txtSec)),
          ],
        ),
        actions: [
          Container(
            margin:
                const EdgeInsets
                    .only(
                    right: 12),
            padding:
                const EdgeInsets
                    .symmetric(
                    horizontal: 12,
                    vertical: 6),
            decoration:
                BoxDecoration(
              color: isDark
                  ? AppTheme.primary.withValues(alpha: 0.15)
                  : AppTheme.primaryLight,
              borderRadius:
                  BorderRadius
                      .circular(
                          20),
            ),
            child: const Row(
              children: [
                Icon(
                    Icons
                        .access_time,
                    size: 14,
                    color: AppTheme
                        .primary),
                SizedBox(width: 4),
                Text('04:16 م',
                    style: TextStyle(
                        color: AppTheme
                            .primary,
                        fontSize:
                            12,
                        fontWeight:
                            FontWeight
                                .w600)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(
                16),
        child: Column(
          children: [
            // Lecture Info Card
            Container(
              width:
                  double.infinity,
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
                  Container(
                    padding: const EdgeInsets
                        .symmetric(
                        horizontal:
                            10,
                        vertical:
                            5),
                    decoration:
                        BoxDecoration(
                      color: isDark
                          ? AppTheme.primary.withValues(alpha: 0.15)
                          : AppTheme.primaryLight,
                      borderRadius:
                          BorderRadius
                              .circular(
                                  6),
                    ),
                    child: const Text(
                        'ONGOING LECTURE',
                        style: TextStyle(
                            fontSize:
                                11,
                            fontWeight: FontWeight
                                .w700,
                            color: AppTheme
                                .primary,
                            letterSpacing:
                                0.5)),
                  ),
                  const SizedBox(
                      height: 12),
                  Text(
                      'Advanced Software Engineering',
                      style: TextStyle(
                          fontSize:
                              20,
                          fontWeight:
                              FontWeight
                                  .w700,
                          color: txt)),
                  const SizedBox(
                      height: 4),
                  Text(
                      'CS402 • Dr. Sarah Johnson',
                      style: TextStyle(
                          fontSize:
                              13,
                          color: txtSec)),
                  const SizedBox(
                      height: 16),
                  const _InfoRow(
                    icon: Icons
                        .location_on_outlined,
                    iconColor:
                        AppTheme
                            .primary,
                    label:
                        'Location',
                    value:
                        'Hall 302',
                  ),
                  const SizedBox(
                      height: 10),
                  const _InfoRow(
                    icon: Icons
                        .location_searching,
                    iconColor:
                        AppTheme
                            .warning,
                    label:
                        'GPS Verification',
                    value:
                        'Checking Location...',
                    valueColor:
                        AppTheme
                            .warning,
                  ),
                  const SizedBox(
                      height: 16),
                  Center(
                    child: Column(
                      children: [
                        Text(
                            'Status',
                            style: TextStyle(
                                fontSize: 12,
                                color: txtSec,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(
                            height:
                                4),
                        Text(
                          _scanComplete
                              ? '✅ Attendance Recorded'
                              : _scanning
                                  ? 'Scanning...'
                                  : 'Waiting for scan...',
                          style: TextStyle(
                              fontSize:
                                  15,
                              color: _scanComplete
                                  ? AppTheme.success
                                  : txtLight,
                              fontStyle:
                                  FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 16),

            // Camera View
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Camera or simulated background
                    if (_scanning && !kIsWeb && _cameraController != null)
                      MobileScanner(
                        controller: _cameraController!,
                        onDetect: _onQRDetected,
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: _scanning
                                ? [const Color(0xFF1a1a2e), const Color(0xFF16213e)]
                                : [Colors.black87, Colors.black],
                          ),
                        ),
                      ),

                    // Viewfinder corners (when scanning or idle)
                    if (!_scanComplete) ...[
                      Positioned(
                        top: 40, left: 60,
                        child: _cornerBracket(true, true),
                      ),
                      Positioned(
                        top: 40, right: 60,
                        child: _cornerBracket(true, false),
                      ),
                      Positioned(
                        bottom: 40, left: 60,
                        child: _cornerBracket(false, true),
                      ),
                      Positioned(
                        bottom: 40, right: 60,
                        child: _cornerBracket(false, false),
                      ),
                    ],

                    // Scan line animation (web simulation only)
                    if (_scanning && kIsWeb)
                      AnimatedBuilder(
                        animation: _scanLineController,
                        builder: (context, child) {
                          return Positioned(
                            top: 40 + (_scanLineController.value * 220),
                            left: 60,
                            right: 60,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    AppTheme.primary.withValues(alpha: 0.8),
                                    AppTheme.primary,
                                    AppTheme.primary.withValues(alpha: 0.8),
                                    Colors.transparent,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primary.withValues(alpha: 0.5),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                    // Center content (idle state)
                    if (!_scanning && !_scanComplete)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                                kIsWeb
                                    ? Icons.camera_alt_outlined
                                    : Icons.qr_code_scanner,
                                color: Colors.white,
                                size: 34),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            kIsWeb ? 'Camera Simulation' : 'Camera Ready',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            kIsWeb
                                ? 'Tap "Scan QR Code" to simulate\nan attendance scan'
                                : 'Tap "Scan QR Code" to open\nthe camera and scan',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 13),
                          ),
                        ],
                      ),

                    // Scanning indicator (mobile)
                    if (_scanning && !kIsWeb)
                      Positioned(
                        bottom: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Point at QR code...',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),

                    // Scanning indicator (web)
                    if (_scanning && kIsWeb)
                      const Positioned(
                        bottom: 20,
                        child: Text('Scanning...',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ),

                    // Success result
                    if (_scanComplete)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppTheme.success.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                                Icons.check_circle,
                                color: AppTheme.success,
                                size: 40),
                          ),
                          const SizedBox(height: 12),
                          const Text('Attendance Recorded!',
                              style: TextStyle(
                                  color: AppTheme.success,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(
                            _scannedData.isNotEmpty
                                ? _scannedData
                                : 'Advanced Software Engineering',
                            style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 13),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Scan Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _scanning
                    ? null
                    : _scanComplete
                        ? () {
                            _resetScan();
                            _startScan();
                          }
                        : _startScan,
                icon: Icon(_scanComplete
                    ? Icons.refresh
                    : Icons.qr_code_scanner),
                label: Text(_scanning
                    ? 'Scanning...'
                    : _scanComplete
                        ? 'Scan Again'
                        : 'Scan QR Code'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),

            // Platform indicator
            if (kIsWeb)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.info.withValues(alpha: 0.1)
                        : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppTheme.info.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: AppTheme.info, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Camera scanning is simulated on web. Open this on your mobile device for real QR scanning.',
                          style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppTheme.info
                                  : AppTheme.info,
                              height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _cornerBracket(bool isTop, bool isLeft) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: _CornerPainter(
          isTop: isTop,
          isLeft: isLeft,
          color: AppTheme.primary,
        ),
      ),
    );
  }
}

class _InfoRow
    extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.darkBg2 : AppTheme.background;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    return Container(
      padding: const EdgeInsets
          .symmetric(
          horizontal: 14,
          vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius:
            BorderRadius.circular(
                10),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 18,
              color: iconColor),
          const SizedBox(
              width: 10),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color: txtSec,
                      fontWeight:
                          FontWeight
                              .w500)),
              Text(value,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight
                              .w600,
                      color: valueColor ??
                          txt)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool isTop;
  final bool isLeft;
  final Color color;

  _CornerPainter({
    required this.isTop,
    required this.isLeft,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (isTop && isLeft) {
      path.moveTo(0, size.height * 0.6);
      path.lineTo(0, 0);
      path.lineTo(size.width * 0.6, 0);
    } else if (isTop && !isLeft) {
      path.moveTo(size.width * 0.4, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height * 0.6);
    } else if (!isTop && isLeft) {
      path.moveTo(0, size.height * 0.4);
      path.lineTo(0, size.height);
      path.lineTo(size.width * 0.6, size.height);
    } else {
      path.moveTo(size.width * 0.4, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, size.height * 0.4);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
