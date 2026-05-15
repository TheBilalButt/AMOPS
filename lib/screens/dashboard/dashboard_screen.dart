/// ================================================
/// File    : dashboard_screen.dart
/// Module  : Dashboard
/// Desc    : Command and control overview
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/drone_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../providers/maintenance_provider.dart';
import '../../providers/alert_provider.dart';
import '../../providers/threat_provider.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/loading_widget.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final droneState = ref.watch(droneProvider);
    final vehicleState = ref.watch(vehicleProvider);
    final maintState = ref.watch(maintenanceProvider);
    final alertState = ref.watch(alertProvider);
    final threatState = ref.watch(threatProvider);

    if (droneState.isLoading || vehicleState.isLoading) {
      return const LoadingWidget(message: "Loading Intelligence...");
    }

    // Calculations
    final activeDrones = droneState.drones.where((d) => d.status == 'Active').length;
    final activeTanks = vehicleState.vehicles.where((v) => v.status == 'Operational' && v.type == 'Tank').length;
    final underMaint = maintState.logs.where((l) => l.status == 'Open').length;
    final criticalAlerts = alertState.alerts.where((a) => a.level == 'Critical').length;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.dashboard)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                StatCard(
                  label: "Active Drones",
                  value: activeDrones.toString(),
                  icon: Icons.airplanemode_active,
                ),
                StatCard(
                  label: "Active Tanks",
                  value: activeTanks.toString(),
                  icon: Icons.security,
                  iconColor: AppColors.success,
                ),
                StatCard(
                  label: "Under Maintenance",
                  value: underMaint.toString(),
                  icon: Icons.build,
                  iconColor: AppColors.warning,
                ),
                StatCard(
                  label: "Critical Alerts",
                  value: criticalAlerts.toString(),
                  icon: Icons.warning_amber,
                  iconColor: AppColors.danger,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // AI Threat Level
            _buildThreatLevelCard(threatState.threats),
            const SizedBox(height: 16),

            // Fleet Health
            _buildFleetHealthCard(vehicleState.vehicles),
            const SizedBox(height: 24),

            // Chart
            const Text(
              "7 Day Fleet Activity",
              style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildActivityChart(),
            const SizedBox(height: 24),

            // Recent Alerts
            const Text(
              "Recent Intelligence Alerts",
              style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: alertState.alerts.take(5).length,
              itemBuilder: (context, index) {
                final alert = alertState.alerts[index];
                return ListTile(
                  leading: Icon(
                    alert.level == 'Critical' ? Icons.error : Icons.warning,
                    color: alert.level == 'Critical' ? AppColors.danger : AppColors.warning,
                  ),
                  title: Text(alert.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(alert.message, style: const TextStyle(color: Colors.white60)),
                  trailing: Text(
                    "${alert.timestamp.hour}:${alert.timestamp.minute}",
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThreatLevelCard(List threats) {
    String level = "LOW";
    Color color = AppColors.success;
    
    if (threats.any((t) => t.risk == 'Critical')) {
      level = "CRITICAL";
      color = AppColors.danger;
    } else if (threats.any((t) => t.risk == 'High')) {
      level = "HIGH";
      color = AppColors.warning;
    } else if (threats.any((t) => t.risk == 'Medium')) {
      level = "MEDIUM";
      color = Colors.orange;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.psychology, color: AppColors.primary, size: 40),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("AI Threat Level", style: TextStyle(color: Colors.white60)),
                Text(
                  level,
                  style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFleetHealthCard(List vehicles) {
    if (vehicles.isEmpty) return const SizedBox();
    
    final avgReadiness = vehicles.map((v) => v.readiness).reduce((a, b) => a + b) / vehicles.length;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Fleet Health Score", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text("${avgReadiness.toInt()}%", style: const TextStyle(color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: avgReadiness / 100,
              backgroundColor: Colors.white10,
              color: avgReadiness > 80 ? AppColors.success : (avgReadiness > 50 ? AppColors.warning : AppColors.danger),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 3), FlSpot(1, 4), FlSpot(2, 3.5), FlSpot(3, 5), FlSpot(4, 4), FlSpot(5, 6), FlSpot(6, 5),
              ],
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: const [
                FlSpot(0, 2), FlSpot(1, 2.5), FlSpot(2, 2), FlSpot(3, 3), FlSpot(4, 2.8), FlSpot(5, 4), FlSpot(6, 3.5),
              ],
              isCurved: true,
              color: AppColors.success,
              barWidth: 3,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
