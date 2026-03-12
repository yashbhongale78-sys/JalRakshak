// lib/core/theme/app_theme.dart
// JALARAKSHA - Modern Healthcare Theme
// Professional design for government health monitoring app

import 'package:flutter/material.dart';

/// JALARAKSHA Color Palette - Healthcare focused
class AppColors {
  AppColors._();

  // ── Primary (Sky Blue - Water Theme) ──────────────────────
  static const Color primary = Color(0xFF0EA5E9); // Sky Blue
  static const Color primaryLight = Color(0xFF38BDF8);
  static const Color primaryDark = Color(0xFF0284C7);
  static const Color primaryContainer = Color(0xFFE0F2FE);

  // ── Danger (High Risk Red) ─────────────────────────────────
  static const Color danger = Color(0xFFEF4444); // Red
  static const Color dangerLight = Color(0xFFF87171);
  static const Color dangerContainer = Color(0xFFFEF2F2);

  // ── Warning (Medium Risk Amber) ────────────────────────────
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningContainer = Color(0xFFFEF3C7);

  // ── Safe (Low Risk Green) ──────────────────────────────────
  static const Color safe = Color(0xFF10B981); // Green
  static const Color safeLight = Color(0xFF34D399);
  static const Color safeContainer = Color(0xFFD1FAE5);

  // ── Dark Theme Colors ──────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0F172A); // Dark Navy
  static const Color cardDark = Color(0xFF1E293B); // Dark Card
  static const Color textLight = Color(0xFFF1F5F9); // Light Text
  static const Color textMuted = Color(0xFF94A3B8); // Muted Text

  // ── Legacy Support (for existing code) ─────────────────────
  static const Color secondary = safe;
  static const Color alert = danger;
  static const Color alertLight = dangerLight;
  static const Color alertContainer = dangerContainer;
  static const Color secondaryContainer = safeContainer;
  static const Color secondaryLight = safeLight;
  static const Color surface = Color(0xFFF8FAFC);
  static const Color background = Color(0xFFF1F5F9);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE2E8F0);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Severity Colors ───────────────────────────────────────
  static const Color severityLow = safe;
  static const Color severityMedium = warning;
  static const Color severityHigh = danger;
  static const Color severityCritical = Color(0xFFDC2626);

  // ── Gradients ──────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundDark, Color(0xFF1E293B)],
  );
}

/// JALARAKSHA Theme Configuration
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',

      // ── Color Scheme ──────────────────────────────────────
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.safe,
        error: AppColors.danger,
        surface: AppColors.surface,
      ),

      // ── Scaffold ──────────────────────────────────────────
      scaffoldBackgroundColor: AppColors.background,

      // ── AppBar ────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textOnPrimary,
        ),
      ),

      // ── Card ──────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 2,
        shadowColor: AppColors.primary.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // ── Input Decoration ──────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        hintStyle: const TextStyle(
          color: AppColors.textHint,
          fontFamily: 'Poppins',
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontFamily: 'Poppins',
        ),
      ),

      // ── Elevated Button ───────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 2,
        ),
      ),

      // ── Text Theme ────────────────────────────────────────
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          color: AppColors.textHint,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,

      // ── Color Scheme ──────────────────────────────────────
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.safe,
        error: AppColors.danger,
        surface: AppColors.cardDark,
      ),

      // ── Scaffold ──────────────────────────────────────────
      scaffoldBackgroundColor: AppColors.backgroundDark,

      // ── AppBar ────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textLight,
        ),
      ),

      // ── Card ──────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // ── Text Theme ────────────────────────────────────────
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.textLight,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textLight,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textLight,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}
