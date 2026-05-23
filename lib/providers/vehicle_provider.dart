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
    
    final mockVehicles = [
      VehicleModel(id: 'Al-Khalid MBT', type: 'Tank', fuel: 82, ammo: 95, engineHours: 120, status: 'Operational', readiness: 95),
      VehicleModel(id: 'Haider MBT', type: 'Tank', fuel: 90, ammo: 100, engineHours: 45, status: 'Operational', readiness: 98),
      VehicleModel(id: 'Al-Zarrar', type: 'Tank', fuel: 45, ammo: 60, engineHours: 850, status: 'Maintenance', readiness: 42),
      VehicleModel(id: 'Talha APC', type: 'APC', fuel: 65, ammo: 80, engineHours: 340, status: 'Operational', readiness: 85),
      VehicleModel(id: 'Saad APC', type: 'APC', fuel: 75, ammo: 90, engineHours: 210, status: 'Operational', readiness: 92),
      VehicleModel(id: 'Viper IFV', type: 'IFV', fuel: 88, ammo: 100, engineHours: 110, status: 'Operational', readiness: 96),
      VehicleModel(id: 'Maaz ATGM', type: 'APC', fuel: 30, ammo: 40, engineHours: 670, status: 'Maintenance', readiness: 35),
      VehicleModel(id: 'Dragoon AFV', type: 'AFV', fuel: 70, ammo: 85, engineHours: 410, status: 'Operational', readiness: 88),
    ];

    _firestore.collection('vehicles').snapshots().listen((snapshot) {
      final vehicles = snapshot.docs
          .map((doc) => VehicleModel.fromMap(doc.data(), doc.id))
          .toList();
      
      if (vehicles.isEmpty) {
        state = state.copyWith(vehicles: mockVehicles, isLoading: false, error: null);
      } else {
        DatabaseHelper.instance.cacheData(
          'vehicles_cache', 
          vehicles.map((v) => v.toMap()).toList()
        );
        state = state.copyWith(vehicles: vehicles, isLoading: false, error: null);
      }
    }, onError: (e) {
      state = state.copyWith(vehicles: mockVehicles, isLoading: false, error: null);
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
