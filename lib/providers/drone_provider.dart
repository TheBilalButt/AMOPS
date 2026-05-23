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
    
    final mockDrones = [
      DroneModel(id: 'Burraq UCAV', battery: 85, altitude: 12000, signal: 90, status: 'Active', camera: 'Online'),
      DroneModel(id: 'Shahpar-II UCAV', battery: 42, altitude: 15000, signal: 75, status: 'Active', camera: 'Online'),
      DroneModel(id: 'GIDS Uqab', battery: 18, altitude: 0, signal: 20, status: 'Returning', camera: 'Offline'),
      DroneModel(id: 'GIDS Shahpar', battery: 95, altitude: 20000, signal: 95, status: 'Active', camera: 'Online'),
      DroneModel(id: 'SATUMA Jasoos II', battery: 8, altitude: 0, signal: 10, status: 'Critical', camera: 'Offline'),
      DroneModel(id: 'GIDS Ababeel', battery: 100, altitude: 0, signal: 100, status: 'Standby', camera: 'Offline'),
    ];

    _firestore.collection('drones').snapshots().listen((snapshot) {
      final drones = snapshot.docs
          .map((doc) => DroneModel.fromMap(doc.data(), doc.id))
          .toList();
      
      if (drones.isEmpty) {
        state = state.copyWith(drones: mockDrones, isLoading: false, error: null);
      } else {
        DatabaseHelper.instance.cacheData(
          'drones_cache', 
          drones.map((d) => d.toMap()).toList()
        );
        state = state.copyWith(drones: drones, isLoading: false, error: null);
      }
    }, onError: (e) {
      state = state.copyWith(drones: mockDrones, isLoading: false, error: null);
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
