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
      state = state.copyWith(logs: logs, isLoading: false);
    }, onError: (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    });
  }

  Future<void> addLog(MaintenanceModel log) async {
    try {
      await _firestore.collection('maintenance_logs').add(log.toMap());
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final maintenanceProvider = StateNotifierProvider<MaintenanceNotifier, MaintenanceState>((ref) {
  return MaintenanceNotifier();
});
