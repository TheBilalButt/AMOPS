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
    _firestore.collection('manufacturing_orders').snapshots().listen((snapshot) {
      final orders = snapshot.docs
          .map((doc) => ProductionModel.fromMap(doc.data(), doc.id))
          .toList();
      state = state.copyWith(orders: orders, isLoading: false, error: null);
    }, onError: (e) {
      final mockOrders = [
        ProductionModel(id: 'MFG-001', vehicleType: 'Al-Khalid Tank', quantity: 50, expectedDate: '2026-12-01', progress: 45, status: 'In Production'),
        ProductionModel(id: 'MFG-002', vehicleType: 'Burraq UCAV', quantity: 120, expectedDate: '2026-08-15', progress: 85, status: 'Testing'),
        ProductionModel(id: 'MFG-003', vehicleType: 'Maaz APC', quantity: 200, expectedDate: '2027-01-10', progress: 10, status: 'Planning'),
      ];
      state = state.copyWith(orders: mockOrders, isLoading: false, error: "Demo Mode");
    });
  }

  Future<void> incrementProgress(String id) async {
    final updated = state.orders.map((o) {
      if (o.id == id) {
        final newProgress = (o.progress + 10).clamp(0, 100);
        final newStatus = newProgress == 100 ? 'Completed' : o.status;
        return ProductionModel(id: o.id, vehicleType: o.vehicleType, quantity: o.quantity, expectedDate: o.expectedDate, progress: newProgress, status: newStatus);
      }
      return o;
    }).toList();
    state = state.copyWith(orders: updated);

    try {
      final doc = await _firestore.collection('manufacturing_orders').doc(id).get();
      if (doc.exists) {
        int current = doc.data()?['progress'] ?? 0;
        current += 10;
        if (current > 100) current = 100;
        String status = current == 100 ? 'Completed' : 'In Production';
        await doc.reference.update({'progress': current, 'status': status});
      }
    } catch (e) {
      // Ignore in demo mode
    }
  }
}

final manufacturingProvider = StateNotifierProvider<ManufacturingNotifier, ManufacturingState>((ref) {
  return ManufacturingNotifier();
});
