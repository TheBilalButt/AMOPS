// =============================================================================
// File: app_colors.dart
// Module: Core / Constants
// Description: Centralized color definitions for the AMOPS military theme.
//              All colors used throughout the app are defined here.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter/material.dart';

/// Centralized color constants for the AMOPS dark military theme.
/// All colors used across the application are defined in this class.
class AppColors {
  AppColors._();

  // ── Primary Colors ──────────────────────────────────────────────────────
  /// Deep olive green - primary brand color
  static const Color primary = Color(0xFF1B3A1B);
  /// Lighter olive for surfaces
  static const Color primaryLight = Color(0xFF2D5A2D);
  /// Darkest olive for backgrounds
  static const Color primaryDark = Color(0xFF0D1F0D);

  // ── Secondary Colors ───────────────────────────────────────────────────
  /// Dark navy blue - secondary brand color
  static const Color secondary = Color(0xFF0A1628);
  /// Lighter navy for cards
  static const Color secondaryLight = Color(0xFF142238);
  /// Darkest navy
  static const Color secondaryDark = Color(0xFF060E1A);

  // ── Accent Colors ──────────────────────────────────────────────────────
  /// Amber/orange for alerts and highlights
  static const Color accent = Color(0xFFFF9800);
  /// Lighter amber
  static const Color accentLight = Color(0xFFFFB74D);
  /// Darker amber
  static const Color accentDark = Color(0xFFE65100);

  // ── Status Colors ──────────────────────────────────────────────────────
  /// Green for operational / healthy status
  static const Color statusGreen = Color(0xFF4CAF50);
  /// Light green for high battery / good health
  static const Color statusGreenLight = Color(0xFF81C784);
  /// Orange for warning / medium status
  static const Color statusOrange = Color(0xFFFF9800);
  /// Red for critical alerts / danger
  static const Color statusRed = Color(0xFFE53935);
  /// Light red
  static const Color statusRedLight = Color(0xFFEF5350);
  /// Blue for info status
  static const Color statusBlue = Color(0xFF2196F3);
  /// Yellow for caution
  static const Color statusYellow = Color(0xFFFFEB3B);

  // ── Surface Colors ─────────────────────────────────────────────────────
  /// Main background color
  static const Color background = Color(0xFF0A0E14);
  /// Card / surface background
  static const Color surface = Color(0xFF111922);
  /// Elevated surface (dialogs, modals)
  static const Color surfaceElevated = Color(0xFF1A2332);
  /// Border color for cards
  static const Color border = Color(0xFF1E2D3D);
  /// Divider color
  static const Color divider = Color(0xFF1A2530);

  // ── Text Colors ────────────────────────────────────────────────────────
  /// Primary text - white with slight opacity
  static const Color textPrimary = Color(0xFFE8ECF0);
  /// Secondary text - muted
  static const Color textSecondary = Color(0xFF8A9BB0);
  /// Tertiary text - very muted
  static const Color textTertiary = Color(0xFF5A6A7A);
  /// Text on accent backgrounds
  static const Color textOnAccent = Color(0xFF1A1A1A);

  // ── Threat Level Colors ────────────────────────────────────────────────
  /// Low threat - green
  static const Color threatLow = Color(0xFF4CAF50);
  /// Medium threat - yellow
  static const Color threatMedium = Color(0xFFFFEB3B);
  /// High threat - orange
  static const Color threatHigh = Color(0xFFFF9800);
  /// Critical threat - red
  static const Color threatCritical = Color(0xFFE53935);

  // ── Chart Colors ───────────────────────────────────────────────────────
  static const Color chartLine1 = Color(0xFF4CAF50);
  static const Color chartLine2 = Color(0xFF2196F3);
  static const Color chartLine3 = Color(0xFFFF9800);
  static const Color chartLine4 = Color(0xFFE53935);
  static const Color chartFill = Color(0x334CAF50);

  // ── Gradient Presets ───────────────────────────────────────────────────
  /// Military green gradient for cards
  static const LinearGradient militaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B3A1B), Color(0xFF0A1628)],
  );

  /// Alert gradient for critical cards
  static const LinearGradient alertGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE53935), Color(0xFFB71C1C)],
  );

  /// Accent gradient for highlighted cards
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9800), Color(0xFFE65100)],
  );

  // ── Utility Methods ────────────────────────────────────────────────────

  /// Returns a color based on a percentage value (green > 70, orange 40-70, red < 40).
  static Color healthColor(double percentage) {
    if (percentage >= 70) return statusGreen;
    if (percentage >= 40) return statusOrange;
    return statusRed;
  }

  /// Returns a color based on battery percentage (green > 50, orange 20-50, red < 20).
  static Color batteryColor(double percentage) {
    if (percentage > 50) return statusGreen;
    if (percentage >= 20) return statusOrange;
    return statusRed;
  }

  /// Returns a color based on threat/risk level string.
  static Color threatColor(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return threatLow;
      case 'medium':
        return threatMedium;
      case 'high':
        return threatHigh;
      case 'critical':
        return threatCritical;
      default:
        return textSecondary;
    }
  }
}
