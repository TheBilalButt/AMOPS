/// ================================================
/// File    : maintenance_screen.dart
/// Module  : Maintenance
/// Desc    : Predictive maintenance and fault logging
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/maintenance_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/status_badge.dart';

class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maintState = ref.watch(maintenanceProvider);
    final vehicleState = ref.watch(vehicleProvider);

    if (maintState.isLoading) return const LoadingWidget();

    // Predictions logic
    final atRiskVehicles = vehicleState.vehicles.where((v) => v.engineHours > 500).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Maintenance Control")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("AI Predicted Failures", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            if (atRiskVehicles.isEmpty) 
              const Text("No predictive failures detected.", style: TextStyle(color: Colors.white38))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: atRiskVehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = atRiskVehicles[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.warning_amber, color: AppColors.danger),
                      title: Text(vehicle.id),
                      subtitle: Text("Predicted Issue: Engine Wear (${vehicle.engineHours}h)"),
                      trailing: ElevatedButton(
                        onPressed: () => _assignTechnician(context, vehicle.id),
                        child: const Text("Assign", style: TextStyle(fontSize: 10)),
                      ),
                    ),
                  );
                },
              ),
            
            const SizedBox(height: 32),
            const Text("Active Work Orders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: maintState.logs.length,
              itemBuilder: (context, index) {
                final log = maintState.logs[index];
                return ListTile(
                  leading: const Icon(Icons.engineering, color: AppColors.primary),
                  title: Text("${log.vehicleId} - ${log.fault}"),
                  subtitle: Text("Assigned: ${log.technician}"),
                  trailing: StatusBadge(text: log.status, color: log.status == 'Open' ? AppColors.warning : AppColors.success),
                );
              },
            ),

            const SizedBox(height: 32),
            const Text("Maintenance Fault Log", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Vehicle")),
                  DataColumn(label: Text("Fault")),
                  DataColumn(label: Text("Date")),
                  DataColumn(label: Text("Status")),
                ],
                rows: maintState.logs.map((log) {
                  return DataRow(cells: [
                    DataCell(Text(log.vehicleId)),
                    DataCell(Text(log.fault)),
                    DataCell(Text(log.date)),
                    DataCell(Text(log.status)),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _assignTechnician(BuildContext context, String vehicleId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Assign Technician to $vehicleId"),
        content: const TextField(
          decoration: InputDecoration(labelText: "Technician Name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Confirm")),
        ],
      ),
    );
  }
}
