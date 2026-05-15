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
  final bool isAnalyzing;
  final String? error;

  ThreatState({
    this.threats = const [],
    this.isLoading = false,
    this.isAnalyzing = false,
    this.error,
  });

  ThreatState copyWith({
    List<ThreatModel>? threats,
    bool? isLoading,
    bool? isAnalyzing,
    String? error,
  }) {
    return ThreatState(
      threats: threats ?? this.threats,
      isLoading: isLoading ?? this.isLoading,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
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
    
    final mockThreats = [
      ThreatModel(id: 'TH-001', type: 'Intrusion', risk: 'High', sector: 'Alpha', description: 'Unauthorized entry detected', timestamp: DateTime.now()),
      ThreatModel(id: 'TH-002', type: 'UAV Detected', risk: 'Medium', sector: 'Bravo', description: 'Low altitude drone flight', timestamp: DateTime.now().subtract(const Duration(minutes: 15))),
      ThreatModel(id: 'TH-003', type: 'Signal Jamming', risk: 'Critical', sector: 'Charlie', description: 'Electronic warfare activity', timestamp: DateTime.now().subtract(const Duration(minutes: 5))),
    ];

    _firestore.collection('threats').snapshots().listen((snapshot) {
      final threats = snapshot.docs
          .map((doc) => ThreatModel.fromMap(doc.data(), doc.id))
          .toList();
      
      if (threats.isEmpty) {
        state = state.copyWith(threats: mockThreats, isLoading: false, error: "Demo Mode");
      } else {
        state = state.copyWith(threats: threats, isLoading: false, error: null);
      }
    }, onError: (e) {
      state = state.copyWith(threats: mockThreats, isLoading: false, error: "Demo Mode");
    });
  }

  Future<void> runAIAnalysis() async {
    state = state.copyWith(isAnalyzing: true);
    await Future.delayed(const Duration(seconds: 2));
    
    final List<ThreatModel> updated = state.threats.map((t) {
      if (t.risk == 'High') {
        return ThreatModel(id: t.id, type: t.type, risk: 'Critical', sector: t.sector, description: t.description, timestamp: t.timestamp);
      }
      return t;
    }).toList();
    
    state = state.copyWith(isAnalyzing: false, threats: updated);
    
    try {
      final snapshot = await _firestore.collection('threats').where('level', isEqualTo: 'High').get();
      for (var doc in snapshot.docs) {
        await doc.reference.update({'level': 'Critical'});
      }
    } catch (e) {
      // Ignore in demo mode
    }
  }
}

final threatProvider = StateNotifierProvider<ThreatNotifier, ThreatState>((ref) {
  return ThreatNotifier();
});
