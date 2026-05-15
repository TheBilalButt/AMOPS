/// ================================================
/// File    : sales_screen.dart
/// Module  : Sales
/// Desc    : Sales intelligence and pipeline management
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/sales_provider.dart';
import '../../widgets/deal_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/stat_card.dart';

class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesState = ref.watch(salesProvider);

    if (salesState.isLoading) return const LoadingWidget();

    return Scaffold(
      appBar: AppBar(title: const Text("Sales Intelligence")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Revenue Pipeline", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                StatCard(label: "Pipeline Value", value: "145M USD", icon: Icons.monetization_on),
                StatCard(label: "Win Rate", value: "68%", icon: Icons.trending_up, iconColor: AppColors.success),
              ],
            ),
            
            const SizedBox(height: 32),
            const Text("Deal Pipeline", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: salesState.deals.length,
              itemBuilder: (context, index) {
                final deal = salesState.deals[index];
                return DealCard(
                  deal: deal,
                  onAdvance: () => ref.read(salesProvider.notifier).advanceDealStage(deal.id, 'Negotiation'),
                );
              },
            ),

            const SizedBox(height: 32),
            const Text("Global Tender Opportunities", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.star, color: AppColors.primary),
                title: const Text("Main Battle Tank Tender"),
                subtitle: const Text("Country: Turkey - Value: 200M"),
                trailing: ElevatedButton(onPressed: () {}, child: const Text("Apply", style: TextStyle(fontSize: 10))),
              ),
            ),
            
            const SizedBox(height: 32),
            const Text("Upcoming Defense Shows", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            _buildShowItem("IDEAS 2026", "Karachi, Pakistan", "Nov 15-18"),
            _buildShowItem("WDS 2026", "Riyadh, Saudi Arabia", "Feb 4-8"),
          ],
        ),
      ),
    );
  }

  Widget _buildShowItem(String title, String location, String date) {
    return Card(
      color: AppColors.surface,
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(location, style: const TextStyle(color: Colors.white60)),
        trailing: Text(date, style: const TextStyle(color: AppColors.primary, fontSize: 12)),
      ),
    );
  }
}
