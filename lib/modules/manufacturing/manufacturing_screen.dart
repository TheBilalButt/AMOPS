// =============================================================================
// File: manufacturing_screen.dart
// Module: Manufacturing
// Description: Manufacturing and quality control with production orders,
//              quality scores, shift performance, and R&D tracker.
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

/// Manufacturing screen with production orders, quality control, R&D tracker.
class ManufacturingScreen extends ConsumerWidget {
  const ManufacturingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(productionOrderProvider);
    final rdProjects = ref.watch(rdProjectProvider);

    return Scaffold(
      appBar: AppBar(title: Row(children: [
        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.statusBlue.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.precision_manufacturing, color: AppColors.statusBlue, size: 20)),
        const SizedBox(width: 10),
        const Text(AppStrings.manufacturingTitle),
      ])),
      body: SingleChildScrollView(padding: const EdgeInsets.only(bottom: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Production summary
        Padding(padding: const EdgeInsets.all(16), child: Row(children: [
          Expanded(child: MilitaryCard(padding: const EdgeInsets.all(14), child: Column(children: [
            Text('${orders.length}', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.statusBlue)),
            Text('Active Orders', style: Theme.of(context).textTheme.bodySmall),
          ]))),
          const SizedBox(width: 10),
          Expanded(child: MilitaryCard(padding: const EdgeInsets.all(14), child: Column(children: [
            Text('${orders.where((o) => o.hasQualityIssue).length}', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.statusRed)),
            Text('Quality Alerts', style: Theme.of(context).textTheme.bodySmall),
          ]))),
          const SizedBox(width: 10),
          Expanded(child: MilitaryCard(padding: const EdgeInsets.all(14), child: Column(children: [
            Text('${orders.fold(0, (sum, o) => sum + o.defectsFound)}', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.statusOrange)),
            Text('Defects', style: Theme.of(context).textTheme.bodySmall),
          ]))),
        ])),
        // Production Orders
        const SectionHeader(title: AppStrings.activeOrders, icon: Icons.factory),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: orders.map((o) {
          final color = o.hasQualityIssue ? AppColors.statusRed : AppColors.statusGreen;
          return Padding(padding: const EdgeInsets.only(bottom: 10), child: MilitaryCard(
            padding: const EdgeInsets.all(14),
            borderColor: o.hasQualityIssue ? AppColors.statusRed.withValues(alpha: 0.3) : null,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(o.id, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(width: 8),
                StatusBadge(label: o.vehicleType, color: AppColors.statusBlue),
                const Spacer(),
                StatusBadge(label: o.status),
              ]),
              const SizedBox(height: 4),
              Text(o.orderName, style: Theme.of(context).textTheme.titleMedium),
              Text('Qty: ${o.quantity} • Line: ${o.assignedLine}', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Row(children: [
                Text('Progress', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(width: 8),
                Expanded(child: LinearPercentIndicator(lineHeight: 6, percent: o.progressPercentage / 100, backgroundColor: AppColors.border, progressColor: AppColors.statusGreen, barRadius: const Radius.circular(3), padding: EdgeInsets.zero)),
                const SizedBox(width: 8),
                Text('${o.progressPercentage.toStringAsFixed(0)}%', style: TextStyle(color: AppColors.statusGreen, fontSize: 12, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                Text('Quality: ${o.qualityScore.toStringAsFixed(0)}%', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                Text('Defects: ${o.defectsFound}', style: TextStyle(color: o.defectsFound > 0 ? AppColors.statusOrange : AppColors.textTertiary, fontSize: 12)),
                const Spacer(),
                Text('ETA: ${DateFormat('dd MMM').format(o.estimatedCompletion)}', style: Theme.of(context).textTheme.bodySmall),
              ]),
              if (o.hasQualityIssue) ...[const SizedBox(height: 6), Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.statusRed.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.warning_amber, color: AppColors.statusRed, size: 14),
                  const SizedBox(width: 4),
                  Text('Quality Below Threshold', style: TextStyle(color: AppColors.statusRed, fontSize: 11, fontWeight: FontWeight.w600)),
                ]),
              )],
            ]),
          ));
        }).toList())),
        const SizedBox(height: 16),
        // Shift Performance Chart
        const SectionHeader(title: AppStrings.shiftPerformance, icon: Icons.bar_chart),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: MilitaryCard(child: SizedBox(height: 180, child: BarChart(BarChartData(
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 92, color: AppColors.statusGreen, width: 20, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 85, color: AppColors.statusBlue, width: 20, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 78, color: AppColors.statusOrange, width: 20, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))]),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (v, m) => Text('${v.toInt()}', style: const TextStyle(color: AppColors.textTertiary, fontSize: 10)))),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) {
              const labels = ['Morning', 'Evening', 'Night'];
              return v.toInt() < labels.length ? Padding(padding: const EdgeInsets.only(top: 6), child: Text(labels[v.toInt()], style: const TextStyle(color: AppColors.textTertiary, fontSize: 10))) : const SizedBox();
            })),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: AppColors.border, strokeWidth: 1)),
          borderData: FlBorderData(show: false), maxY: 100,
        ))))),
        const SizedBox(height: 16),
        // R&D Tracker
        const SectionHeader(title: AppStrings.rdTracker, icon: Icons.science),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: rdProjects.map((p) => Padding(padding: const EdgeInsets.only(bottom: 8), child: MilitaryCard(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(p.name, style: Theme.of(context).textTheme.titleMedium)),
              StatusBadge(label: p.status),
            ]),
            const SizedBox(height: 4),
            Text(p.description, style: Theme.of(context).textTheme.bodySmall, maxLines: 2),
            const SizedBox(height: 8),
            LinearPercentIndicator(lineHeight: 6, percent: p.completionPercentage / 100, backgroundColor: AppColors.border, progressColor: AppColors.accent, barRadius: const Radius.circular(3), padding: EdgeInsets.zero),
            const SizedBox(height: 4),
            Row(children: [
              Text('${p.completionPercentage.toStringAsFixed(0)}% Complete', style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('Target: ${DateFormat('MMM yyyy').format(p.targetDate)}', style: Theme.of(context).textTheme.bodySmall),
            ]),
          ]),
        ))).toList())),
      ])),
    );
  }
}
