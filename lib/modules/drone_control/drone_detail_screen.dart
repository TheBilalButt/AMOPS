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
import 'package:latlong2/latlong.dart' hide Path;
import 'dart:ui' as ui;
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
            Wrap(
              spacing: 10, runSpacing: 10,
              children: [
                _buildResponsiveCard(context, 'Battery', '${drone.batteryPercentage.toStringAsFixed(0)}%', Icons.battery_charging_full, batteryColor),
                _buildResponsiveCard(context, 'Altitude', '${drone.altitude.toStringAsFixed(0)}m', Icons.height, AppColors.textSecondary),
                _buildResponsiveCard(context, 'Signal', '${drone.signalStrength.toStringAsFixed(0)}%', Icons.signal_cellular_alt,
                    drone.isSignalRisky ? AppColors.statusRed : AppColors.statusGreen),
                _buildResponsiveCard(context, 'Camera', drone.cameraOnline ? 'Online' : 'Offline',
                    drone.cameraOnline ? Icons.videocam : Icons.videocam_off,
                    drone.cameraOnline ? AppColors.statusGreen : AppColors.statusRed),
              ],
            ),
            const SizedBox(height: 16),
            if (drone.cameraOnline)
              _buildLiveFeed(context, drone),
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
  Widget _buildResponsiveCard(BuildContext context, String label, String value, IconData icon, Color color) {
    // Make cards responsive so they don't stretch massively on desktop
    double width = (MediaQuery.of(context).size.width - 32 - 10) / 2;
    if (width > 200) width = 200; // Cap width for large screens so they wrap nicely
    
    return SizedBox(
      width: width,
      child: _infoCard(context, label, value, icon, color),
    );
  }

  Widget _buildLiveFeed(BuildContext context, drone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('LIVE CAMERA FEED', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.statusRed, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        MilitaryCard(
          padding: EdgeInsets.zero,
          borderColor: AppColors.statusRed.withValues(alpha: 0.5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  // Tactical night vision map background
                  image: const NetworkImage('https://images.unsplash.com/photo-1518331647614-7a1f04cd34cb?q=80&w=1000&auto=format&fit=crop'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(AppColors.statusGreen.withValues(alpha: 0.4), BlendMode.dstATop),
                ),
              ),
              child: Stack(
                children: [
                  // Grid overlay
                  Positioned.fill(
                    child: CustomPaint(painter: _HudGridPainter()),
                  ),
                  // Crosshair
                  const Center(
                    child: Icon(Icons.add, color: AppColors.statusGreen, size: 50),
                  ),
                  // REC Indicator
                  Positioned(
                    top: 16, right: 16,
                    child: Row(
                      children: [
                        Container(
                          width: 10, height: 10,
                          decoration: const BoxDecoration(color: AppColors.statusRed, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        const Text('REC', style: TextStyle(color: AppColors.statusRed, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
                      ],
                    ),
                  ),
                  // HUD Text
                  Positioned(
                    bottom: 16, left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ALT: ${drone.altitude.toStringAsFixed(0)}m', style: const TextStyle(color: AppColors.statusGreen, fontFamily: 'Rajdhani', fontSize: 14, fontWeight: FontWeight.bold)),
                        const Text('SPD: 120 km/h', style: TextStyle(color: AppColors.statusGreen, fontFamily: 'Rajdhani', fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 16, right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('LAT: ${drone.latitude.toStringAsFixed(4)}', style: const TextStyle(color: AppColors.statusGreen, fontFamily: 'Rajdhani', fontSize: 14, fontWeight: FontWeight.bold)),
                        Text('LNG: ${drone.longitude.toStringAsFixed(4)}', style: const TextStyle(color: AppColors.statusGreen, fontFamily: 'Rajdhani', fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HudGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.statusGreen.withValues(alpha: 0.2)
      ..strokeWidth = 1;
    
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
    
    // Corners
    final cornerPaint = Paint()
      ..color = AppColors.statusGreen
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
      
    const double l = 20;
    canvas.drawPath(ui.Path()..moveTo(0, l)..lineTo(0, 0)..lineTo(l, 0), cornerPaint);
    canvas.drawPath(ui.Path()..moveTo(size.width - l, 0)..lineTo(size.width, 0)..lineTo(size.width, l), cornerPaint);
    canvas.drawPath(ui.Path()..moveTo(0, size.height - l)..lineTo(0, size.height)..lineTo(l, size.height), cornerPaint);
    canvas.drawPath(ui.Path()..moveTo(size.width - l, size.height)..lineTo(size.width, size.height)..lineTo(size.width, size.height - l), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
