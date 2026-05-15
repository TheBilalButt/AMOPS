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
      state = state.copyWith(supplies: supplies, isLoading: false, error: null);
    }, onError: (e) {
      final mockSupplies = [
        SupplyModel(id: 'SUP-001', name: '120mm Tank Rounds', category: 'Ammunition', current: 200, required: 500),
        SupplyModel(id: 'SUP-002', name: 'Drone Batteries', category: 'Electronics', current: 45, required: 50),
        SupplyModel(id: 'SUP-003', name: 'Aviation Fuel', category: 'Fuel', current: 12000, required: 50000),
      ];
      state = state.copyWith(supplies: mockSupplies, isLoading: false, error: "Demo Mode");
    });
  }

  Future<void> triggerResupply(String id, int amount) async {
    final updated = state.supplies.map((s) {
      if (s.id == id) {
        return SupplyModel(id: s.id, name: s.name, category: s.category, current: s.current + amount, required: s.required);
      }
      return s;
    }).toList();
    state = state.copyWith(supplies: updated);

    try {
      final doc = await _firestore.collection('supply_items').doc(id).get();
      if (doc.exists) {
        final current = doc.data()?['current'] ?? 0;
        await doc.reference.update({'current': current + amount});
      }
    } catch (e) {
      // Ignore in demo mode
    }
  }
}

final logisticsProvider = StateNotifierProvider<LogisticsNotifier, LogisticsState>((ref) {
  return LogisticsNotifier();
});
