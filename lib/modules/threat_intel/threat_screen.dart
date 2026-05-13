// =============================================================================
// File: threat_screen.dart
// Module: Threat Intelligence
// Description: Threat intelligence engine with map, feed, radar, and AI logic.
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
import '../../shared/widgets/section_header.dart';

/// Threat intelligence screen with live map, feed, radar alerts, sector counts.
class ThreatScreen extends ConsumerWidget {
  const ThreatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threats = ref.watch(threatListProvider);
    final radarAlerts = ref.watch(radarAlertProvider);
    final sectorCounts = ref.watch(sectorThreatCountProvider);
    final overallLevel = ref.watch(overallThreatLevelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.statusRed.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.shield, color: AppColors.statusRed, size: 20)),
          const SizedBox(width: 10),
          const Text(AppStrings.threatIntelTitle),
        ]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Overall threat level
          Padding(padding: const EdgeInsets.all(16), child: MilitaryCard(
            borderColor: AppColors.threatColor(overallLevel).withValues(alpha: 0.5),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.threatColor(overallLevel).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.warning_amber, color: AppColors.threatColor(overallLevel), size: 24)),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('OVERALL THREAT LEVEL', style: Theme.of(context).textTheme.bodySmall),
                Text(overallLevel.toUpperCase(), style: TextStyle(color: AppColors.threatColor(overallLevel), fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 2)),
              ]),
              const Spacer(),
              Column(children: [
                Text('${threats.length}', style: Theme.of(context).textTheme.displaySmall),
                Text('Events', style: Theme.of(context).textTheme.bodySmall),
              ]),
            ]),
          )),
          // Threat Map
          const SectionHeader(title: AppStrings.liveThreatMap, icon: Icons.map),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(height: 250, child: FlutterMap(
              options: MapOptions(initialCenter: const LatLng(31.5, 71.0), initialZoom: 5.5),
              children: [
                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                MarkerLayer(markers: threats.map((t) => Marker(
                  point: LatLng(t.latitude, t.longitude), width: 24, height: 24,
                  child: Container(decoration: BoxDecoration(color: AppColors.threatColor(t.riskLevel).withValues(alpha: 0.6), shape: BoxShape.circle, border: Border.all(color: AppColors.threatColor(t.riskLevel), width: 2)),
                    child: Icon(Icons.circle, color: AppColors.threatColor(t.riskLevel), size: 8)),
                )).toList()),
              ],
            )),
          )),
          const SizedBox(height: 16),
          // Sector Detection Counter
          const SectionHeader(title: AppStrings.detectionCounter, icon: Icons.radar),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Wrap(spacing: 8, runSpacing: 8,
            children: sectorCounts.entries.map((e) {
              final isEscalated = e.value >= 3;
              return MilitaryCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                borderColor: isEscalated ? AppColors.statusRed.withValues(alpha: 0.5) : null,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(e.key, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(width: 8),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: (isEscalated ? AppColors.statusRed : AppColors.statusBlue).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                    child: Text('${e.value}', style: TextStyle(color: isEscalated ? AppColors.statusRed : AppColors.statusBlue, fontSize: 13, fontWeight: FontWeight.w700))),
                  if (isEscalated) ...[const SizedBox(width: 4), const Icon(Icons.trending_up, color: AppColors.statusRed, size: 14)],
                ]),
              );
            }).toList(),
          )),
          const SizedBox(height: 16),
          // Radar Alerts
          const SectionHeader(title: AppStrings.radarAlerts, icon: Icons.radar),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: radarAlerts.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: MilitaryCard(padding: const EdgeInsets.all(12), child: Row(children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.statusBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.radar, color: AppColors.statusBlue, size: 18)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.type, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textPrimary)),
                Text('Bearing: ${r.bearing} • Distance: ${r.distance.toStringAsFixed(0)} km', style: Theme.of(context).textTheme.bodySmall),
              ])),
              StatusBadge(label: r.status),
            ])),
          )).toList())),
          const SizedBox(height: 16),
          // Threat Feed
          const SectionHeader(title: AppStrings.threatFeed, icon: Icons.list),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: threats.take(10).map((t) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: MilitaryCard(
              padding: const EdgeInsets.all(12),
              borderColor: AppColors.threatColor(t.riskLevel).withValues(alpha: 0.2),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  StatusBadge(label: t.riskLevel, color: AppColors.threatColor(t.riskLevel)),
                  const SizedBox(width: 8),
                  if (t.isPatternMatch) StatusBadge(label: 'Pattern Match', color: AppColors.accent),
                  if (t.isGeoFenceViolation) StatusBadge(label: 'Geo-Fence', color: AppColors.statusRed),
                  const Spacer(),
                  Text(_timeAgo(t.timestamp), style: Theme.of(context).textTheme.bodySmall),
                ]),
                const SizedBox(height: 6),
                Text(t.type, style: Theme.of(context).textTheme.titleMedium),
                Text(t.description, style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.location_on, size: 12, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                  Text('${t.location} • ${t.sector}', style: Theme.of(context).textTheme.bodySmall),
                ]),
              ]),
            ),
          )).toList())),
        ]),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
