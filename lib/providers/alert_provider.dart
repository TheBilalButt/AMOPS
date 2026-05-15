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
    _firestore.collection('alerts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      final alerts = snapshot.docs
          .map((doc) => AlertModel.fromMap(doc.data(), doc.id))
          .toList();
      state = state.copyWith(alerts: alerts, isLoading: false);
    }, onError: (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    });
  }
}

final alertProvider = StateNotifierProvider<AlertNotifier, AlertState>((ref) {
  return AlertNotifier();
});
