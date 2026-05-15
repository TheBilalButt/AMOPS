/// ================================================
/// File    : threat_card.dart
/// Module  : Widgets
/// Desc    : Card for sector-based threat display
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'status_badge.dart';

class ThreatCard extends StatelessWidget {
  final String sector;
  final int count;
  final String risk;

  const ThreatCard({
    super.key,
    required this.sector,
    required this.count,
    required this.risk,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sector $sector",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "$count Detections",
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
            const Spacer(),
            StatusBadge(
              text: risk,
              color: _getRiskColor(risk),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRiskColor(String risk) {
    switch (risk) {
      case 'High': return AppColors.danger;
      case 'Medium': return AppColors.warning;
      case 'Critical': return AppColors.danger;
      default: return AppColors.success;
    }
  }
}
