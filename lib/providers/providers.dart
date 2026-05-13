// =============================================================================
// File: providers.dart
// Module: Providers
// Description: All Riverpod providers for AMOPS state management.
//              Centralizes drone, vehicle, threat, maintenance, logistics,
//              production, sales, dashboard, and settings providers.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/drone_model.dart';
import '../core/models/vehicle_model.dart';
import '../core/models/threat_model.dart';
import '../core/models/maintenance_model.dart';
import '../core/models/logistics_model.dart';
import '../core/models/production_model.dart';
import '../core/models/deal_model.dart';
import '../core/models/alert_model.dart';
import '../data/mock_data/mock_drones.dart';
import '../data/mock_data/mock_vehicles.dart';
import '../data/mock_data/mock_threats.dart';
import '../data/mock_data/mock_maintenance.dart';
import '../data/mock_data/mock_logistics.dart';
import '../data/mock_data/mock_production.dart';
import '../data/mock_data/mock_deals.dart';
import '../data/mock_data/mock_alerts.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// DRONE PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════════

/// Provides the list of all drones with AI automation rules applied.
final droneListProvider = StateNotifierProvider<DroneListNotifier, List<DroneModel>>((ref) {
  return DroneListNotifier();
});

/// Manages the list of drones and applies AI automation rules.
class DroneListNotifier extends StateNotifier<List<DroneModel>> {
  DroneListNotifier() : super(_applyAIRules(MockDrones.drones));

  /// Applies AI automation rules to all drones.
  static List<DroneModel> _applyAIRules(List<DroneModel> drones) {
    return drones.map((drone) {
      // Rule: If battery below 20%, auto-change status to Returning
      if (drone.batteryPercentage < 20 && drone.missionStatus == 'Active') {
        return drone.copyWith(missionStatus: 'Returning');
      }
      return drone;
    }).toList();
  }

  /// Updates a specific drone's mission status (Launch, Return, Abort).
  void updateDroneStatus(String droneId, String newStatus) {
    state = state.map((drone) {
      if (drone.id == droneId) {
        return drone.copyWith(missionStatus: newStatus);
      }
      return drone;
    }).toList();
  }
}

/// Provides a single drone by ID.
final droneDetailProvider = Provider.family<DroneModel?, String>((ref, id) {
  final drones = ref.watch(droneListProvider);
  try {
    return drones.firstWhere((d) => d.id == id);
  } catch (_) {
    return null;
  }
});

// ═══════════════════════════════════════════════════════════════════════════════
// VEHICLE PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════════

/// Provides the list of all vehicles.
final vehicleListProvider = Provider<List<VehicleModel>>((ref) {
  return MockVehicles.vehicles;
});

/// Provides a single vehicle by ID.
final vehicleDetailProvider = Provider.family<VehicleModel?, String>((ref, id) {
  final vehicles = ref.watch(vehicleListProvider);
  try {
    return vehicles.firstWhere((v) => v.id == id);
  } catch (_) {
    return null;
  }
});

/// AI Deployment Optimizer - returns the most-ready vehicle.
final deploymentOptimizerProvider = Provider<VehicleModel?>((ref) {
  final vehicles = ref.watch(vehicleListProvider);
  if (vehicles.isEmpty) return null;
  final operational = vehicles.where((v) => v.status != 'Maintenance').toList();
  if (operational.isEmpty) return null;
  operational.sort((a, b) => b.aiReadinessScore.compareTo(a.aiReadinessScore));
  return operational.first;
});

// ═══════════════════════════════════════════════════════════════════════════════
// THREAT PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════════

/// Provides the list of all threat events.
final threatListProvider = Provider<List<ThreatModel>>((ref) {
  return MockThreats.threats;
});

/// Provides radar alerts.
final radarAlertProvider = Provider<List<RadarAlert>>((ref) {
  return MockThreats.radarAlerts;
});

/// Provides threat count per sector for escalation logic.
final sectorThreatCountProvider = Provider<Map<String, int>>((ref) {
  final threats = ref.watch(threatListProvider);
  final Map<String, int> counts = {};
  for (final threat in threats) {
    counts[threat.sector] = (counts[threat.sector] ?? 0) + 1;
  }
  return counts;
});

/// Current overall threat level based on active threats.
final overallThreatLevelProvider = Provider<String>((ref) {
  final threats = ref.watch(threatListProvider);
  final recentThreats = threats.where(
    (t) => t.timestamp.isAfter(DateTime.now().subtract(const Duration(hours: 24)))
  ).toList();
  final criticalCount = recentThreats.where((t) => t.riskLevel == 'Critical').length;
  final highCount = recentThreats.where((t) => t.riskLevel == 'High').length;
  if (criticalCount >= 2) return 'Critical';
  if (criticalCount >= 1 || highCount >= 3) return 'High';
  if (highCount >= 1) return 'Medium';
  return 'Low';
});

// ═══════════════════════════════════════════════════════════════════════════════
// MAINTENANCE PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════════

/// Provides vehicle health scores for all assets.
final vehicleHealthProvider = Provider<List<VehicleHealth>>((ref) {
  return MockMaintenance.vehicleHealthList;
});

/// Provides work orders.
final workOrderProvider = Provider<List<WorkOrder>>((ref) {
  return MockMaintenance.workOrders;
});

/// Fleet health score (average of all vehicle health scores).
final fleetHealthScoreProvider = Provider<double>((ref) {
  final healthList = ref.watch(vehicleHealthProvider);
  if (healthList.isEmpty) return 0;
  final total = healthList.fold(0.0, (sum, h) => sum + h.healthScore);
  return total / healthList.length;
});

// ═══════════════════════════════════════════════════════════════════════════════
// LOGISTICS PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════════

/// Provides inventory items.
final inventoryProvider = Provider<List<InventoryItem>>((ref) {
  return MockLogistics.inventory;
});

/// Provides delivery tracking data.
final deliveryProvider = Provider<List<DeliveryTracking>>((ref) {
  return MockLogistics.deliveries;
});

/// Provides supplier scores.
final supplierScoreProvider = Provider<List<SupplierScore>>((ref) {
  return MockLogistics.suppliers;
});

/// Low stock alert items.
final lowStockAlertProvider = Provider<List<InventoryItem>>((ref) {
  final inventory = ref.watch(inventoryProvider);
  return inventory.where((item) => item.isLowStock).toList();
});

// ═══════════════════════════════════════════════════════════════════════════════
// PRODUCTION PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════════

/// Provides production orders.
final productionOrderProvider = Provider<List<ProductionOrder>>((ref) {
  return MockProduction.orders;
});

/// Provides R&D projects.
final rdProjectProvider = Provider<List<RDProject>>((ref) {
  return MockProduction.rdProjects;
});

// ═══════════════════════════════════════════════════════════════════════════════
// SALES PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════════

/// Provides export deals.
final dealListProvider = Provider<List<DealModel>>((ref) {
  return MockDeals.deals;
});

/// Provides tender opportunities.
final tenderProvider = Provider<List<TenderOpportunity>>((ref) {
  return MockDeals.tenders;
});

/// Provides defense events.
final defenseEventProvider = Provider<List<DefenseEvent>>((ref) {
  return MockDeals.events;
});

// ═══════════════════════════════════════════════════════════════════════════════
// ALERT PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════════

/// Provides all alerts.
final alertListProvider = Provider<List<AlertModel>>((ref) {
  return MockAlerts.alerts;
});

/// Provides critical alert count.
final criticalAlertCountProvider = Provider<int>((ref) {
  final alerts = ref.watch(alertListProvider);
  return alerts.where((a) => a.severity == 'Critical').length;
});

// ═══════════════════════════════════════════════════════════════════════════════
// DASHBOARD AGGREGATE PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════════

/// Count of active drones.
final activeDroneCountProvider = Provider<int>((ref) {
  final drones = ref.watch(droneListProvider);
  return drones.where((d) => d.missionStatus == 'Active').length;
});

/// Count of active tanks/vehicles (Operational + Standby).
final activeVehicleCountProvider = Provider<int>((ref) {
  final vehicles = ref.watch(vehicleListProvider);
  return vehicles.where((v) => v.status == 'Operational' || v.status == 'Standby').length;
});

/// Count of assets under maintenance.
final maintenanceCountProvider = Provider<int>((ref) {
  final vehicles = ref.watch(vehicleListProvider);
  final drones = ref.watch(droneListProvider);
  final vMaint = vehicles.where((v) => v.status == 'Maintenance').length;
  final dOffline = drones.where((d) => d.missionStatus == 'Offline').length;
  return vMaint + dOffline;
});

/// Average battery of all drones.
final avgBatteryProvider = Provider<double>((ref) {
  final drones = ref.watch(droneListProvider);
  if (drones.isEmpty) return 0;
  return drones.fold(0.0, (sum, d) => sum + d.batteryPercentage) / drones.length;
});

/// Average fuel of all vehicles.
final avgFuelProvider = Provider<double>((ref) {
  final vehicles = ref.watch(vehicleListProvider);
  if (vehicles.isEmpty) return 0;
  return vehicles.fold(0.0, (sum, v) => sum + v.fuelLevel) / vehicles.length;
});

/// Average ammo percentage of all vehicles.
final avgAmmoProvider = Provider<double>((ref) {
  final vehicles = ref.watch(vehicleListProvider);
  if (vehicles.isEmpty) return 0;
  return vehicles.fold(0.0, (sum, v) => sum + v.ammoPercentage) / vehicles.length;
});

// ═══════════════════════════════════════════════════════════════════════════════
// AI ASSISTANT PROVIDER
// ═══════════════════════════════════════════════════════════════════════════════

/// Chat message model for AI assistant.
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

/// Manages chat messages for the AI assistant.
final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier(ref);
});

/// Notifier for AI assistant chat messages.
class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final Ref _ref;

  ChatNotifier(this._ref) : super([
    ChatMessage(
      text: 'AMOPS AI Assistant online. I have access to all fleet, threat, logistics, and operations data. How can I assist you, Commander?',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ]);

  /// Sends a user message and generates an AI response.
  void sendMessage(String text) {
    // Add user message
    state = [...state, ChatMessage(text: text, isUser: true, timestamp: DateTime.now())];

    // Generate AI response based on mock data
    final response = _generateResponse(text.toLowerCase());
    state = [...state, ChatMessage(text: response, isUser: false, timestamp: DateTime.now())];
  }

  /// Generates a context-aware AI response using mock data.
  String _generateResponse(String query) {
    final drones = _ref.read(droneListProvider);
    final vehicles = _ref.read(vehicleListProvider);
    final threats = _ref.read(threatListProvider);
    final healthList = _ref.read(vehicleHealthProvider);
    final deals = _ref.read(dealListProvider);
    final fleetHealth = _ref.read(fleetHealthScoreProvider);

    if (query.contains('maintenance') || query.contains('tank needs')) {
      final needsMaint = vehicles.where((v) => v.needsMaintenance).toList();
      if (needsMaint.isEmpty) return 'All vehicles are within their maintenance schedule. No immediate action required.';
      final names = needsMaint.map((v) => '${v.name} (${v.engineHours}hrs, last service ${DateTime.now().difference(v.lastServiceDate).inDays} days ago)').join('\n• ');
      return 'The following vehicles require maintenance:\n• $names\n\nRecommendation: Prioritize ${needsMaint.first.name} for immediate service.';
    }

    if (query.contains('threat') || query.contains('risk')) {
      final level = _ref.read(overallThreatLevelProvider);
      final criticals = threats.where((t) => t.riskLevel == 'Critical').length;
      return 'Current threat assessment: $level\n\nActive threats: ${threats.length}\nCritical: $criticals\nMost recent: ${threats.first.type} at ${threats.first.location}\n\nRecommendation: ${level == 'Critical' ? 'Elevate all sectors to DEFCON-2. Deploy additional surveillance assets.' : 'Maintain current posture. Continue monitoring.'}';
    }

    if (query.contains('battery') || query.contains('drone')) {
      final sorted = List<DroneModel>.from(drones)..sort((a, b) => a.batteryPercentage.compareTo(b.batteryPercentage));
      final lowest = sorted.first;
      return 'Lowest battery drone: ${lowest.name} (${lowest.id})\nBattery: ${lowest.batteryPercentage.toStringAsFixed(0)}%\nStatus: ${lowest.missionStatus}\nEstimated flight time: ${lowest.estimatedFlightMinutes} minutes\n\n${lowest.isBatteryLow ? '⚠️ CRITICAL: Auto-return protocol activated.' : 'Battery within acceptable range.'}';
    }

    if (query.contains('report') || query.contains('mission')) {
      return '═══ DAILY MISSION REPORT ═══\n\nFleet Health: ${fleetHealth.toStringAsFixed(1)}%\nActive Drones: ${drones.where((d) => d.missionStatus == 'Active').length}/${drones.length}\nOperational Vehicles: ${vehicles.where((v) => v.status == 'Operational').length}/${vehicles.length}\nActive Threats: ${threats.where((t) => t.timestamp.isAfter(DateTime.now().subtract(const Duration(hours: 24)))).length}\nPending Work Orders: ${_ref.read(workOrderProvider).where((w) => w.status != 'Completed').length}\n\nOverall Status: ${fleetHealth > 70 ? 'GREEN - Normal Operations' : 'AMBER - Attention Required'}';
    }

    if (query.contains('deal') || query.contains('win') || query.contains('probability') || query.contains('sales')) {
      final sorted = List<DealModel>.from(deals)..sort((a, b) => b.winProbability.compareTo(a.winProbability));
      final top = sorted.first;
      return 'Highest win probability deal:\n\nDeal: ${top.product} → ${top.country}\nValue: \$${(top.dealValue / 1000000).toStringAsFixed(0)}M\nStage: ${top.stage}\nWin Probability: ${top.winProbability.toStringAsFixed(0)}%\n\nRecommendation: ${top.winProbability > 80 ? 'Fast-track contract finalization.' : 'Schedule follow-up meeting within 72 hours.'}';
    }

    if (query.contains('health') || query.contains('score')) {
      final critical = healthList.where((h) => h.healthScore < 40).toList();
      return 'Fleet Health Score: ${fleetHealth.toStringAsFixed(1)}%\n\nCritical vehicles (health < 40%):\n${critical.map((h) => '• ${h.vehicleName}: ${h.healthScore.toStringAsFixed(0)}% - Predicted: ${h.predictedFailureType}').join('\n')}\n\nAction Required: Schedule maintenance for ${critical.length} vehicles.';
    }

    return 'I\'ve analyzed the current operational data. Fleet health is at ${fleetHealth.toStringAsFixed(1)}%, with ${drones.where((d) => d.missionStatus == 'Active').length} active drones and ${vehicles.where((v) => v.status == 'Operational').length} operational vehicles.\n\nYou can ask me about:\n• Drone battery status\n• Tank maintenance needs\n• Current threat level\n• Mission reports\n• Export deal probabilities\n• Fleet health scores';
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SETTINGS PROVIDER
// ═══════════════════════════════════════════════════════════════════════════════

/// App settings state.
class AppSettings {
  final double batteryThreshold;
  final double fuelThreshold;
  final double ammoThreshold;
  final bool notificationsEnabled;
  final bool criticalAlertsEnabled;
  final bool maintenanceAlertsEnabled;

  const AppSettings({
    this.batteryThreshold = 20,
    this.fuelThreshold = 25,
    this.ammoThreshold = 20,
    this.notificationsEnabled = true,
    this.criticalAlertsEnabled = true,
    this.maintenanceAlertsEnabled = true,
  });

  AppSettings copyWith({
    double? batteryThreshold,
    double? fuelThreshold,
    double? ammoThreshold,
    bool? notificationsEnabled,
    bool? criticalAlertsEnabled,
    bool? maintenanceAlertsEnabled,
  }) {
    return AppSettings(
      batteryThreshold: batteryThreshold ?? this.batteryThreshold,
      fuelThreshold: fuelThreshold ?? this.fuelThreshold,
      ammoThreshold: ammoThreshold ?? this.ammoThreshold,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      criticalAlertsEnabled: criticalAlertsEnabled ?? this.criticalAlertsEnabled,
      maintenanceAlertsEnabled: maintenanceAlertsEnabled ?? this.maintenanceAlertsEnabled,
    );
  }
}

/// Manages app settings.
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings());

  void updateBatteryThreshold(double value) => state = state.copyWith(batteryThreshold: value);
  void updateFuelThreshold(double value) => state = state.copyWith(fuelThreshold: value);
  void updateAmmoThreshold(double value) => state = state.copyWith(ammoThreshold: value);
  void toggleNotifications(bool value) => state = state.copyWith(notificationsEnabled: value);
  void toggleCriticalAlerts(bool value) => state = state.copyWith(criticalAlertsEnabled: value);
  void toggleMaintenanceAlerts(bool value) => state = state.copyWith(maintenanceAlertsEnabled: value);
}
