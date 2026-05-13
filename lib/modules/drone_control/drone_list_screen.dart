// =============================================================================
// File: drone_list_screen.dart
// Module: Drone Control
// Description: Displays list of all drones with battery, status, and alerts.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

import '../../core/models/drone_model.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/military_card.dart';
import '../../shared/widgets/status_badge.dart';

/// Drone fleet list screen showing all 12 drones with key status info.
class DroneListScreen extends ConsumerWidget {
  const DroneListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drones = ref.watch(droneListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.statusBlue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.flight, color: AppColors.statusBlue, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(AppStrings.droneFleetTitle),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: drones.length,
        itemBuilder: (context, index) => _buildDroneCard(context, drones[index]),
      ),
    );
  }

  /// Builds an individual drone card with battery bar, status, signal.
  Widget _buildDroneCard(BuildContext context, DroneModel drone) {
    final batteryColor = AppColors.batteryColor(drone.batteryPercentage);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: MilitaryCard(
        onTap: () => context.push('/drone/${drone.id}'),
        borderColor: drone.isHighRisk ? AppColors.statusRed.withValues(alpha: 0.5) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Text(drone.id, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(width: 8),
                if (drone.isHighRisk)
                  StatusBadge(label: 'HIGH RISK', color: AppColors.statusRed),
                const Spacer(),
                StatusBadge(label: drone.missionStatus),
              ],
            ),
            const SizedBox(height: 4),
            Text(drone.name, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            // Battery bar
            Row(
              children: [
                Icon(Icons.battery_charging_full, color: batteryColor, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: drone.batteryPercentage / 100,
                      backgroundColor: AppColors.border,
                      color: batteryColor,
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${drone.batteryPercentage.toStringAsFixed(0)}%',
                    style: TextStyle(color: batteryColor, fontSize: 12, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 10),
            // Info row
            Row(
              children: [
                _infoChip(Icons.height, '${drone.altitude.toStringAsFixed(0)}m'),
                const SizedBox(width: 12),
                _infoChip(Icons.signal_cellular_alt,
                    '${drone.signalStrength.toStringAsFixed(0)}%',
                    color: drone.isSignalRisky ? AppColors.statusRed : null),
                const SizedBox(width: 12),
                _infoChip(
                  drone.cameraOnline ? Icons.videocam : Icons.videocam_off,
                  drone.cameraOnline ? 'Online' : 'Offline',
                  color: drone.cameraOnline ? AppColors.statusGreen : AppColors.statusRed,
                ),
                const Spacer(),
                Text(drone.assignedSector, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            // Low battery warning
            if (drone.isBatteryLow) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.statusRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.statusRed.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber, color: AppColors.statusRed, size: 14),
                    const SizedBox(width: 6),
                    Text('Low battery - Auto-returning to base',
                        style: TextStyle(color: AppColors.statusRed, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
            // Signal risk warning
            if (drone.isSignalRisky && !drone.isBatteryLow) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.statusOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.statusOrange.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.signal_cellular_connected_no_internet_0_bar, color: AppColors.statusOrange, size: 14),
                    const SizedBox(width: 6),
                    Text('Mission Risk - Signal strength low',
                        style: TextStyle(color: AppColors.statusOrange, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Small info chip with icon and text.
  Widget _infoChip(IconData icon, String text, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color ?? AppColors.textTertiary),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: color ?? AppColors.textTertiary, fontSize: 11)),
      ],
    );
  }
}
