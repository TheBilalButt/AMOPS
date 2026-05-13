// =============================================================================
// File: shimmer_loading.dart
// Module: Shared / Widgets
// Description: Shimmer loading placeholder widgets for data loading states.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_values.dart';

/// Shimmer loading card placeholder for list items.
class ShimmerCard extends StatelessWidget {
  final double height;

  const ShimmerCard({super.key, this.height = 120});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surfaceElevated,
      child: Container(
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppValues.radiusLG),
        ),
      ),
    );
  }
}

/// Shimmer loading for a list of cards.
class ShimmerList extends StatelessWidget {
  final int count;
  final double itemHeight;

  const ShimmerList({super.key, this.count = 5, this.itemHeight = 100});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(count, (_) => ShimmerCard(height: itemHeight)),
    );
  }
}
