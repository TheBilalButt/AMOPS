/// ================================================
/// File    : maintenance_provider.dart
/// Module  : Providers
/// Desc    : Maintenance management state
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/maintenance_model.dart';

class MaintenanceState {
  final List<MaintenanceModel> logs;
  final bool isLoading;
  final String? error;

  MaintenanceState({
    this.logs = const [],
    this.isLoading = false,
    this.error,
  });

  MaintenanceState copyWith({
    List<MaintenanceModel>? logs,
    bool? isLoading,
    String? error,
  }) {
    return MaintenanceState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MaintenanceNotifier extends StateNotifier<MaintenanceState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MaintenanceNotifier() : super(MaintenanceState()) {
    _initLogs();
  }

  void _initLogs() {
    state = state.copyWith(isLoading: true);
    _firestore.collection('maintenance_logs').snapshots().listen((snapshot) {
      final logs = snapshot.docs
          .map((doc) => MaintenanceModel.fromMap(doc.data(), doc.id))
          .toList();
      state = state.copyWith(logs: logs, isLoading: false, error: null);
    }, onError: (e) {
      final mockLogs = [
        MaintenanceModel(id: 'LOG-1', vehicleId: 'Tank-002', fault: 'Engine Overheating', technician: 'Tech A', date: '2026-05-14', status: 'Open'),
        MaintenanceModel(id: 'LOG-2', vehicleId: 'APC-001', fault: 'Track Wear', technician: 'Tech B', date: '2026-05-10', status: 'In Progress'),
        MaintenanceModel(id: 'LOG-3', vehicleId: 'DRONE-003', fault: 'Battery Drain', technician: 'Tech C', date: '2026-05-15', status: 'Resolved'),
      ];
      state = state.copyWith(logs: mockLogs, isLoading: false, error: "Demo Mode");
    });
  }

  Future<void> addLog(MaintenanceModel log) async {
    final updated = List<MaintenanceModel>.from(state.logs)..add(log);
    state = state.copyWith(logs: updated);

    try {
      await _firestore.collection('maintenance_logs').add(log.toMap());
    } catch (e) {
      // Ignore in demo mode
    }
  }
}

final maintenanceProvider = StateNotifierProvider<MaintenanceNotifier, MaintenanceState>((ref) {
  return MaintenanceNotifier();
});
