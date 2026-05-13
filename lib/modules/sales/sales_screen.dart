// =============================================================================
// File: sales_screen.dart
// Module: Export Sales
// Description: Export sales intelligence with deal pipeline, tenders,
//              defense events, revenue forecast, and AI win probability.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/military_card.dart';
import '../../shared/widgets/status_badge.dart';
import '../../shared/widgets/section_header.dart';
import 'package:intl/intl.dart';

/// Export sales intelligence screen with pipeline, tenders, events, forecast.
class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deals = ref.watch(dealListProvider);
    final tenders = ref.watch(tenderProvider);
    final events = ref.watch(defenseEventProvider);
    final totalValue = deals.fold(0.0, (sum, d) => sum + d.dealValue);

    return Scaffold(
      appBar: AppBar(title: Row(children: [
        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.statusGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.trending_up, color: AppColors.statusGreen, size: 20)),
        const SizedBox(width: 10),
        const Text(AppStrings.salesTitle),
      ])),
      body: SingleChildScrollView(padding: const EdgeInsets.only(bottom: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Pipeline summary
        Padding(padding: const EdgeInsets.all(16), child: Row(children: [
          Expanded(child: MilitaryCard(padding: const EdgeInsets.all(14), child: Column(children: [
            Text('\$${(totalValue / 1e9).toStringAsFixed(2)}B', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.statusGreen)),
            Text('Pipeline Value', style: Theme.of(context).textTheme.bodySmall),
          ]))),
          const SizedBox(width: 10),
          Expanded(child: MilitaryCard(padding: const EdgeInsets.all(14), child: Column(children: [
            Text('${deals.length}', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.statusBlue)),
            Text('Active Deals', style: Theme.of(context).textTheme.bodySmall),
          ]))),
          const SizedBox(width: 10),
          Expanded(child: MilitaryCard(padding: const EdgeInsets.all(14), child: Column(children: [
            Text('${deals.where((d) => d.stage == 'Closed').length}', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.accent)),
            Text('Won', style: Theme.of(context).textTheme.bodySmall),
          ]))),
        ])),
        // Deal Pipeline
        const SectionHeader(title: AppStrings.dealPipeline, icon: Icons.view_kanban),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: deals.map((deal) {
          final stages = ['Lead', 'Quote', 'Negotiation', 'Contract', 'Closed'];
          final probColor = deal.winProbability >= 80 ? AppColors.statusGreen : deal.winProbability >= 50 ? AppColors.statusOrange : AppColors.statusRed;
          return Padding(padding: const EdgeInsets.only(bottom: 10), child: MilitaryCard(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('🏳️ ${deal.country}', style: Theme.of(context).textTheme.headlineSmall),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: probColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: probColor.withValues(alpha: 0.4))),
                  child: Text('${deal.winProbability.toStringAsFixed(0)}%', style: TextStyle(color: probColor, fontSize: 13, fontWeight: FontWeight.w800)),
                ),
              ]),
              const SizedBox(height: 4),
              Text(deal.product, style: Theme.of(context).textTheme.titleMedium),
              Text('\$${NumberFormat('#,###').format(deal.dealValue)}', style: TextStyle(color: AppColors.accent, fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              // Stage progress
              Row(children: stages.asMap().entries.map((e) {
                final isComplete = e.key <= deal.stageIndex;
                return Expanded(child: Container(
                  height: 4, margin: EdgeInsets.only(right: e.key < stages.length - 1 ? 3 : 0),
                  decoration: BoxDecoration(color: isComplete ? AppColors.accent : AppColors.border, borderRadius: BorderRadius.circular(2)),
                ));
              }).toList()),
              const SizedBox(height: 4),
              Row(children: [
                StatusBadge(label: deal.stage),
                const Spacer(),
                Text('Contact: ${deal.contactPerson}', style: Theme.of(context).textTheme.bodySmall),
              ]),
              // AI Proposal summary
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.surfaceElevated, borderRadius: BorderRadius.circular(8)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.auto_awesome, color: AppColors.accent, size: 14),
                  const SizedBox(width: 6),
                  Expanded(child: Text(deal.proposalSummary, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis)),
                ]),
              ),
            ]),
          ));
        }).toList())),
        const SizedBox(height: 16),
        // Tender Opportunities
        const SectionHeader(title: AppStrings.tenderOpportunities, icon: Icons.description),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: tenders.map((t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: MilitaryCard(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(t.title, style: Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
            StatusBadge(label: t.status),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            Text('${t.country} • ${t.category}', style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            Text('\$${(t.estimatedValue / 1e6).toStringAsFixed(0)}M', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
          ]),
          Text('Deadline: ${DateFormat('dd MMM yyyy').format(t.deadline)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: t.deadline.isBefore(DateTime.now()) ? AppColors.statusRed : null,
          )),
        ])))).toList())),
        const SizedBox(height: 16),
        // Defense Show Calendar
        const SectionHeader(title: AppStrings.defenseShows, icon: Icons.event),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: events.map((e) => Padding(padding: const EdgeInsets.only(bottom: 8), child: MilitaryCard(padding: const EdgeInsets.all(12), child: Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Column(children: [
              Text(DateFormat('dd').format(e.startDate), style: TextStyle(color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.w800)),
              Text(DateFormat('MMM').format(e.startDate), style: TextStyle(color: AppColors.accent, fontSize: 10)),
            ])),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e.name, style: Theme.of(context).textTheme.titleMedium),
            Text(e.location, style: Theme.of(context).textTheme.bodySmall),
            Text(e.description, style: Theme.of(context).textTheme.bodySmall),
          ])),
        ])))).toList())),
        // Revenue Forecast
        const SizedBox(height: 16),
        const SectionHeader(title: AppStrings.revenueForecast, icon: Icons.bar_chart),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: MilitaryCard(child: SizedBox(height: 180, child: BarChart(BarChartData(
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 320, color: AppColors.statusGreen, width: 18, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 850, color: AppColors.statusGreen, width: 18, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 180, color: AppColors.statusGreen, width: 18, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))]),
            BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 95, color: AppColors.statusGreen, width: 18, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))]),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (v, m) => Text('\$${v.toInt()}M', style: const TextStyle(color: AppColors.textTertiary, fontSize: 9)))),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) {
              const labels = ['Middle East', 'Asia', 'Africa', 'Other'];
              return v.toInt() < labels.length ? Padding(padding: const EdgeInsets.only(top: 6), child: Text(labels[v.toInt()], style: const TextStyle(color: AppColors.textTertiary, fontSize: 9))) : const SizedBox();
            })),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: AppColors.border, strokeWidth: 1)),
          borderData: FlBorderData(show: false), maxY: 1000,
        ))))),
      ])),
    );
  }
}
