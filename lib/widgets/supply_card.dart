/// ================================================
/// File    : supply_card.dart
/// Module  : Widgets
/// Desc    : Card for inventory items and supply status
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/supply_model.dart';
import 'status_badge.dart';

class SupplyCard extends StatelessWidget {
  final SupplyModel supply;
  final VoidCallback onResupply;

  const SupplyCard({
    super.key,
    required this.supply,
    required this.onResupply,
  });

  @override
  Widget build(BuildContext context) {
    final isLow = supply.current < supply.threshold;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  supply.name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                StatusBadge(
                  text: isLow ? "LOW STOCK" : "OPTIMAL",
                  color: isLow ? AppColors.danger : AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: supply.current / 100,
              backgroundColor: Colors.white10,
              color: isLow ? AppColors.danger : AppColors.success,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Current: ${supply.current}${supply.unit == 'percent' ? '%' : ' units'}",
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
                Text(
                  "Threshold: ${supply.threshold}%",
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onResupply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLow ? AppColors.primary : Colors.white10,
                  foregroundColor: isLow ? Colors.black : Colors.white60,
                ),
                child: const Text("Request Resupply"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
