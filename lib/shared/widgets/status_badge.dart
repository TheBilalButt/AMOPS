// =============================================================================
// File: status_badge.dart
// Module: Shared / Widgets
// Description: Color-coded status badges and risk level indicators.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_values.dart';

/// Displays a color-coded status badge for mission/operational statuses.
class StatusBadge extends StatelessWidget {
  final String label;
  final Color? color;

  const StatusBadge({super.key, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? _getStatusColor(label);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.paddingMD,
        vertical: AppValues.paddingXS,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppValues.radiusRound),
        border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: badgeColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  /// Maps status strings to colors.
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active': case 'operational': case 'online': case 'completed': case 'delivered':
        return AppColors.statusGreen;
      case 'standby': case 'monitoring': case 'scheduled': case 'open':
        return AppColors.statusBlue;
      case 'returning': case 'warning': case 'delayed': case 'in progress': case 'in transit':
        return AppColors.statusOrange;
      case 'offline': case 'critical': case 'maintenance': case 'high risk':
        return AppColors.statusRed;
      default:
        return AppColors.textSecondary;
    }
  }
}

/// Risk level badge with specific threat-level coloring.
class RiskBadge extends StatelessWidget {
  final String level;

  const RiskBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.threatColor(level);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.paddingMD,
        vertical: AppValues.paddingXS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppValues.radiusRound),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            level.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
