// =============================================================================
// File: vehicle_detail_screen.dart
// Module: Tank Fleet
// Description: Detailed view of a single vehicle with map, charts, AI score.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/military_card.dart';
import '../../shared/widgets/status_badge.dart';

/// Detail screen for a single vehicle with map, fuel/ammo charts, AI readiness.
class VehicleDetailScreen extends ConsumerWidget {
  final String vehicleId;
  const VehicleDetailScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(vehicleDetailProvider(vehicleId));
    if (vehicle == null) {
      return Scaffold(appBar: AppBar(title: const Text('Vehicle Not Found')), body: const Center(child: Text(AppStrings.noData)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle.id} — ${vehicle.name}'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Map
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 200,
              child: FlutterMap(
                options: MapOptions(initialCenter: LatLng(vehicle.latitude, vehicle.longitude), initialZoom: 10),
                children: [
                  TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                  MarkerLayer(markers: [
                    Marker(point: LatLng(vehicle.latitude, vehicle.longitude), width: 40, height: 40,
                      child: Container(
                        decoration: BoxDecoration(color: AppColors.statusGreen.withValues(alpha: 0.3), shape: BoxShape.circle, border: Border.all(color: AppColors.statusGreen, width: 2)),
                        child: const Icon(Icons.shield, color: AppColors.statusGreen, size: 18),
                      )),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Status and type
          Row(children: [
            StatusBadge(label: vehicle.type, color: AppColors.statusBlue),
            const SizedBox(width: 8),
            StatusBadge(label: vehicle.status),
            const Spacer(),
            Text(vehicle.deploymentLocation, style: Theme.of(context).textTheme.bodyMedium),
          ]),
          const SizedBox(height: 16),
          // AI Readiness Score
          Center(
            child: MilitaryCard(
              gradient: AppColors.militaryGradient,
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CircularPercentIndicator(
                  radius: 40, lineWidth: 7, percent: vehicle.aiReadinessScore / 100,
                  center: Text(vehicle.aiReadinessScore.toStringAsFixed(0), style: TextStyle(color: AppColors.healthColor(vehicle.aiReadinessScore), fontSize: 18, fontWeight: FontWeight.w800)),
                  progressColor: AppColors.healthColor(vehicle.aiReadinessScore), backgroundColor: AppColors.border, circularStrokeCap: CircularStrokeCap.round, animation: true,
                ),
                const SizedBox(width: 20),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('AI Readiness Score', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.accent)),
                  const SizedBox(height: 4),
                  Text(vehicle.deploymentRecommendation, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textPrimary), maxLines: 3, overflow: TextOverflow.ellipsis),
                ])),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          // Fuel and Ammo chart
          MilitaryCard(
            child: SizedBox(
              height: 180,
              child: BarChart(BarChartData(
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: vehicle.fuelLevel, color: AppColors.statusOrange, width: 28, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: vehicle.ammoPercentage, color: AppColors.statusBlue, width: 28, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: vehicle.aiReadinessScore, color: AppColors.statusGreen, width: 28, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))]),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (v, m) => Text('${v.toInt()}', style: const TextStyle(color: AppColors.textTertiary, fontSize: 10)))),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) {
                    const labels = ['Fuel', 'Ammo', 'Ready'];
                    return Padding(padding: const EdgeInsets.only(top: 8), child: Text(v.toInt() < labels.length ? labels[v.toInt()] : '', style: const TextStyle(color: AppColors.textTertiary, fontSize: 11)));
                  })),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: AppColors.border, strokeWidth: 1)),
                borderData: FlBorderData(show: false),
                maxY: 100,
              )),
            ),
          ),
          const SizedBox(height: 16),
          // Info grid
          GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.5, children: [
            _infoTile(context, 'Engine Hours', '${vehicle.engineHours.toStringAsFixed(0)} hrs', Icons.speed),
            _infoTile(context, 'Ammo Count', '${vehicle.ammoCount}/${vehicle.ammoCapacity}', Icons.gps_fixed),
            _infoTile(context, 'Fuel Level', '${vehicle.fuelLevel.toStringAsFixed(0)}%', Icons.local_gas_station),
            _infoTile(context, 'Last Service', '${DateTime.now().difference(vehicle.lastServiceDate).inDays}d ago', Icons.build),
          ]),
          const SizedBox(height: 16),
          // Maintenance history
          Text('MAINTENANCE HISTORY', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.textSecondary, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          if (vehicle.maintenanceHistory.isEmpty)
            MilitaryCard(padding: const EdgeInsets.all(20), child: Center(child: Text('No records', style: Theme.of(context).textTheme.bodyMedium)))
          else
            ...vehicle.maintenanceHistory.map((m) => Padding(padding: const EdgeInsets.only(bottom: 8), child: MilitaryCard(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Text(m.type, style: Theme.of(context).textTheme.titleMedium), const Spacer(), Text('PKR ${m.cost.toStringAsFixed(0)}', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600))]),
              const SizedBox(height: 4),
              Text(m.description, style: Theme.of(context).textTheme.bodyMedium),
              Text('By: ${m.technician}', style: Theme.of(context).textTheme.bodySmall),
            ])))),
        ]),
      ),
    );
  }

  Widget _infoTile(BuildContext context, String label, String value, IconData icon) {
    return MilitaryCard(padding: const EdgeInsets.all(10), child: Row(children: [
      Icon(icon, color: AppColors.accent, size: 18),
      const SizedBox(width: 8),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ]),
    ]));
  }
}
