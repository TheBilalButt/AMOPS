/// ================================================
/// File    : threat_screen.dart
/// Module  : Threats
/// Desc    : Threat intelligence and sector monitoring
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/threat_provider.dart';
import '../../widgets/threat_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/status_badge.dart';

class ThreatScreen extends ConsumerWidget {
  const ThreatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threatState = ref.watch(threatProvider);

    if (threatState.isLoading) return const LoadingWidget();

    final sectors = ['Alpha', 'Bravo', 'Charlie', 'Delta', 'Echo', 'Foxtrot'];
    final Map<String, int> sectorCounts = {};
    for (var threat in threatState.threats) {
      sectorCounts[threat.sector] = (sectorCounts[threat.sector] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Threat Intelligence")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            _buildSummaryCard(threatState.threats),
            const SizedBox(height: 24),

            const Text("Sector Risk Monitor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: sectors.length,
              itemBuilder: (context, index) {
                final sector = sectors[index];
                final count = sectorCounts[sector] ?? 0;
                final risk = count > 3 ? 'High' : (count > 0 ? 'Medium' : 'Low');
                return ThreatCard(sector: sector, count: count, risk: risk);
              },
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Live Threat Feed", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ElevatedButton.icon(
                  onPressed: () async {
                    await ref.read(threatProvider.notifier).runAIAnalysis();
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("AI Analysis Complete"),
                          content: const Text("All active sectors have been reassessed. Threat levels updated in Firestore."),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Acknowledged"))],
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text("Run AI Analysis"),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: threatState.threats.length,
              itemBuilder: (context, index) {
                final threat = threatState.threats[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: StatusBadge(text: threat.risk, color: _getRiskColor(threat.risk)),
                  title: Text(threat.type, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(threat.description, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                  trailing: Text(
                    DateFormat('HH:mm').format(threat.timestamp),
                    style: const TextStyle(color: Colors.white38, fontSize: 10),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            const Text("Historical Threat Data", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("ID", style: TextStyle(color: AppColors.primary))),
                  DataColumn(label: Text("Sector", style: TextStyle(color: AppColors.primary))),
                  DataColumn(label: Text("Type", style: TextStyle(color: AppColors.primary))),
                  DataColumn(label: Text("Risk", style: TextStyle(color: AppColors.primary))),
                ],
                rows: threatState.threats.map((threat) {
                  return DataRow(cells: [
                    DataCell(Text(threat.id.substring(0, 4), style: const TextStyle(color: Colors.white))),
                    DataCell(Text(threat.sector, style: const TextStyle(color: Colors.white))),
                    DataCell(Text(threat.type, style: const TextStyle(color: Colors.white))),
                    DataCell(Text(threat.risk, style: const TextStyle(color: Colors.white))),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(List threats) {
    return Card(
      color: AppColors.card,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem("Detections", threats.length.toString()),
            const VerticalDivider(color: Colors.white10, thickness: 1),
            _buildSummaryItem("High Risk", threats.where((t) => t.risk == 'High').length.toString()),
            const VerticalDivider(color: Colors.white10, thickness: 1),
            _buildSummaryItem("Active Sectors", "6"),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );
  }

  Color _getRiskColor(String risk) {
    if (risk == 'High' || risk == 'Critical') return AppColors.danger;
    if (risk == 'Medium') return AppColors.warning;
    return AppColors.success;
  }
}
