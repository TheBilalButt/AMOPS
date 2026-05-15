/// ================================================
/// File    : manufacturing_provider.dart
/// Module  : Providers
/// Desc    : Manufacturing operations state
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/production_model.dart';

class ManufacturingState {
  final List<ProductionModel> orders;
  final bool isLoading;
  final String? error;

  ManufacturingState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  ManufacturingState copyWith({
    List<ProductionModel>? orders,
    bool? isLoading,
    String? error,
  }) {
    return ManufacturingState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ManufacturingNotifier extends StateNotifier<ManufacturingState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ManufacturingNotifier() : super(ManufacturingState()) {
    _initOrders();
  }

  void _initOrders() {
    state = state.copyWith(isLoading: true);
    _firestore.collection('production_orders').snapshots().listen((snapshot) {
      final orders = snapshot.docs
          .map((doc) => ProductionModel.fromMap(doc.data(), doc.id))
          .toList();
      state = state.copyWith(orders: orders, isLoading: false);
    }, onError: (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    });
  }

  Future<void> incrementProgress(String id) async {
    try {
      final doc = await _firestore.collection('production_orders').doc(id).get();
      if (doc.exists) {
        final current = doc.data()?['progress'] ?? 0;
        if (current < 100) {
          await doc.reference.update({
            'progress': current + 10,
            'status': (current + 10 >= 100) ? 'Completed' : 'In Progress'
          });
        }
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final manufacturingProvider = StateNotifierProvider<ManufacturingNotifier, ManufacturingState>((ref) {
  return ManufacturingNotifier();
});
