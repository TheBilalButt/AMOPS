// =============================================================================
// File: maintenance_model.dart
// Module: Core / Models
// Description: Models for predictive maintenance, work orders, and fault logs.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

/// Health assessment for a specific vehicle, used in predictive maintenance.
class VehicleHealth {
  final String vehicleId;
  final String vehicleName;
  final String vehicleType;
  final double healthScore; // 0-100
  final DateTime predictedFailureDate;
  final String predictedFailureType;
  final double maintenanceCostEstimate;
  final List<FaultRecord> faultHistory;

  const VehicleHealth({
    required this.vehicleId,
    required this.vehicleName,
    required this.vehicleType,
    required this.healthScore,
    required this.predictedFailureDate,
    required this.predictedFailureType,
    required this.maintenanceCostEstimate,
    this.faultHistory = const [],
  });
}

/// Individual fault record for a vehicle.
class FaultRecord {
  final String id;
  final String vehicleId;
  final String faultType;
  final String description;
  final String severity; // Minor, Moderate, Severe
  final DateTime detectedDate;
  final DateTime? resolvedDate;
  final String? technicianAssigned;

  const FaultRecord({
    required this.id,
    required this.vehicleId,
    required this.faultType,
    required this.description,
    required this.severity,
    required this.detectedDate,
    this.resolvedDate,
    this.technicianAssigned,
  });

  /// Whether this fault has been resolved.
  bool get isResolved => resolvedDate != null;
}

/// Work order for maintenance tasks.
class WorkOrder {
  final String id;
  final String vehicleId;
  final String vehicleName;
  final String description;
  final String priority; // Low, Medium, High, Critical
  final String status; // Open, In Progress, Completed
  final DateTime createdDate;
  final DateTime? completedDate;
  final String assignedTechnician;
  final double estimatedCost;
  final List<String> requiredParts;

  const WorkOrder({
    required this.id,
    required this.vehicleId,
    required this.vehicleName,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdDate,
    this.completedDate,
    required this.assignedTechnician,
    required this.estimatedCost,
    this.requiredParts = const [],
  });
}
