/// ================================================
/// File    : alert_provider.dart
/// Module  : Providers
/// Desc    : Alerts state management
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/alert_model.dart';

class AlertState {
  final List<AlertModel> alerts;
  final bool isLoading;
  final String? error;

  AlertState({
    this.alerts = const [],
    this.isLoading = false,
    this.error,
  });

  AlertState copyWith({
    List<AlertModel>? alerts,
    bool? isLoading,
    String? error,
  }) {
    return AlertState(
      alerts: alerts ?? this.alerts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AlertNotifier extends StateNotifier<AlertState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AlertNotifier() : super(AlertState()) {
    _initAlerts();
  }

  void _initAlerts() {
    state = state.copyWith(isLoading: true);
    
    final mockAlerts = [
      AlertModel(id: 'ALT-1', title: 'Drone Battery Critical', message: 'DRONE-005 battery below 10%', level: 'Critical', timestamp: DateTime.now(), isRead: false),
      AlertModel(id: 'ALT-2', title: 'Sector Intrusion', message: 'Unknown activity in Sector Alpha', level: 'High', timestamp: DateTime.now().subtract(const Duration(minutes: 5)), isRead: false),
      AlertModel(id: 'ALT-3', title: 'Maintenance Due', message: 'Tank-002 reached 500 hours', level: 'Medium', timestamp: DateTime.now().subtract(const Duration(hours: 1)), isRead: true),
    ];

    _firestore.collection('alerts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      final alerts = snapshot.docs
          .map((doc) => AlertModel.fromMap(doc.data(), doc.id))
          .toList();
      
      if (alerts.isEmpty) {
        state = state.copyWith(alerts: mockAlerts, isLoading: false, error: "Demo Mode");
      } else {
        state = state.copyWith(alerts: alerts, isLoading: false, error: null);
      }
    }, onError: (e) {
      state = state.copyWith(alerts: mockAlerts, isLoading: false, error: "Demo Mode");
    });
  }
}

final alertProvider = StateNotifierProvider<AlertNotifier, AlertState>((ref) {
  return AlertNotifier();
});
