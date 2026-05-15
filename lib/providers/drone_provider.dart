/// ================================================
/// File    : drone_provider.dart
/// Module  : Providers
/// Desc    : Drone fleet state management with Firestore streams
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/drone_model.dart';
import '../core/database/database_helper.dart';

class DroneState {
  final List<DroneModel> drones;
  final bool isLoading;
  final String? error;

  DroneState({
    this.drones = const [],
    this.isLoading = false,
    this.error,
  });

  DroneState copyWith({
    List<DroneModel>? drones,
    bool? isLoading,
    String? error,
  }) {
    return DroneState(
      drones: drones ?? this.drones,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DroneNotifier extends StateNotifier<DroneState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DroneNotifier() : super(DroneState()) {
    _initDrones();
  }

  void _initDrones() {
    state = state.copyWith(isLoading: true);
    _firestore.collection('drones').snapshots().listen((snapshot) {
      final drones = snapshot.docs
          .map((doc) => DroneModel.fromMap(doc.data(), doc.id))
          .toList();
      
      DatabaseHelper.instance.cacheData(
        'drones_cache', 
        drones.map((d) => d.toMap()).toList()
      );
      
      state = state.copyWith(drones: drones, isLoading: false, error: null);
    }, onError: (e) {
      final mockDrones = [
        DroneModel(id: 'DRONE-001', battery: 85, altitude: 120, signal: 90, status: 'Active', camera: 'Online'),
        DroneModel(id: 'DRONE-002', battery: 42, altitude: 85, signal: 75, status: 'Active', camera: 'Online'),
        DroneModel(id: 'DRONE-003', battery: 18, altitude: 0, signal: 20, status: 'Returning', camera: 'Offline'),
        DroneModel(id: 'DRONE-004', battery: 95, altitude: 200, signal: 95, status: 'Active', camera: 'Online'),
        DroneModel(id: 'DRONE-005', battery: 8, altitude: 0, signal: 10, status: 'Critical', camera: 'Offline'),
      ];
      state = state.copyWith(drones: mockDrones, isLoading: false, error: "Demo Mode");
    });
  }

  Future<void> updateDroneStatus(String id, String status) async {
    final updated = state.drones.map((d) {
      if (d.id == id) {
        return DroneModel(id: d.id, battery: d.battery, altitude: d.altitude, signal: d.signal, status: status, camera: d.camera);
      }
      return d;
    }).toList();
    state = state.copyWith(drones: updated);

    try {
      await _firestore.collection('drones').doc(id).update({'status': status});
    } catch (e) {
      // Ignore in demo mode
    }
  }

  Future<void> returnToBase(String id) async {
    await updateDroneStatus(id, 'Returning');
  }

  Future<void> launchDrone(String id) async {
    await updateDroneStatus(id, 'Active');
  }

  Future<void> abortMission(String id) async {
    await updateDroneStatus(id, 'Standby');
  }
}

final droneProvider = StateNotifierProvider<DroneNotifier, DroneState>((ref) {
  return DroneNotifier();
});
