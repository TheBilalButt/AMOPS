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
      
      // Cache data
      DatabaseHelper.instance.cacheData(
        'vehicles_cache', 
        vehicles.map((v) => v.toMap()).toList()
      );
      
      state = state.copyWith(vehicles: vehicles, isLoading: false);
    }, onError: (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    });
  }

  Future<void> updateStatus(String id, String status) async {
    try {
      await _firestore.collection('vehicles').doc(id).update({'status': status});
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final vehicleProvider = StateNotifierProvider<VehicleNotifier, VehicleState>((ref) {
  return VehicleNotifier();
});
