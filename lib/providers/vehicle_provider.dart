/// ================================================
/// File    : vehicle_provider.dart
/// Module  : Providers
/// Desc    : Vehicle fleet state management with Firestore streams
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle_model.dart';
import '../core/database/database_helper.dart';

class VehicleState {
  final List<VehicleModel> vehicles;
  final bool isLoading;
  final String? error;

  VehicleState({
    this.vehicles = const [],
    this.isLoading = false,
    this.error,
  });

  VehicleState copyWith({
    List<VehicleModel>? vehicles,
    bool? isLoading,
    String? error,
  }) {
    return VehicleState(
      vehicles: vehicles ?? this.vehicles,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class VehicleNotifier extends StateNotifier<VehicleState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  VehicleNotifier() : super(VehicleState()) {
    _initVehicles();
  }

  void _initVehicles() {
    state = state.copyWith(isLoading: true);
    _firestore.collection('vehicles').snapshots().listen((snapshot) {
      final vehicles = snapshot.docs
          .map((doc) => VehicleModel.fromMap(doc.data(), doc.id))
          .toList();
      
      DatabaseHelper.instance.cacheData(
        'vehicles_cache', 
        vehicles.map((v) => v.toMap()).toList()
      );
      
      state = state.copyWith(vehicles: vehicles, isLoading: false, error: null);
    }, onError: (e) {
      final mockVehicles = [
        VehicleModel(id: 'Tank-001', type: 'Tank', fuel: 78, ammo: 85, engineHours: 320, status: 'Operational', readiness: 88),
        VehicleModel(id: 'Tank-002', type: 'Tank', fuel: 45, ammo: 60, engineHours: 510, status: 'Maintenance', readiness: 42),
        VehicleModel(id: 'APC-001', type: 'APC', fuel: 55, ammo: 70, engineHours: 380, status: 'Operational', readiness: 72),
      ];
      state = state.copyWith(vehicles: mockVehicles, isLoading: false, error: "Demo Mode");
    });
  }

  Future<void> updateStatus(String id, String status) async {
    final updated = state.vehicles.map((v) {
      if (v.id == id) {
        return VehicleModel(id: v.id, type: v.type, fuel: v.fuel, ammo: v.ammo, engineHours: v.engineHours, status: status, readiness: v.readiness);
      }
      return v;
    }).toList();
    state = state.copyWith(vehicles: updated);

    try {
      await _firestore.collection('vehicles').doc(id).update({'status': status});
    } catch (e) {
      // Ignore in demo mode
    }
  }
}

final vehicleProvider = StateNotifierProvider<VehicleNotifier, VehicleState>((ref) {
  return VehicleNotifier();
});
