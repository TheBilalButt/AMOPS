/// ================================================
/// File    : vehicle_card.dart
/// Module  : Widgets
/// Desc    : Card for displaying vehicle status (Tanks, etc)
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/vehicle_model.dart';
import 'status_badge.dart';

class VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final VoidCallback onDeploy;
  final VoidCallback onTap;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.onDeploy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                  Icon(
                    vehicle.type == 'Tank' ? Icons.security : Icons.local_shipping,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    vehicle.id,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  StatusBadge(
                    text: vehicle.type,
                    color: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text("Fuel", style: TextStyle(color: Colors.white60, fontSize: 12)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: vehicle.fuel / 100,
                      backgroundColor: Colors.white10,
                      color: vehicle.fuel < 20 ? AppColors.danger : AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text("${vehicle.fuel}%", style: const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem("Ammo", "${vehicle.ammo}%"),
                  _buildInfoItem("Engine", "${vehicle.engineHours}h"),
                  _buildInfoItem("Location", "Sector 7"),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text("AI Readiness Score: ", style: TextStyle(color: Colors.white60, fontSize: 12)),
                  Text(
                    "${vehicle.readiness}%",
                    style: TextStyle(
                      color: vehicle.readiness > 80 ? AppColors.success : (vehicle.readiness > 50 ? AppColors.warning : AppColors.danger),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  StatusBadge(
                    text: vehicle.status,
                    color: vehicle.status == 'Operational' ? AppColors.success : AppColors.warning,
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: onDeploy,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    ),
                    child: const Text("Deploy", style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
