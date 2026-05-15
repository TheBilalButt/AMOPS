/// ================================================
/// File    : vehicle_detail_screen.dart
/// Module  : Fleet
/// Desc    : Detailed view for a specific vehicle
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/loading_widget.dart';

class VehicleDetailScreen extends ConsumerWidget {
  final String vehicleId;
  const VehicleDetailScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleState = ref.watch(vehicleProvider);
    final vehicle = vehicleState.vehicles.firstWhere((v) => v.id == vehicleId, orElse: () => throw "Vehicle not found");

    return Scaffold(
      appBar: AppBar(title: Text("Detail: ${vehicle.id}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Asset Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const Divider(color: Colors.white24),
            _buildInfoRow("Type", vehicle.type),
            _buildInfoRow("Status", vehicle.status),
            _buildInfoRow("Engine Hours", "${vehicle.engineHours}h"),
            _buildInfoRow("Readiness Score", "${vehicle.readiness}%"),
            const SizedBox(height: 24),
            const Text("Health Metrics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 16),
            const Text("Fuel Level", style: TextStyle(color: Colors.white60, fontSize: 12)),
            const SizedBox(height: 4),
            LinearProgressIndicator(value: vehicle.fuel / 100, color: AppColors.success, backgroundColor: Colors.white10),
            const SizedBox(height: 16),
            const Text("Ammo Level", style: TextStyle(color: Colors.white60, fontSize: 12)),
            const SizedBox(height: 4),
            LinearProgressIndicator(value: vehicle.ammo / 100, color: AppColors.warning, backgroundColor: Colors.white10),
            const SizedBox(height: 32),
            const Text("AI Maintenance Prediction", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: vehicle.engineHours > 500 ? AppColors.warning : AppColors.success),
              ),
              child: Text(
                vehicle.engineHours > 500 
                    ? "CRITICAL: Engine service required within 48 operating hours based on usage patterns."
                    : "OPTIMAL: No maintenance required for the next 150 operating hours.",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
