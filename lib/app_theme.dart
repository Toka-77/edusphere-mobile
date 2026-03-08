import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Brand Colors ──────────────────────────────────────────
  static const Color primary =
      Color(0xFFE53935);
  static const Color primaryLight =
      Color(0xFFFFEBEE);
  static const Color primaryDark =
      Color(0xFFC62828);
  static const Color background =
      Color(0xFFF4F6F9);
  static const Color cardBg =
      Colors.white;
  static const Color textPrimary =
      Color(0xFF1A1A2E);
  static const Color
      textSecondary =
      Color(0xFF6B7280);
  static const Color textLight =
      Color(0xFF9CA3AF);
  static const Color success =
      Color(0xFF10B981);
  static const Color warning =
      Color(0xFFF59E0B);
  static const Color info =
      Color(0xFF3B82F6);
  static const Color border =
      Color(0xFFE5E7EB);
  static const Color green =
      Color(0xFF22C55E);
  static const Color orange =
      Color(0xFFF97316);
  static const Color purple =
      Color(0xFF8B5CF6);

  // ── Dark Mode Colors (matches web CSS variables exactly) ────
  static const Color darkBg =               // --bg0
      Color(0xFF0B0D17);
  static const Color darkCard =             // --bg1
      Color(0xFF111827);
  static const Color darkBg2 =              // --bg2
      Color(0xFF1A1F2E);
  static const Color darkBg3 =              // --bg3
      Color(0xFF212840);
  static const Color darkSidebar =          // --sb
      Color(0xFF0F1120);
  static const Color darkBorder =           // --border
      Color(0xFF1E2336);
  static const Color darkBorder2 =          // --border2
      Color(0xFF2D3452);
  static const Color darkText =             // --t1
      Color(0xFFF1F5F9);
  static const Color darkTextSec =          // --t2
      Color(0xFF94A3B8);
  static const Color darkTextLight =        // --t3
      Color(0xFF475569);

  // ── Light Theme ───────────────────────────────────────────
  static ThemeData
      get lightTheme =>
          _build(Brightness.light);

  // ── Dark Theme ────────────────────────────────────────────
  static ThemeData get darkTheme =>
      _build(Brightness.dark);

  static ThemeData _build(
      Brightness brightness) {
    final isDark = brightness ==
        Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor:
          isDark
              ? darkBg
              : background,
      colorScheme:
          ColorScheme.fromSeed(
        seedColor: primary,
        brightness: brightness,
      ),
      textTheme: GoogleFonts
          .interTextTheme(
        isDark
            ? ThemeData(
                    brightness:
                        Brightness
                            .dark)
                .textTheme
            : ThemeData.light()
                .textTheme,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? darkCard
            : cardBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle:
            GoogleFonts.inter(
          fontSize: 18,
          fontWeight:
              FontWeight.w700,
          color: isDark
              ? darkText
              : textPrimary,
        ),
        iconTheme: IconThemeData(
          color: isDark
              ? darkText
              : textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark
            ? darkCard
            : cardBg,
        elevation: 0,
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius
                  .circular(16),
          side: BorderSide(
              color: isDark
                  ? darkBorder
                  : border,
              width: 1),
        ),
      ),
      elevatedButtonTheme:
          ElevatedButtonThemeData(
        style: ElevatedButton
            .styleFrom(
          backgroundColor: primary,
          foregroundColor:
              Colors.white,
          shape:
              RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                              12)),
          padding: const EdgeInsets
              .symmetric(
              vertical: 14,
              horizontal: 24),
          textStyle:
              GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight:
                      FontWeight
                          .w600),
        ),
      ),
      popupMenuTheme:
          PopupMenuThemeData(
        color: isDark
            ? darkCard
            : cardBg,
        shape:
            RoundedRectangleBorder(
                borderRadius:
                    BorderRadius
                        .circular(
                            14)),
      ),
    );
  }

  // Keep old getter so existing code doesn't break
  static ThemeData get theme =>
      lightTheme;
}
