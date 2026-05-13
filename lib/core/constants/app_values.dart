// =============================================================================
// File: app_values.dart
// Module: Core / Constants
// Description: Numeric constants and threshold values used throughout AMOPS.
//              Includes spacing, sizing, animation durations, and AI thresholds.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

/// Centralized numeric constants and threshold values for AMOPS.
class AppValues {
  AppValues._();

  // ── Spacing ────────────────────────────────────────────────────────────
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 12.0;
  static const double paddingLG = 16.0;
  static const double paddingXL = 20.0;
  static const double paddingXXL = 24.0;
  static const double paddingHuge = 32.0;

  // ── Border Radius ──────────────────────────────────────────────────────
  static const double radiusSM = 6.0;
  static const double radiusMD = 10.0;
  static const double radiusLG = 14.0;
  static const double radiusXL = 18.0;
  static const double radiusRound = 100.0;

  // ── Card Sizes ─────────────────────────────────────────────────────────
  static const double cardElevation = 0.0;
  static const double iconSizeSM = 18.0;
  static const double iconSizeMD = 24.0;
  static const double iconSizeLG = 32.0;
  static const double iconSizeXL = 48.0;

  // ── Animation Durations (ms) ───────────────────────────────────────────
  static const int animFast = 200;
  static const int animNormal = 350;
  static const int animSlow = 500;
  static const int shimmerDuration = 1500;

  // ── AI Thresholds ──────────────────────────────────────────────────────
  /// Battery percentage below which drone auto-returns
  static const double batteryLowThreshold = 20.0;
  /// Battery percentage for warning state
  static const double batteryWarnThreshold = 50.0;
  /// Signal strength below which mission risk alert triggers
  static const double signalRiskThreshold = 30.0;
  /// Suspicious object count that triggers HIGH RISK badge
  static const int suspiciousObjectLimit = 3;
  /// Engine hours above which maintenance is recommended
  static const double engineHoursLimit = 500.0;
  /// Days since last service to trigger maintenance alert
  static const int serviceIntervalDays = 90;
  /// Health score below which auto work order is generated
  static const double healthAutoWorkOrder = 40.0;
  /// Threat detections in sector to auto-escalate
  static const int sectorDetectionEscalation = 3;
  /// Fuel inventory safe level percentage
  static const double fuelSafeLevel = 25.0;
  /// Ammo inventory safe level percentage
  static const double ammoSafeLevel = 20.0;
  /// Quality score threshold for defect alert
  static const double qualityDefectThreshold = 85.0;

  // ── Layout ─────────────────────────────────────────────────────────────
  static const double bottomNavHeight = 70.0;
  static const double drawerWidth = 280.0;
  static const int dashboardAlertCount = 5;
  static const int chartDays = 7;

  // ── Map Defaults ───────────────────────────────────────────────────────
  /// Default map center - Taxila, Pakistan
  static const double defaultLat = 33.7463;
  static const double defaultLng = 72.8397;
  static const double defaultZoom = 8.0;
}
