// =============================================================================
// File: drone_detail_screen.dart
// Module: Drone Control
// Description: Detailed view of a single drone with map, mission history,
//              action buttons, and battery prediction.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/military_card.dart';
import '../../shared/widgets/status_badge.dart';

/// Detail screen for a single drone with map, actions, and mission history.
class DroneDetailScreen extends ConsumerWidget {
  final String droneId;
  const DroneDetailScreen({super.key, required this.droneId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drone = ref.watch(droneDetailProvider(droneId));
    if (drone == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Drone Not Found')),
        body: const Center(child: Text(AppStrings.noData)),
      );
    }
    final batteryColor = AppColors.batteryColor(drone.batteryPercentage);

    return Scaffold(
      appBar: AppBar(
        title: Text('${drone.id} — ${drone.name}'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 220,
                child: FlutterMap(
                  options: MapOptions(initialCenter: LatLng(drone.latitude, drone.longitude), initialZoom: 10),
                  children: [
                    TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                    MarkerLayer(markers: [
                      Marker(
                        point: LatLng(drone.latitude, drone.longitude),
                        width: 40, height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.statusBlue.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.statusBlue, width: 2),
                          ),
                          child: const Icon(Icons.flight, color: AppColors.statusBlue, size: 20),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Status row
            Row(
              children: [
                StatusBadge(label: drone.missionStatus),
                const SizedBox(width: 8),
                if (drone.isHighRisk) StatusBadge(label: 'HIGH RISK', color: AppColors.statusRed),
                const Spacer(),
                Text(drone.assignedSector, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 16),
            // Info cards grid
            GridView.count(
              crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.2,
              children: [
                _infoCard(context, 'Battery', '${drone.batteryPercentage.toStringAsFixed(0)}%', Icons.battery_charging_full, batteryColor),
                _infoCard(context, 'Altitude', '${drone.altitude.toStringAsFixed(0)}m', Icons.height, AppColors.textSecondary),
                _infoCard(context, 'Signal', '${drone.signalStrength.toStringAsFixed(0)}%', Icons.signal_cellular_alt,
                    drone.isSignalRisky ? AppColors.statusRed : AppColors.statusGreen),
                _infoCard(context, 'Camera', drone.cameraOnline ? 'Online' : 'Offline',
                    drone.cameraOnline ? Icons.videocam : Icons.videocam_off,
                    drone.cameraOnline ? AppColors.statusGreen : AppColors.statusRed),
              ],
            ),
            const SizedBox(height: 12),
            // GPS Coordinates
            MilitaryCard(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                const Icon(Icons.location_on, color: AppColors.accent, size: 18),
                const SizedBox(width: 8),
                Text('${drone.latitude.toStringAsFixed(4)}, ${drone.longitude.toStringAsFixed(4)}',
                    style: Theme.of(context).textTheme.bodyMedium),
              ]),
            ),
            const SizedBox(height: 12),
            // Battery prediction
            MilitaryCard(
              gradient: AppColors.militaryGradient,
              child: Row(children: [
                const Icon(Icons.access_time, color: AppColors.accent, size: 18),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(AppStrings.estimatedFlightTime, style: Theme.of(context).textTheme.bodySmall),
                  Text('${drone.estimatedFlightMinutes} minutes',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.accent)),
                ]),
              ]),
            ),
            const SizedBox(height: 20),
            // Action buttons
            Row(children: [
              Expanded(child: _actionButton(context, ref, AppStrings.launchDrone, Icons.rocket_launch, AppColors.statusGreen, () {
                ref.read(droneListProvider.notifier).updateDroneStatus(droneId, 'Active');
              })),
              const SizedBox(width: 8),
              Expanded(child: _actionButton(context, ref, AppStrings.returnToBase, Icons.home, AppColors.statusOrange, () {
                ref.read(droneListProvider.notifier).updateDroneStatus(droneId, 'Returning');
              })),
              const SizedBox(width: 8),
              Expanded(child: _actionButton(context, ref, AppStrings.abortMission, Icons.cancel, AppColors.statusRed, () {
                ref.read(droneListProvider.notifier).updateDroneStatus(droneId, 'Standby');
              })),
            ]),
            const SizedBox(height: 20),
            // Mission history
            Text(AppStrings.missionHistory.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.textSecondary, letterSpacing: 1.5)),
            const SizedBox(height: 8),
            if (drone.missionHistory.isEmpty)
              MilitaryCard(padding: const EdgeInsets.all(20), child: Center(
                child: Text('No mission history', style: Theme.of(context).textTheme.bodyMedium),
              ))
            else
              ...drone.missionHistory.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: MilitaryCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text(m.missionId, style: Theme.of(context).textTheme.titleMedium),
                      const Spacer(),
                      StatusBadge(label: m.status),
                    ]),
                    const SizedBox(height: 4),
                    Text(m.description, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text('Sector: ${m.sector}', style: Theme.of(context).textTheme.bodySmall),
                  ]),
                ),
              )),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return MilitaryCard(
      padding: const EdgeInsets.all(10),
      child: Row(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ]),
      ]),
    );
  }

  Widget _actionButton(BuildContext context, WidgetRef ref, String label, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.15),
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.4)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Column(children: [
        Icon(icon, size: 18),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}
