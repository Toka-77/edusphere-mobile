import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mobile_scanner/mobile_scanner.dart';
import '../app_theme.dart';
import '../locale_provider.dart';
import 'home_screen.dart';

class AttendanceQRScreen extends StatefulWidget {
  const AttendanceQRScreen({super.key});

  @override
  State<AttendanceQRScreen> createState() => _AttendanceQRScreenState();
}

class _AttendanceQRScreenState extends State<AttendanceQRScreen>
    with SingleTickerProviderStateMixin {
  bool _scanning = false;
  bool _scanComplete = false;
  bool _qrExpired = false;
  String _scannedData = '';
  late AnimationController _scanLineController;
  MobileScannerController? _cameraController;

  // ── QR Expiry Timer (5 minutes = 300 seconds) ──────────────────
  static const int _qrDuration = 300;
  int _qrSeconds = _qrDuration;
  Timer? _qrTimer;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _startQRTimer();
  }

  void _startQRTimer() {
    _qrTimer?.cancel();
    _qrSeconds = _qrDuration;
    _qrExpired = false;
    _qrTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_qrSeconds > 0) {
        setState(() => _qrSeconds--);
      } else {
        setState(() {
          _qrExpired = true;
          _scanning = false;
        });
        _cameraController?.stop();
        _qrTimer?.cancel();
      }
    });
  }

  String get _timerStr {
    final m = _qrSeconds ~/ 60;
    final s = _qrSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Color get _timerColor {
    if (_qrSeconds <= 30) return AppTheme.primary;   // أحمر آخر 30 ثانية
    if (_qrSeconds <= 60) return AppTheme.warning;   // برتقالي آخر دقيقة
    return AppTheme.success;                         // أخضر طبيعي
  }

  @override
  void dispose() {
    _qrTimer?.cancel();
    _scanLineController.dispose();
    _cameraController?.stop();
    _cameraController?.dispose();
    super.dispose();
  }

  void _startScan() {
    if (_qrExpired) return;
    if (kIsWeb) {
      _startSimulatedScan();
    } else {
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
        _qrTimer?.cancel();
      }
    });
  }

  void _onQRDetected(BarcodeCapture capture) {
    if (_scanComplete || _qrExpired) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode != null && barcode.rawValue != null) {
      _cameraController?.stop();
      _qrTimer?.cancel();
      setState(() {
        _scanning = false;
        _scanComplete = true;
        _scannedData = barcode.rawValue!;
      });
    }
  }

  void _resetScan() {
    _cameraController?.stop();
    _cameraController?.dispose();
    _cameraController = null;
    setState(() {
      _scanning = false;
      _scanComplete = false;
      _scannedData = '';
    });
    _startQRTimer();
  }

  String _currentTimeLocalized() {
    final now = DateTime.now();
    final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final m = now.minute.toString().padLeft(2, '0');
    final isAm = now.hour < 12;
    final lang = localeNotifier.value;
    String ampm;
    switch (lang) {
      case 'ar':
        ampm = isAm ? 'صباحاً' : 'مساءً';
        break;
      default:
        ampm = isAm ? 'AM' : 'PM';
    }
    return '$h:$m $ampm';
  }

  @override
  Widget build(BuildContext context) {
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu, color: txt),
          onPressed: HomeScreen.openDrawer,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('QR Attendance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: txt)),
            Text('EduSphere Smart Attendance System',
                style: TextStyle(fontSize: 11, color: txtSec)),
          ],
        ),
        actions: [
          // ── QR Timer Badge ──────────────────────────────────
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: (_qrExpired ? AppTheme.primary : _timerColor).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  _qrExpired ? Icons.timer_off_outlined : Icons.timer_outlined,
                  size: 14,
                  color: _qrExpired ? AppTheme.primary : _timerColor,
                ),
                const SizedBox(width: 4),
                Text(
                  _qrExpired ? 'Expired' : 'Expires in $_timerStr',
                  style: TextStyle(
                    color: _qrExpired ? AppTheme.primary : _timerColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: txt),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (v) {
              if (v == 'reset') {
                _resetScan();
              } else if (v == 'history') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Attendance history coming soon'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (v == 'help') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Point your camera at the QR code displayed by your instructor.'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'reset',
                child: Row(children: [
                  Icon(Icons.refresh_outlined, size: 18),
                  SizedBox(width: 10),
                  Text('Reset Scanner'),
                ]),
              ),
              PopupMenuItem(
                value: 'history',
                child: Row(children: [
                  Icon(Icons.history_outlined, size: 18),
                  SizedBox(width: 10),
                  Text('View History'),
                ]),
              ),
              PopupMenuItem(
                value: 'help',
                child: Row(children: [
                  Icon(Icons.help_outline, size: 18),
                  SizedBox(width: 10),
                  Text('How to Scan'),
                ]),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Expired Banner ──────────────────────────────────
            if (_qrExpired)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_off_outlined, color: AppTheme.primary, size: 22),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('QR Code Expired',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary)),
                          SizedBox(height: 2),
                          Text(
                            'This QR session has ended. Ask your instructor for a new code.',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Lecture Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.primary.withValues(alpha: 0.15)
                          : AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('ONGOING LECTURE',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                            letterSpacing: 0.5)),
                  ),
                  const SizedBox(height: 12),
                  Text('Advanced Software Engineering',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: txt)),
                  const SizedBox(height: 4),
                  Text('CS402 • Dr. Sarah Johnson',
                      style: TextStyle(fontSize: 13, color: txtSec)),
                  const SizedBox(height: 16),
                  const _InfoRow(
                    icon: Icons.location_on_outlined,
                    iconColor: AppTheme.primary,
                    label: 'Location',
                    value: 'Hall 302',
                  ),
                  const SizedBox(height: 10),
                  const _InfoRow(
                    icon: Icons.location_searching,
                    iconColor: AppTheme.warning,
                    label: 'GPS Verification',
                    value: 'Checking Location...',
                    valueColor: AppTheme.warning,
                  ),
                  const SizedBox(height: 16),

                  // ── Timer Progress Bar ──────────────────────
                  if (!_scanComplete) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('QR Valid For',
                            style: TextStyle(
                                fontSize: 12, color: txtSec, fontWeight: FontWeight.w500)),
                        Text(
                          _qrExpired ? 'Expired' : _timerStr,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _qrExpired ? AppTheme.primary : _timerColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _qrSeconds / _qrDuration,
                        minHeight: 6,
                        backgroundColor: (_qrExpired ? AppTheme.primary : _timerColor)
                            .withValues(alpha: 0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            _qrExpired ? AppTheme.primary : _timerColor),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  Center(
                    child: Column(
                      children: [
                        Text('Status',
                            style: TextStyle(
                                fontSize: 12, color: txtSec, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(
                          _qrExpired
                              ? '⏱️ QR Code Expired'
                              : _scanComplete
                              ? '✅ Attendance Recorded'
                              : _scanning
                              ? 'Scanning...'
                              : 'Waiting for scan...',
                          style: TextStyle(
                              fontSize: 15,
                              color: _qrExpired
                                  ? AppTheme.primary
                                  : _scanComplete
                                  ? AppTheme.success
                                  : txtLight,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

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

                    if (!_scanComplete && !_qrExpired) ...[
                      Positioned(top: 40, left: 60, child: _cornerBracket(true, true)),
                      Positioned(top: 40, right: 60, child: _cornerBracket(true, false)),
                      Positioned(bottom: 40, left: 60, child: _cornerBracket(false, true)),
                      Positioned(bottom: 40, right: 60, child: _cornerBracket(false, false)),
                    ],

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

                    // ── Expired Overlay ───────────────────────
                    if (_qrExpired)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.timer_off_outlined,
                                color: AppTheme.primary, size: 34),
                          ),
                          const SizedBox(height: 16),
                          const Text('QR Code Expired',
                              style: TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          const Text(
                            'Contact your instructor\nfor a new QR code',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white60, fontSize: 13),
                          ),
                        ],
                      )
                    else if (!_scanning && !_scanComplete)
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
                                kIsWeb ? Icons.camera_alt_outlined : Icons.qr_code_scanner,
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
                            style: const TextStyle(color: Colors.white60, fontSize: 13),
                          ),
                        ],
                      ),

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
                                    strokeWidth: 2, color: Colors.white),
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

                    if (_scanning && kIsWeb)
                      const Positioned(
                        bottom: 20,
                        child: Text('Scanning...',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ),

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
                            child: const Icon(Icons.check_circle,
                                color: AppTheme.success, size: 40),
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
                            style: const TextStyle(color: Colors.white60, fontSize: 13),
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
                onPressed: _scanning || _qrExpired
                    ? null
                    : _scanComplete
                    ? () { _resetScan(); _startScan(); }
                    : _startScan,
                icon: Icon(_scanComplete ? Icons.refresh : Icons.qr_code_scanner),
                label: Text(_qrExpired
                    ? 'QR Expired'
                    : _scanning
                    ? 'Scanning...'
                    : _scanComplete
                    ? 'Scan Again'
                    : 'Scan QR Code'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),

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
                    border: Border.all(color: AppTheme.info.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppTheme.info, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Camera scanning is simulated on web. Open this on your mobile device for real QR scanning.',
                          style: TextStyle(fontSize: 12, color: AppTheme.info, height: 1.4),
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
        painter: _CornerPainter(isTop: isTop, isLeft: isLeft, color: AppTheme.primary),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.darkBg2 : AppTheme.background;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;
    final txt = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11, color: txtSec, fontWeight: FontWeight.w500)),
              Text(value,
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: valueColor ?? txt)),
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

  _CornerPainter({required this.isTop, required this.isLeft, required this.color});

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