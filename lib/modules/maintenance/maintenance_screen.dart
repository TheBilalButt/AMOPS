// =============================================================================
// File: maintenance_screen.dart
// Module: Maintenance
// Description: Predictive maintenance with health scores, failure timeline,
//              work orders, and AI fault intelligence.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/military_card.dart';
import '../../shared/widgets/status_badge.dart';
import '../../shared/widgets/section_header.dart';
import 'package:intl/intl.dart';

/// Maintenance screen with health scores, failure predictions, work orders.
class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthList = ref.watch(vehicleHealthProvider);
    final workOrders = ref.watch(workOrderProvider);
    final fleetHealth = ref.watch(fleetHealthScoreProvider);

    return Scaffold(
      appBar: AppBar(title: Row(children: [
        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.statusOrange.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.build, color: AppColors.statusOrange, size: 20)),
        const SizedBox(width: 10),
        const Text(AppStrings.maintenanceTitle),
      ])),
      body: SingleChildScrollView(padding: const EdgeInsets.only(bottom: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Fleet health summary
        Padding(padding: const EdgeInsets.all(16), child: MilitaryCard(
          gradient: AppColors.militaryGradient,
          child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('FLEET HEALTH SCORE', style: Theme.of(context).textTheme.bodySmall),
              Text('${fleetHealth.toStringAsFixed(1)}%', style: TextStyle(color: AppColors.healthColor(fleetHealth), fontSize: 32, fontWeight: FontWeight.w800)),
            ]),
            const Spacer(),
            Column(children: [
              Text('${healthList.where((h) => h.healthScore < 40).length}', style: TextStyle(color: AppColors.statusRed, fontSize: 24, fontWeight: FontWeight.w800)),
              Text('Critical', style: Theme.of(context).textTheme.bodySmall),
            ]),
            const SizedBox(width: 16),
            Column(children: [
              Text('${healthList.where((h) => h.healthScore >= 40 && h.healthScore < 70).length}', style: TextStyle(color: AppColors.statusOrange, fontSize: 24, fontWeight: FontWeight.w800)),
              Text('Warning', style: Theme.of(context).textTheme.bodySmall),
            ]),
          ]),
        )),
        // Vehicle Health Scores
        const SectionHeader(title: AppStrings.vehicleHealthScores, icon: Icons.monitor_heart),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: healthList.map((h) {
          final color = AppColors.healthColor(h.healthScore);
          return Padding(padding: const EdgeInsets.only(bottom: 8), child: MilitaryCard(
            padding: const EdgeInsets.all(12),
            borderColor: h.healthScore < 40 ? AppColors.statusRed.withValues(alpha: 0.4) : null,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(h.vehicleName, style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Text('${h.healthScore.toStringAsFixed(0)}%', style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 6),
              LinearPercentIndicator(lineHeight: 6, percent: h.healthScore / 100, backgroundColor: AppColors.border, progressColor: color, barRadius: const Radius.circular(3), padding: EdgeInsets.zero, animation: true),
              const SizedBox(height: 6),
              Row(children: [
                Text('Predicted: ${h.predictedFailureType}', style: Theme.of(context).textTheme.bodySmall),
                const Spacer(),
                Text('ETA: ${DateFormat('dd MMM yyyy').format(h.predictedFailureDate)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: h.predictedFailureDate.difference(DateTime.now()).inDays < 30 ? AppColors.statusRed : null)),
              ]),
              if (h.healthScore < 40) ...[const SizedBox(height: 6), Row(children: [
                const Icon(Icons.auto_awesome, color: AppColors.accent, size: 14),
                const SizedBox(width: 4),
                Text('Cost Est: PKR ${NumberFormat('#,###').format(h.maintenanceCostEstimate)}', style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w600)),
              ])],
            ]),
          ));
        }).toList())),
        const SizedBox(height: 16),
        // Work Orders
        const SectionHeader(title: AppStrings.workOrders, icon: Icons.assignment),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: workOrders.map((w) {
          final prioColor = w.priority == 'Critical' ? AppColors.statusRed : w.priority == 'High' ? AppColors.statusOrange : AppColors.statusBlue;
          return Padding(padding: const EdgeInsets.only(bottom: 8), child: MilitaryCard(
            padding: const EdgeInsets.all(12),
            borderColor: prioColor.withValues(alpha: 0.3),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(w.id, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(width: 8),
                StatusBadge(label: w.priority, color: prioColor),
                const Spacer(),
                StatusBadge(label: w.status),
              ]),
              const SizedBox(height: 4),
              Text(w.vehicleName, style: Theme.of(context).textTheme.titleMedium),
              Text(w.description, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Row(children: [
                Text('Assigned: ${w.assignedTechnician}', style: Theme.of(context).textTheme.bodySmall),
                const Spacer(),
                Text('PKR ${NumberFormat('#,###').format(w.estimatedCost)}', style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w600)),
              ]),
            ]),
          ));
        }).toList())),
      ])),
    );
  }
}
