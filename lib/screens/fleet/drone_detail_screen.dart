/// ================================================
/// File    : drone_detail_screen.dart
/// Module  : Fleet
/// Desc    : Detailed view for a specific drone
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/drone_provider.dart';
import '../../widgets/loading_widget.dart';

class DroneDetailScreen extends ConsumerWidget {
  final String droneId;
  const DroneDetailScreen({super.key, required this.droneId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final droneState = ref.watch(droneProvider);
    final drone = droneState.drones.firstWhere((d) => d.id == droneId, orElse: () => throw "Drone not found");

    return Scaffold(
      appBar: AppBar(title: Text("Detail: ${drone.id}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.map, color: AppColors.primary, size: 64),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Asset Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const Divider(color: Colors.white24),
            _buildInfoRow("Status", drone.status),
            _buildInfoRow("Battery", "${drone.battery}%"),
            _buildInfoRow("Altitude", "${drone.altitude}m"),
            _buildInfoRow("Signal Strength", "${drone.signal}%"),
            _buildInfoRow("Camera Feed", drone.camera),
            const SizedBox(height: 32),
            const Text("Mission History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.history, color: Colors.white38),
                title: Text("Mission ${100 - index}"),
                subtitle: const Text("Success - 2026-05-14"),
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
