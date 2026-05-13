// =============================================================================
// File: military_card.dart
// Module: Shared / Widgets
// Description: Reusable styled card with military aesthetic for AMOPS.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_values.dart';

/// A styled card widget with the AMOPS military dark theme.
/// Used throughout the app for consistent card appearance.
class MilitaryCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final LinearGradient? gradient;
  final Color? borderColor;
  final VoidCallback? onTap;

  const MilitaryCard({
    super.key,
    required this.child,
    this.padding,
    this.gradient,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(AppValues.paddingLG),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? AppColors.surface : null,
          borderRadius: BorderRadius.circular(AppValues.radiusLG),
          border: Border.all(
            color: borderColor ?? AppColors.border,
            width: 1,
          ),
        ),
        child: child,
      ),
    );
  }
}
