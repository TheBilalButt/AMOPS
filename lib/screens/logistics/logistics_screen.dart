/// ================================================
/// File    : logistics_screen.dart
/// Module  : Logistics
/// Desc    : Inventory management and resupply requests
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/logistics_provider.dart';
import '../../widgets/supply_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/stat_card.dart';

class LogisticsScreen extends ConsumerWidget {
  const LogisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logisticsState = ref.watch(logisticsProvider);

    if (logisticsState.isLoading) return const LoadingWidget();

    // AI Suggestion Logic
    final lowStockItem = logisticsState.supplies.isEmpty 
        ? null 
        : logisticsState.supplies.reduce((a, b) => a.current < b.current ? a : b);

    return Scaffold(
      appBar: AppBar(title: const Text("Logistics & Inventory")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Suggestion Card
            if (lowStockItem != null && lowStockItem.current < lowStockItem.threshold)
              _buildAISuggestionCard(lowStockItem),
            
            const SizedBox(height: 24),
            const Text("Inventory Status", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: logisticsState.supplies.map((supply) {
                return StatCard(
                  label: supply.name,
                  value: "${supply.current}${supply.unit == 'percent' ? '%' : ''}",
                  icon: _getIconForSupply(supply.name),
                  iconColor: supply.current < supply.threshold ? AppColors.danger : AppColors.success,
                );
              }).toList(),
            ),

            const SizedBox(height: 32),
            const Text("Detailed Stock Management", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logisticsState.supplies.length,
              itemBuilder: (context, index) {
                final supply = logisticsState.supplies[index];
                return SupplyCard(
                  supply: supply,
                  onResupply: () => ref.read(logisticsProvider.notifier).triggerResupply(supply.id, 20),
                );
              },
            ),

            const SizedBox(height: 32),
            const Text("Pending Supply Requests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Card(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) => ListTile(
                  leading: const CircleAvatar(backgroundColor: AppColors.primary, child: Icon(Icons.local_shipping, color: Colors.black)),
                  title: Text(index == 0 ? "Ammunition 5.56mm" : "Diesel Fuel"),
                  subtitle: Text("ETA: ${index + 2} Hours"),
                  trailing: const Text("PENDING", style: TextStyle(color: AppColors.warning, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAISuggestionCard(supply) {
    return Card(
      color: AppColors.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        border: const BorderSide(color: AppColors.primary, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.primary, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("AI LOGISTICS RECOMMENDATION", style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    "Stock of ${supply.name} is critical (${supply.current}%). It is highly recommended to trigger an immediate resupply to avoid mission failure.",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForSupply(String name) {
    if (name.contains("Fuel")) return Icons.local_gas_station;
    if (name.contains("Ammunition")) return Icons.adjust;
    if (name.contains("Medical")) return Icons.medical_services;
    return Icons.inventory_2;
  }
}
