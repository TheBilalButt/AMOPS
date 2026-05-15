/// ================================================
/// File    : drone_card.dart
/// Module  : Widgets
/// Desc    : Card for displaying drone status and controls
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/drone_model.dart';
import 'status_badge.dart';

class DroneCard extends StatelessWidget {
  final DroneModel drone;
  final VoidCallback onLaunch;
  final VoidCallback onReturn;
  final VoidCallback onAbort;
  final VoidCallback onTap;

  const DroneCard({
    super.key,
    required this.drone,
    required this.onLaunch,
    required this.onReturn,
    required this.onAbort,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color batteryColor = AppColors.success;
    if (drone.battery < 20) batteryColor = AppColors.danger;
    else if (drone.battery < 50) batteryColor = AppColors.warning;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.airplanemode_active, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    drone.id,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  StatusBadge(
                    text: drone.status,
                    color: _getStatusColor(drone.status),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: drone.battery / 100,
                backgroundColor: Colors.white10,
                color: batteryColor,
              ),
              const SizedBox(height: 4),
              Text(
                "Battery: ${drone.battery}%",
                style: TextStyle(color: batteryColor, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn("Altitude", "${drone.altitude}m"),
                  _buildInfoColumn("Signal", "${drone.signal}%"),
                  _buildInfoColumn("Camera", drone.camera),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onLaunch,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: const Text("Launch", style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onReturn,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                      child: const Text("Return", style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAbort,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                      child: const Text("Abort", style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active': return AppColors.success;
      case 'Returning': return AppColors.warning;
      case 'Critical': return AppColors.danger;
      default: return AppColors.primary;
    }
  }
}
