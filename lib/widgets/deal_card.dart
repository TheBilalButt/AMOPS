/// ================================================
/// File    : deal_card.dart
/// Module  : Widgets
/// Desc    : Card for sales pipeline deals
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/sales_model.dart';
import 'status_badge.dart';

class DealCard extends StatelessWidget {
  final SalesModel deal;
  final VoidCallback onAdvance;

  const DealCard({
    super.key,
    required this.deal,
    required this.onAdvance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.public, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(deal.country, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                StatusBadge(text: deal.stage, color: _getStageColor(deal.stage)),
              ],
            ),
            const SizedBox(height: 12),
            Text(deal.product, style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(deal.value, style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                Text("Win: ${deal.winProbability}%", style: TextStyle(color: _getProbabilityColor(deal.winProbability))),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: deal.stage != 'Closed' ? onAdvance : null,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text("Advance Stage"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStageColor(String stage) {
    switch (stage) {
      case 'Lead': return Colors.blue;
      case 'Quote': return AppColors.primary;
      case 'Negotiation': return AppColors.warning;
      case 'Contract': return AppColors.success;
      default: return Colors.grey;
    }
  }

  Color _getProbabilityColor(int prob) {
    if (prob > 70) return AppColors.success;
    if (prob > 40) return AppColors.warning;
    return AppColors.danger;
  }
}
