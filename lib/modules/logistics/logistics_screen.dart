// =============================================================================
// File: logistics_screen.dart
// Module: Logistics
// Description: Logistics and supply chain with inventory, deliveries, charts.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/military_card.dart';
import '../../shared/widgets/status_badge.dart';
import '../../shared/widgets/section_header.dart';
import 'package:intl/intl.dart';

/// Logistics screen with fuel/ammo inventory, deliveries, supplier scores.
class LogisticsScreen extends ConsumerWidget {
  const LogisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory = ref.watch(inventoryProvider);
    final deliveries = ref.watch(deliveryProvider);
    final suppliers = ref.watch(supplierScoreProvider);
    final lowStock = ref.watch(lowStockAlertProvider);

    final fuelItems = inventory.where((i) => i.category == 'Fuel').toList();
    final ammoItems = inventory.where((i) => i.category == 'Ammunition').toList();
    final spareItems = inventory.where((i) => i.category == 'Spare Parts').toList();

    return Scaffold(
      appBar: AppBar(title: Row(children: [
        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.inventory_2, color: AppColors.accent, size: 20)),
        const SizedBox(width: 10),
        const Text(AppStrings.logisticsTitle),
      ])),
      body: SingleChildScrollView(padding: const EdgeInsets.only(bottom: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Low stock alerts
        if (lowStock.isNotEmpty) ...[
          Padding(padding: const EdgeInsets.all(16), child: MilitaryCard(
            borderColor: AppColors.statusRed.withValues(alpha: 0.4),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.warning_amber, color: AppColors.statusRed, size: 18),
                const SizedBox(width: 8),
                Text('LOW STOCK ALERTS', style: TextStyle(color: AppColors.statusRed, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
              ]),
              const SizedBox(height: 8),
              ...lowStock.map((item) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [
                Text('• ${item.name}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.statusRed)),
                const Spacer(),
                Text('${item.currentStock.toStringAsFixed(0)} / ${item.maxCapacity.toStringAsFixed(0)} ${item.unit}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.statusRed)),
              ]))),
            ]),
          )),
        ],
        // Fuel Inventory Chart
        const SectionHeader(title: AppStrings.fuelInventory, icon: Icons.local_gas_station),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: MilitaryCard(
          child: SizedBox(height: 180, child: BarChart(BarChartData(
            barGroups: fuelItems.asMap().entries.map((e) => BarChartGroupData(x: e.key, barRods: [
              BarChartRodData(toY: e.value.stockPercentage, color: e.value.isLowStock ? AppColors.statusRed : AppColors.statusOrange, width: 30, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
            ])).toList(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (v, m) => Text('${v.toInt()}%', style: const TextStyle(color: AppColors.textTertiary, fontSize: 9)))),
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) {
                if (v.toInt() < fuelItems.length) {
                  return Padding(padding: const EdgeInsets.only(top: 6), child: Text(fuelItems[v.toInt()].name.split('(').first.trim(), style: const TextStyle(color: AppColors.textTertiary, fontSize: 9), textAlign: TextAlign.center));
                }
                return const SizedBox();
              })),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: AppColors.border, strokeWidth: 1)),
            borderData: FlBorderData(show: false), maxY: 100,
          ))),
        )),
        const SizedBox(height: 16),
        // Ammo stock
        const SectionHeader(title: AppStrings.ammoStock, icon: Icons.gps_fixed),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: ammoItems.map((item) {
          final color = item.isLowStock ? AppColors.statusRed : AppColors.statusGreen;
          return Padding(padding: const EdgeInsets.only(bottom: 8), child: MilitaryCard(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(item.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textPrimary))),
              Text('${NumberFormat('#,###').format(item.currentStock)} ${item.unit}', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 6),
            LinearPercentIndicator(lineHeight: 6, percent: (item.stockPercentage / 100).clamp(0.0, 1.0), backgroundColor: AppColors.border, progressColor: color, barRadius: const Radius.circular(3), padding: EdgeInsets.zero),
          ])));
        }).toList())),
        const SizedBox(height: 16),
        // Spare parts
        const SectionHeader(title: AppStrings.spareParts, icon: Icons.settings),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: spareItems.map((item) => Padding(padding: const EdgeInsets.only(bottom: 8), child: MilitaryCard(padding: const EdgeInsets.all(12), child: Row(children: [
          const Icon(Icons.settings, color: AppColors.textTertiary, size: 16),
          const SizedBox(width: 10),
          Expanded(child: Text(item.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textPrimary))),
          Text('${item.currentStock.toStringAsFixed(0)} ${item.unit}', style: TextStyle(color: item.isLowStock ? AppColors.statusRed : AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
        ])))).toList())),
        const SizedBox(height: 16),
        // Delivery tracking
        const SectionHeader(title: AppStrings.deliveryTracking, icon: Icons.local_shipping),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: deliveries.map((d) => Padding(padding: const EdgeInsets.only(bottom: 8), child: MilitaryCard(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Text(d.id, style: Theme.of(context).textTheme.headlineSmall), const Spacer(), StatusBadge(label: d.status)]),
          const SizedBox(height: 4),
          Text(d.description, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Row(children: [Text('${d.origin} → ${d.destination}', style: Theme.of(context).textTheme.bodySmall)]),
          const SizedBox(height: 6),
          LinearPercentIndicator(lineHeight: 4, percent: d.progress, backgroundColor: AppColors.border, progressColor: AppColors.statusGreen, barRadius: const Radius.circular(2), padding: EdgeInsets.zero),
        ])))).toList())),
        const SizedBox(height: 16),
        // Supplier scores
        const SectionHeader(title: AppStrings.supplierScores, icon: Icons.star),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: suppliers.map((s) => Padding(padding: const EdgeInsets.only(bottom: 8), child: MilitaryCard(padding: const EdgeInsets.all(12), child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.name, style: Theme.of(context).textTheme.titleMedium),
            Text('${s.totalOrders} orders • ${s.defectiveOrders} defects', style: Theme.of(context).textTheme.bodySmall),
          ])),
          Column(children: [
            Text('${s.overallScore.toStringAsFixed(0)}%', style: TextStyle(color: AppColors.healthColor(s.overallScore), fontSize: 18, fontWeight: FontWeight.w800)),
            Text('Score', style: Theme.of(context).textTheme.bodySmall),
          ]),
        ])))).toList())),
        // Demand Forecast chart
        const SizedBox(height: 16),
        const SectionHeader(title: AppStrings.demandForecast, icon: Icons.trending_up),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: MilitaryCard(child: SizedBox(height: 180, child: LineChart(LineChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: AppColors.border, strokeWidth: 1)),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (v, m) => Text('${v.toInt()}', style: const TextStyle(color: AppColors.textTertiary, fontSize: 9)))),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) {
              const labels = ['W1', 'W2', 'W3', 'W4'];
              return v.toInt() < labels.length ? Text(labels[v.toInt()], style: const TextStyle(color: AppColors.textTertiary, fontSize: 10)) : const SizedBox();
            })),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false), minX: 0, maxX: 3, minY: 0, maxY: 100,
          lineBarsData: [
            LineChartBarData(spots: const [FlSpot(0, 45), FlSpot(1, 55), FlSpot(2, 62), FlSpot(3, 75)], isCurved: true, color: AppColors.statusOrange, barWidth: 2.5, dotData: const FlDotData(show: false), belowBarData: BarAreaData(show: true, color: AppColors.statusOrange.withValues(alpha: 0.1))),
            LineChartBarData(spots: const [FlSpot(0, 70), FlSpot(1, 60), FlSpot(2, 50), FlSpot(3, 40)], isCurved: true, color: AppColors.statusBlue, barWidth: 2.5, dotData: const FlDotData(show: false), belowBarData: BarAreaData(show: true, color: AppColors.statusBlue.withValues(alpha: 0.1))),
          ],
        ))))),
      ])),
    );
  }
}
