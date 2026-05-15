/// ================================================
/// File    : dashboard_provider.dart
/// Module  : Providers
/// Desc    : Aggregated dashboard state management
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/utils/shared_prefs_helper.dart';
import 'drone_provider.dart';
import 'vehicle_provider.dart';
import 'maintenance_provider.dart';
import 'alert_provider.dart';
import 'threat_provider.dart';

class DashboardState {
  final bool isSeeding;
  final String? error;

  DashboardState({this.isSeeding = false, this.error});
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DashboardNotifier() : super(DashboardState()) {
    _checkAndSeedData();
  }

  Future<void> _checkAndSeedData() async {
    final seeded = await SharedPrefsHelper.isDataSeeded();
    if (!seeded) {
      state = DashboardState(isSeeding: true);
      try {
        await _seedCollections();
        await SharedPrefsHelper.setDataSeeded(true);
        state = DashboardState(isSeeding: false);
      } catch (e) {
        state = DashboardState(isSeeding: false, error: e.toString());
      }
    }
  }

  Future<void> _seedCollections() async {
    // Seed Drones
    final drones = [
      {'battery': 85, 'altitude': 120, 'signal': 90, 'status': 'Active', 'camera': 'Online'},
      {'battery': 42, 'altitude': 85, 'signal': 75, 'status': 'Active', 'camera': 'Online'},
      {'battery': 18, 'altitude': 0, 'signal': 20, 'status': 'Returning', 'camera': 'Offline'},
      {'battery': 95, 'altitude': 200, 'signal': 95, 'status': 'Active', 'camera': 'Online'},
      {'battery': 8, 'altitude': 0, 'signal': 10, 'status': 'Critical', 'camera': 'Offline'},
    ];
    for (int i = 0; i < drones.length; i++) {
      await _firestore.collection('drones').doc('DRONE-00${i+1}').set(drones[i]);
    }

    // Seed Vehicles
    final vehicles = [
      {'type': 'Tank', 'fuel': 78, 'ammo': 85, 'engine_hours': 320, 'status': 'Operational', 'readiness': 88},
      {'type': 'Tank', 'fuel': 45, 'ammo': 60, 'engine_hours': 510, 'status': 'Maintenance', 'readiness': 42},
      {'type': 'APC', 'fuel': 55, 'ammo': 70, 'engine_hours': 380, 'status': 'Operational', 'readiness': 72},
    ];
    for (int i = 0; i < vehicles.length; i++) {
      await _firestore.collection('vehicles').doc('${vehicles[i]['type']}-00${i+1}').set(vehicles[i]);
    }

    // Seed Threats
    final threats = [
      {'sector': 'Alpha', 'type': 'Infantry', 'risk': 'Medium', 'description': 'Unidentified group moving north', 'timestamp': DateTime.now().toIso8601String()},
      {'sector': 'Bravo', 'type': 'Drone', 'risk': 'Low', 'description': 'Small UAV detected at 2000ft', 'timestamp': DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String()},
    ];
    for (var threat in threats) {
      await _firestore.collection('threats').add(threat);
    }

    // Seed Supply Items
    final supplies = [
      {'name': 'Fuel', 'current': 45, 'threshold': 30, 'unit': 'percent'},
      {'name': 'Ammunition', 'current': 28, 'threshold': 40, 'unit': 'percent'},
    ];
    for (var supply in supplies) {
      await _firestore.collection('supply_items').add(supply);
    }
    
    // Seed Alerts
    await _firestore.collection('alerts').add({
      'title': 'Low Battery Alert',
      'message': 'DRONE-003 is below 20% battery',
      'level': 'Warning',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier();
});
