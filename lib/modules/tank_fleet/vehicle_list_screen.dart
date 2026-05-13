// =============================================================================
// File: vehicle_list_screen.dart
// Module: Tank Fleet
// Description: Displays list of all tanks, APCs, and ASVs with status info.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/models/vehicle_model.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/military_card.dart';
import '../../shared/widgets/status_badge.dart';

/// Vehicle fleet list screen showing all tanks, APCs, and ASVs.
class VehicleListScreen extends ConsumerWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehicleListProvider);
    final bestVehicle = ref.watch(deploymentOptimizerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: AppColors.statusGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.shield, color: AppColors.statusGreen, size: 20),
          ),
          const SizedBox(width: 10),
          const Text(AppStrings.vehicleFleetTitle),
        ]),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // AI Deployment Optimizer card
          if (bestVehicle != null) ...[
            MilitaryCard(
              gradient: AppColors.militaryGradient,
              borderColor: AppColors.accent.withValues(alpha: 0.4),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.auto_awesome, color: AppColors.accent, size: 16),
                  const SizedBox(width: 6),
                  Text('AI DEPLOYMENT OPTIMIZER', style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                ]),
                const SizedBox(height: 8),
                Text('Most Ready: ${bestVehicle.name}', style: Theme.of(context).textTheme.headlineMedium),
                Text('Readiness: ${bestVehicle.aiReadinessScore.toStringAsFixed(0)}% • Fuel: ${bestVehicle.fuelLevel.toStringAsFixed(0)}% • Ammo: ${bestVehicle.ammoPercentage.toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodyMedium),
              ]),
            ),
            const SizedBox(height: 12),
          ],
          // Vehicle list
          ...vehicles.map((v) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildVehicleCard(context, v),
          )),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, VehicleModel vehicle) {
    final typeIcon = vehicle.type == 'Tank' ? Icons.shield : vehicle.type == 'APC' ? Icons.directions_bus : Icons.local_shipping;
    return MilitaryCard(
      onTap: () => context.push('/vehicle/${vehicle.id}'),
      borderColor: vehicle.status == 'Critical' ? AppColors.statusRed.withValues(alpha: 0.4) : null,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(typeIcon, color: AppColors.accent, size: 18),
          const SizedBox(width: 8),
          Text(vehicle.id, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(width: 8),
          StatusBadge(label: vehicle.type, color: AppColors.statusBlue),
          const Spacer(),
          StatusBadge(label: vehicle.status),
        ]),
        const SizedBox(height: 4),
        Text(vehicle.name, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 10),
        // Fuel bar
        _progressRow(context, 'Fuel', vehicle.fuelLevel, Icons.local_gas_station, AppColors.batteryColor(vehicle.fuelLevel)),
        const SizedBox(height: 6),
        // Ammo bar
        _progressRow(context, 'Ammo', vehicle.ammoPercentage, Icons.gps_fixed, AppColors.batteryColor(vehicle.ammoPercentage)),
        const SizedBox(height: 8),
        Row(children: [
          _chip(Icons.speed, '${vehicle.engineHours.toStringAsFixed(0)} hrs'),
          const SizedBox(width: 12),
          _chip(Icons.location_on, vehicle.deploymentLocation),
          const Spacer(),
          Text('AI: ${vehicle.aiReadinessScore.toStringAsFixed(0)}%',
              style: TextStyle(color: AppColors.healthColor(vehicle.aiReadinessScore), fontSize: 12, fontWeight: FontWeight.w700)),
        ]),
        if (vehicle.needsMaintenance) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: AppColors.statusOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.statusOrange.withValues(alpha: 0.3))),
            child: Row(children: [
              const Icon(Icons.build, color: AppColors.statusOrange, size: 14),
              const SizedBox(width: 6),
              Text('Maintenance Required', style: TextStyle(color: AppColors.statusOrange, fontSize: 11, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
        if (vehicle.needsResupply) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: AppColors.statusRed.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.statusRed.withValues(alpha: 0.3))),
            child: Row(children: [
              const Icon(Icons.warning_amber, color: AppColors.statusRed, size: 14),
              const SizedBox(width: 6),
              Text('Resupply Needed', style: TextStyle(color: AppColors.statusRed, fontSize: 11, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
      ]),
    );
  }

  Widget _progressRow(BuildContext context, String label, double value, IconData icon, Color color) {
    return Row(children: [
      Icon(icon, color: color, size: 14),
      const SizedBox(width: 6),
      SizedBox(width: 35, child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
      const SizedBox(width: 6),
      Expanded(child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: LinearProgressIndicator(value: value / 100, backgroundColor: AppColors.border, color: color, minHeight: 5),
      )),
      const SizedBox(width: 8),
      Text('${value.toStringAsFixed(0)}%', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
    ]);
  }

  Widget _chip(IconData icon, String text) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: AppColors.textTertiary),
      const SizedBox(width: 4),
      Text(text, style: const TextStyle(color: AppColors.textTertiary, fontSize: 11), overflow: TextOverflow.ellipsis),
    ]);
  }
}
