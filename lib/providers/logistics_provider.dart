/// ================================================
/// File    : logistics_provider.dart
/// Module  : Providers
/// Desc    : Logistics and supply chain state
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/supply_model.dart';

class LogisticsState {
  final List<SupplyModel> supplies;
  final bool isLoading;
  final String? error;

  LogisticsState({
    this.supplies = const [],
    this.isLoading = false,
    this.error,
  });

  LogisticsState copyWith({
    List<SupplyModel>? supplies,
    bool? isLoading,
    String? error,
  }) {
    return LogisticsState(
      supplies: supplies ?? this.supplies,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class LogisticsNotifier extends StateNotifier<LogisticsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LogisticsNotifier() : super(LogisticsState()) {
    _initSupplies();
  }

  void _initSupplies() {
    state = state.copyWith(isLoading: true);
    _firestore.collection('supply_items').snapshots().listen((snapshot) {
      final supplies = snapshot.docs
          .map((doc) => SupplyModel.fromMap(doc.data(), doc.id))
          .toList();
      state = state.copyWith(supplies: supplies, isLoading: false);
    }, onError: (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    });
  }

  Future<void> triggerResupply(String id, int amount) async {
    try {
      final doc = await _firestore.collection('supply_items').doc(id).get();
      if (doc.exists) {
        final current = doc.data()?['current'] ?? 0;
        await doc.reference.update({'current': current + amount});
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final logisticsProvider = StateNotifierProvider<LogisticsNotifier, LogisticsState>((ref) {
  return LogisticsNotifier();
});
