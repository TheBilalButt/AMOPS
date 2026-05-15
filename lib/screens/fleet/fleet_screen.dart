/// ================================================
/// File    : fleet_screen.dart
/// Module  : Fleet
/// Desc    : Fleet management with Drones and Vehicles tabs
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/drone_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/drone_card.dart';
import '../../widgets/vehicle_card.dart';
import '../../widgets/loading_widget.dart';
import 'drone_detail_screen.dart';
import 'vehicle_detail_screen.dart';

class FleetScreen extends ConsumerWidget {
  const FleetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Fleet Management"),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(icon: Icon(Icons.airplanemode_active), text: "Drones"),
              Tab(icon: Icon(Icons.security), text: "Vehicles"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _DronesTab(),
            _VehiclesTab(),
          ],
        ),
      ),
    );
  }
}

class _DronesTab extends ConsumerWidget {
  const _DronesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final droneState = ref.watch(droneProvider);

    if (droneState.isLoading) return const LoadingWidget();
    if (droneState.error != null) return Center(child: Text(droneState.error!));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: droneState.drones.length,
      itemBuilder: (context, index) {
        final drone = droneState.drones[index];
        return DroneCard(
          drone: drone,
          onLaunch: () => _showConfirm(context, "Launch", () => ref.read(droneProvider.notifier).launchDrone(drone.id)),
          onReturn: () => _showConfirm(context, "Return", () => ref.read(droneProvider.notifier).returnToBase(drone.id)),
          onAbort: () => _showConfirm(context, "Abort", () => ref.read(droneProvider.notifier).abortMission(drone.id)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DroneDetailScreen(droneId: drone.id)),
            );
          },
        );
      },
    );
  }

  void _showConfirm(BuildContext context, String action, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm $action"),
        content: Text("Are you sure you want to $action this drone?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            child: Text("Confirm"),
          ),
        ],
      ),
    );
  }
}

class _VehiclesTab extends ConsumerWidget {
  const _VehiclesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleState = ref.watch(vehicleProvider);

    if (vehicleState.isLoading) return const LoadingWidget();
    if (vehicleState.error != null) return Center(child: Text(vehicleState.error!));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vehicleState.vehicles.length,
      itemBuilder: (context, index) {
        final vehicle = vehicleState.vehicles[index];
        return VehicleCard(
          vehicle: vehicle,
          onDeploy: () => ref.read(vehicleProvider.notifier).updateStatus(vehicle.id, 'Deployed'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VehicleDetailScreen(vehicleId: vehicle.id)),
            );
          },
        );
      },
    );
  }
}
