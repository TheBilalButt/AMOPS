// =============================================================================
// File: drone_model.dart
// Module: Core / Models
// Description: Data model for drones in the AMOPS fleet management system.
//              Includes all drone properties and AI automation helpers.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

/// Represents a drone in the AMOPS fleet.
/// Contains all operational data including battery, GPS, mission status,
/// camera status, and signal strength.
class DroneModel {
  final String id;
  final String name;
  final double batteryPercentage;
  final double latitude;
  final double longitude;
  final double altitude;
  final String missionStatus; // Active, Returning, Standby, Offline
  final bool cameraOnline;
  final double signalStrength;
  final int suspiciousObjectCount;
  final String assignedSector;
  final List<MissionRecord> missionHistory;
  final DateTime lastUpdated;

  const DroneModel({
    required this.id,
    required this.name,
    required this.batteryPercentage,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.missionStatus,
    required this.cameraOnline,
    required this.signalStrength,
    this.suspiciousObjectCount = 0,
    required this.assignedSector,
    this.missionHistory = const [],
    required this.lastUpdated,
  });

  /// Returns true if battery is critically low (below 20%).
  bool get isBatteryLow => batteryPercentage < 20;

  /// Returns true if signal strength is risky (below 30%).
  bool get isSignalRisky => signalStrength < 30;

  /// Returns true if drone has detected 3+ suspicious objects (HIGH RISK).
  bool get isHighRisk => suspiciousObjectCount >= 3;

  /// Estimated flight time remaining in minutes based on battery level.
  int get estimatedFlightMinutes => (batteryPercentage * 1.8).round();

  /// Creates a copy of this drone with updated fields.
  DroneModel copyWith({
    String? id,
    String? name,
    double? batteryPercentage,
    double? latitude,
    double? longitude,
    double? altitude,
    String? missionStatus,
    bool? cameraOnline,
    double? signalStrength,
    int? suspiciousObjectCount,
    String? assignedSector,
    List<MissionRecord>? missionHistory,
    DateTime? lastUpdated,
  }) {
    return DroneModel(
      id: id ?? this.id,
      name: name ?? this.name,
      batteryPercentage: batteryPercentage ?? this.batteryPercentage,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      missionStatus: missionStatus ?? this.missionStatus,
      cameraOnline: cameraOnline ?? this.cameraOnline,
      signalStrength: signalStrength ?? this.signalStrength,
      suspiciousObjectCount: suspiciousObjectCount ?? this.suspiciousObjectCount,
      assignedSector: assignedSector ?? this.assignedSector,
      missionHistory: missionHistory ?? this.missionHistory,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Represents a single mission record for a drone.
class MissionRecord {
  final String missionId;
  final String description;
  final DateTime startTime;
  final DateTime? endTime;
  final String status; // Completed, Aborted, In Progress
  final String sector;

  const MissionRecord({
    required this.missionId,
    required this.description,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.sector,
  });
}
