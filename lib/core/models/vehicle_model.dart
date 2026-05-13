// =============================================================================
// File: vehicle_model.dart
// Module: Core / Models
// Description: Data model for tanks, APCs, and ASVs in the AMOPS fleet.
//              Includes readiness scoring and maintenance automation helpers.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

/// Represents a military vehicle (Tank, APC, or ASV) in the AMOPS fleet.
class VehicleModel {
  final String id;
  final String name;
  final String type; // Tank, APC, ASV
  final double fuelLevel; // percentage 0-100
  final int ammoCount;
  final int ammoCapacity;
  final double engineHours;
  final String deploymentLocation;
  final double latitude;
  final double longitude;
  final String status; // Operational, Standby, Critical, Maintenance
  final DateTime lastServiceDate;
  final double aiReadinessScore; // 0-100
  final String deploymentRecommendation;
  final List<MaintenanceRecord> maintenanceHistory;
  final DateTime lastUpdated;

  const VehicleModel({
    required this.id,
    required this.name,
    required this.type,
    required this.fuelLevel,
    required this.ammoCount,
    required this.ammoCapacity,
    required this.engineHours,
    required this.deploymentLocation,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.lastServiceDate,
    required this.aiReadinessScore,
    this.deploymentRecommendation = '',
    this.maintenanceHistory = const [],
    required this.lastUpdated,
  });

  /// Returns ammo percentage (ammoCount / ammoCapacity * 100).
  double get ammoPercentage =>
      ammoCapacity > 0 ? (ammoCount / ammoCapacity) * 100 : 0;

  /// Returns true if engine hours exceed limit and service is overdue.
  bool get needsMaintenance {
    final daysSinceService =
        DateTime.now().difference(lastServiceDate).inDays;
    return engineHours > 500 && daysSinceService > 90;
  }

  /// Returns true if ammo is below 25% capacity.
  bool get needsResupply => ammoPercentage < 25;

  /// Creates a copy with updated fields.
  VehicleModel copyWith({
    String? id,
    String? name,
    String? type,
    double? fuelLevel,
    int? ammoCount,
    int? ammoCapacity,
    double? engineHours,
    String? deploymentLocation,
    double? latitude,
    double? longitude,
    String? status,
    DateTime? lastServiceDate,
    double? aiReadinessScore,
    String? deploymentRecommendation,
    List<MaintenanceRecord>? maintenanceHistory,
    DateTime? lastUpdated,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      fuelLevel: fuelLevel ?? this.fuelLevel,
      ammoCount: ammoCount ?? this.ammoCount,
      ammoCapacity: ammoCapacity ?? this.ammoCapacity,
      engineHours: engineHours ?? this.engineHours,
      deploymentLocation: deploymentLocation ?? this.deploymentLocation,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
      aiReadinessScore: aiReadinessScore ?? this.aiReadinessScore,
      deploymentRecommendation:
          deploymentRecommendation ?? this.deploymentRecommendation,
      maintenanceHistory: maintenanceHistory ?? this.maintenanceHistory,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Represents a single maintenance record for a vehicle.
class MaintenanceRecord {
  final String id;
  final String vehicleId;
  final String description;
  final DateTime date;
  final String type; // Scheduled, Emergency, Preventive
  final double cost;
  final String technician;
  final List<String> partsReplaced;

  const MaintenanceRecord({
    required this.id,
    required this.vehicleId,
    required this.description,
    required this.date,
    required this.type,
    required this.cost,
    required this.technician,
    this.partsReplaced = const [],
  });
}
