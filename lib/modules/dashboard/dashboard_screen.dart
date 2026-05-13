// =============================================================================
// File: dashboard_screen.dart
// Module: Dashboard
// Description: Executive Command Dashboard - main screen shown after login.
//              Displays fleet stats, threat level, alerts, charts, AI briefing.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_values.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/military_card.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/status_badge.dart';

/// Executive Command Dashboard screen.
/// Shows aggregated fleet stats, threat level, alerts, and AI briefing.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.security, color: AppColors.accent, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(AppStrings.dashboardTitle),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildStatCards(context, ref),
            const SizedBox(height: 16),
            _buildThreatAndHealth(context, ref),
            const SizedBox(height: 16),
            _buildQuickStats(context, ref),
            const SizedBox(height: 16),
            const SectionHeader(title: AppStrings.aiBriefing, icon: Icons.smart_toy),
            _buildAIBriefing(context, ref),
            const SizedBox(height: 16),
            const SectionHeader(title: AppStrings.recentAlerts, icon: Icons.warning_amber),
            _buildAlertsList(context, ref),
            const SizedBox(height: 16),
            const SectionHeader(title: AppStrings.assetActivity, icon: Icons.show_chart),
            _buildActivityChart(context),
          ],
        ),
      ),
    );
  }

  /// Builds the 4 stat cards in a 2x2 grid.
  Widget _buildStatCards(BuildContext context, WidgetRef ref) {
    final activeDrones = ref.watch(activeDroneCountProvider);
    final activeVehicles = ref.watch(activeVehicleCountProvider);
    final maintenanceCount = ref.watch(maintenanceCountProvider);
    final criticalAlerts = ref.watch(criticalAlertCountProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.6,
        children: [
          _statCard(context, AppStrings.activeDrones, '$activeDrones', Icons.flight, AppColors.statusBlue),
          _statCard(context, AppStrings.activeTanks, '$activeVehicles', Icons.shield, AppColors.statusGreen),
          _statCard(context, AppStrings.underMaintenance, '$maintenanceCount', Icons.build, AppColors.statusOrange),
          _statCard(context, AppStrings.criticalAlerts, '$criticalAlerts', Icons.warning, AppColors.statusRed),
        ],
      ),
    );
  }

  /// Individual stat card widget.
  Widget _statCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return MilitaryCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Icon(Icons.trending_up, color: color.withValues(alpha: 0.5), size: 16),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(color: color),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Builds threat level indicator and fleet health gauge side by side.
  Widget _buildThreatAndHealth(BuildContext context, WidgetRef ref) {
    final threatLevel = ref.watch(overallThreatLevelProvider);
    final fleetHealth = ref.watch(fleetHealthScoreProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Threat Level Card
          Expanded(
            child: MilitaryCard(
              borderColor: AppColors.threatColor(threatLevel).withValues(alpha: 0.5),
              child: Column(
                children: [
                  Text(
                    AppStrings.threatLevel.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.threatColor(threatLevel).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppValues.radiusRound),
                      border: Border.all(color: AppColors.threatColor(threatLevel).withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      threatLevel.toUpperCase(),
                      style: TextStyle(
                        color: AppColors.threatColor(threatLevel),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ['Low', 'Med', 'High', 'Crit'].map((l) {
                      final isActive = _isLevelActive(threatLevel, l);
                      return Container(
                        width: 8, height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive ? AppColors.threatColor(l == 'Med' ? 'Medium' : l == 'Crit' ? 'Critical' : l) : AppColors.border,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Fleet Health Score
          Expanded(
            child: MilitaryCard(
              child: Column(
                children: [
                  Text(
                    AppStrings.fleetHealth.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 12),
                  CircularPercentIndicator(
                    radius: 45,
                    lineWidth: 8,
                    percent: fleetHealth / 100,
                    center: Text(
                      '${fleetHealth.toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: AppColors.healthColor(fleetHealth),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    progressColor: AppColors.healthColor(fleetHealth),
                    backgroundColor: AppColors.border,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    animationDuration: 1200,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Checks if a threat level dot should be active.
  bool _isLevelActive(String current, String level) {
    final currentMap = {'Low': 0, 'Medium': 1, 'High': 2, 'Critical': 3};
    final levelMap = {'Low': 0, 'Med': 1, 'High': 2, 'Crit': 3};
    return (levelMap[level] ?? 0) <= (currentMap[current] ?? 0);
  }

  /// Quick stats bar showing fuel avg, battery avg, ammo status.
  Widget _buildQuickStats(BuildContext context, WidgetRef ref) {
    final avgBattery = ref.watch(avgBatteryProvider);
    final avgFuel = ref.watch(avgFuelProvider);
    final avgAmmo = ref.watch(avgAmmoProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MilitaryCard(
        child: Row(
          children: [
            _quickStat(context, AppStrings.fuelAverage, '${avgFuel.toStringAsFixed(0)}%', Icons.local_gas_station, AppColors.statusOrange),
            _verticalDivider(),
            _quickStat(context, AppStrings.batteryAverage, '${avgBattery.toStringAsFixed(0)}%', Icons.battery_charging_full, AppColors.statusGreen),
            _verticalDivider(),
            _quickStat(context, AppStrings.ammoStatus, '${avgAmmo.toStringAsFixed(0)}%', Icons.gps_fixed, AppColors.statusBlue),
          ],
        ),
      ),
    );
  }

  Widget _quickStat(BuildContext context, String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(width: 1, height: 50, color: AppColors.border);
  }

  /// AI daily briefing card.
  Widget _buildAIBriefing(BuildContext context, WidgetRef ref) {
    final activeDrones = ref.watch(activeDroneCountProvider);
    final activeVehicles = ref.watch(activeVehicleCountProvider);
    final threatLevel = ref.watch(overallThreatLevelProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MilitaryCard(
        gradient: AppColors.militaryGradient,
        borderColor: AppColors.primaryLight.withValues(alpha: 0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.accent, size: 18),
                const SizedBox(width: 8),
                Text(
                  'AI COMMAND BRIEFING',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                Text(
                  'TODAY',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.accent),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Commander, $activeDrones drones are currently active across operational sectors. '
              '$activeVehicles ground vehicles are ready for deployment. '
              'Current threat level is $threatLevel. '
              '${threatLevel == "Critical" || threatLevel == "High" ? "Recommend increasing patrol frequency and activating reserve assets." : "All sectors report normal activity. Standard operations continue."} '
              'Logistics supply chain is on schedule with 2 deliveries in transit.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary.withValues(alpha: 0.85),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Recent alerts list (last 5).
  Widget _buildAlertsList(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(alertListProvider).take(5).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: alerts.map((alert) {
          final color = alert.severity == 'Critical'
              ? AppColors.statusRed
              : alert.severity == 'Warning'
                  ? AppColors.statusOrange
                  : AppColors.statusBlue;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: MilitaryCard(
              padding: const EdgeInsets.all(12),
              borderColor: color.withValues(alpha: 0.3),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _timeAgo(alert.timestamp),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(label: alert.severity, color: color),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Formats a DateTime as a human-readable "time ago" string.
  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  /// 7-day asset activity line chart.
  Widget _buildActivityChart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MilitaryCard(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 5,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: AppColors.border,
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(color: AppColors.textTertiary, fontSize: 10),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                      if (value.toInt() < days.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(days[value.toInt()], style: const TextStyle(color: AppColors.textTertiary, fontSize: 10)),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              minX: 0, maxX: 6, minY: 0, maxY: 25,
              lineBarsData: [
                // Drone activity
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 8), FlSpot(1, 10), FlSpot(2, 7), FlSpot(3, 12),
                    FlSpot(4, 9), FlSpot(5, 14), FlSpot(6, 11),
                  ],
                  isCurved: true,
                  color: AppColors.chartLine2,
                  barWidth: 2.5,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: true, color: AppColors.chartLine2.withValues(alpha: 0.1)),
                ),
                // Vehicle activity
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 12), FlSpot(1, 11), FlSpot(2, 14), FlSpot(3, 10),
                    FlSpot(4, 15), FlSpot(5, 13), FlSpot(6, 16),
                  ],
                  isCurved: true,
                  color: AppColors.chartLine1,
                  barWidth: 2.5,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: true, color: AppColors.chartLine1.withValues(alpha: 0.1)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
