/// ================================================
/// File    : manufacturing_screen.dart
/// Module  : Manufacturing
/// Desc    : Production line and quality control
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/manufacturing_provider.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/stat_card.dart';

class ManufacturingScreen extends ConsumerWidget {
  const ManufacturingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mfgState = ref.watch(manufacturingProvider);

    if (mfgState.isLoading) return const LoadingWidget();

    return Scaffold(
      appBar: AppBar(title: const Text("Factory Management")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Factory Performance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                StatCard(label: "Total Orders", value: mfgState.orders.length.toString(), icon: Icons.assignment),
                StatCard(label: "Efficiency", value: "94%", icon: Icons.speed, iconColor: AppColors.success),
              ],
            ),
            
            const SizedBox(height: 32),
            const Text("Production Orders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mfgState.orders.length,
              itemBuilder: (context, index) {
                final order = mfgState.orders[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(order.vehicleType, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            StatusBadge(text: order.status, color: order.status == 'Completed' ? AppColors.success : AppColors.primary),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(value: order.progress / 100, color: AppColors.primary, backgroundColor: Colors.white10),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Progress: ${order.progress}%", style: const TextStyle(color: Colors.white60, fontSize: 12)),
                            Text("Delivery: ${order.expectedDate}", style: const TextStyle(color: Colors.white38, fontSize: 10)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: order.progress < 100 
                                ? () => ref.read(manufacturingProvider.notifier).incrementProgress(order.id)
                                : null,
                            child: const Text("Advance Production"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),
            const Text("Quality Control Feed", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            const Card(
              child: ListTile(
                leading: Icon(Icons.check_circle, color: AppColors.success),
                title: Text("QC Pass: TANK-001"),
                subtitle: Text("All systems operational - 100% compliance"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
