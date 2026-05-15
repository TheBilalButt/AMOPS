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
      
      // Cache data for offline use
      DatabaseHelper.instance.cacheData(
        'drones_cache', 
        drones.map((d) => d.toMap()).toList()
      );
      
      state = state.copyWith(drones: drones, isLoading: false);
    }, onError: (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    });
  }

  Future<void> updateDroneStatus(String id, String status) async {
    try {
      await _firestore.collection('drones').doc(id).update({'status': status});
    } catch (e) {
      state = state.copyWith(error: e.toString());
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
