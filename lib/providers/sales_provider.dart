/// ================================================
/// File    : sales_provider.dart
/// Module  : Providers
/// Desc    : Sales intelligence state
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sales_model.dart';

class SalesState {
  final List<SalesModel> deals;
  final bool isLoading;
  final String? error;

  SalesState({
    this.deals = const [],
    this.isLoading = false,
    this.error,
  });

  SalesState copyWith({
    List<SalesModel>? deals,
    bool? isLoading,
    String? error,
  }) {
    return SalesState(
      deals: deals ?? this.deals,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SalesNotifier extends StateNotifier<SalesState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SalesNotifier() : super(SalesState()) {
    _initDeals();
  }

  void _initDeals() {
    state = state.copyWith(isLoading: true);
    _firestore.collection('sales_deals').snapshots().listen((snapshot) {
      final deals = snapshot.docs
          .map((doc) => SalesModel.fromMap(doc.data(), doc.id))
          .toList();
      state = state.copyWith(deals: deals, isLoading: false, error: null);
    }, onError: (e) {
      final mockDeals = [
        SalesModel(id: 'DEAL-001', country: 'Saudi Arabia', product: 'Al-Khalid MBT x40', value: '120M', stage: 'Negotiation', winProbability: 75),
        SalesModel(id: 'DEAL-002', country: 'Qatar', product: 'Burraq UCAV System', value: '85M', stage: 'Quote', winProbability: 60),
        SalesModel(id: 'DEAL-003', country: 'Malaysia', product: 'Small Arms Package', value: '15M', stage: 'Lead', winProbability: 30),
      ];
      state = state.copyWith(deals: mockDeals, isLoading: false, error: "Demo Mode");
    });
  }

  Future<void> advanceDealStage(String id, String nextStage) async {
    final updated = state.deals.map((d) {
      if (d.id == id) {
        return SalesModel(id: d.id, country: d.country, product: d.product, value: d.value, stage: nextStage, winProbability: d.winProbability);
      }
      return d;
    }).toList();
    state = state.copyWith(deals: updated);

    try {
      await _firestore.collection('sales_deals').doc(id).update({'stage': nextStage});
    } catch (e) {
      // Ignore in demo mode
    }
  }
}

final salesProvider = StateNotifierProvider<SalesNotifier, SalesState>((ref) {
  return SalesNotifier();
});
