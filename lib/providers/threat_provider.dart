/// ================================================
/// File    : threat_provider.dart
/// Module  : Providers
/// Desc    : Threat intelligence state management
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/threat_model.dart';

class ThreatState {
  final List<ThreatModel> threats;
  final bool isLoading;
  final String? error;

  ThreatState({
    this.threats = const [],
    this.isLoading = false,
    this.error,
  });

  ThreatState copyWith({
    List<ThreatModel>? threats,
    bool? isLoading,
    String? error,
  }) {
    return ThreatState(
      threats: threats ?? this.threats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ThreatNotifier extends StateNotifier<ThreatState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ThreatNotifier() : super(ThreatState()) {
    _initThreats();
  }

  void _initThreats() {
    state = state.copyWith(isLoading: true);
    _firestore.collection('threats').orderBy('timestamp', descending: true).snapshots().listen((snapshot) {
      final threats = snapshot.docs
          .map((doc) => ThreatModel.fromMap(doc.data(), doc.id))
          .toList();
      state = state.copyWith(threats: threats, isLoading: false);
    }, onError: (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    });
  }

  Future<void> runAIAnalysis() async {
    state = state.copyWith(isLoading: true);
    try {
      // Logic: If sector detection count above 3 updates that document risk_level to High
      final Map<String, int> sectorCounts = {};
      for (var threat in state.threats) {
        sectorCounts[threat.sector] = (sectorCounts[threat.sector] ?? 0) + 1;
      }

      for (var entry in sectorCounts.entries) {
        if (entry.value >= 3) {
          final query = await _firestore.collection('threats')
              .where('sector', isEqualTo: entry.key)
              .get();
          
          for (var doc in query.docs) {
            await doc.reference.update({'risk': 'High'});
          }
        }
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

final threatProvider = StateNotifierProvider<ThreatNotifier, ThreatState>((ref) {
  return ThreatNotifier();
});
