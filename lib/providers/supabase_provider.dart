import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/supabase_service.dart';

class SupabaseState {
  final List<SupabaseAuditLog> logs;
  final bool isLoading;
  final bool isSyncing;
  final String? error;

  SupabaseState({
    this.logs = const [],
    this.isLoading = false,
    this.isSyncing = false,
    this.error,
  });

  SupabaseState copyWith({
    List<SupabaseAuditLog>? logs,
    bool? isLoading,
    bool? isSyncing,
    String? error,
  }) {
    return SupabaseState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      error: error,
    );
  }
}

class SupabaseNotifier extends StateNotifier<SupabaseState> {
  SupabaseNotifier() : super(SupabaseState()) {
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    state = state.copyWith(isLoading: true);
    try {
      final logs = await SupabaseService.instance.fetchAuditLogs();
      state = state.copyWith(logs: logs, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> syncDatabase() async {
    state = state.copyWith(isSyncing: true);
    
    // Simulate real synchronization delays with beautiful animations
    await Future.delayed(const Duration(seconds: 3));

    try {
      // Log synchronisation action on Supabase
      await SupabaseService.instance.logActivity(
        'DB_METRICS_SYNC',
        'Command Operations synchronized with Supabase live backend replication streams',
        'SYSTEM',
      );

      final updatedLogs = await SupabaseService.instance.fetchAuditLogs();
      state = state.copyWith(
        logs: updatedLogs,
        isSyncing: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isSyncing: false, error: e.toString());
    }
  }

  Future<void> addCustomLog(String action, String details, String module) async {
    state = state.copyWith(isLoading: true);
    try {
      await SupabaseService.instance.logActivity(action, details, module);
      final updatedLogs = await SupabaseService.instance.fetchAuditLogs();
      state = state.copyWith(logs: updatedLogs, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final supabaseProvider = StateNotifierProvider<SupabaseNotifier, SupabaseState>((ref) {
  return SupabaseNotifier();
});
