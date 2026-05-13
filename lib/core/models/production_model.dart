// =============================================================================
// File: production_model.dart
// Module: Core / Models
// Description: Models for manufacturing production orders and quality control.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

/// Represents an active production order in the manufacturing module.
class ProductionOrder {
  final String id;
  final String vehicleType;
  final String orderName;
  final int quantity;
  final double progressPercentage;
  final String status; // In Progress, Completed, Delayed, On Hold
  final DateTime startDate;
  final DateTime estimatedCompletion;
  final double qualityScore;
  final int defectsFound;
  final String assignedLine;

  const ProductionOrder({
    required this.id,
    required this.vehicleType,
    required this.orderName,
    required this.quantity,
    required this.progressPercentage,
    required this.status,
    required this.startDate,
    required this.estimatedCompletion,
    required this.qualityScore,
    this.defectsFound = 0,
    required this.assignedLine,
  });

  bool get isDelayed =>
      DateTime.now().isAfter(estimatedCompletion) && status != 'Completed';
  bool get hasQualityIssue => qualityScore < 85;
}

/// R&D Project tracker.
class RDProject {
  final String id;
  final String name;
  final String description;
  final double completionPercentage;
  final String status; // Active, Paused, Completed
  final DateTime startDate;
  final DateTime targetDate;

  const RDProject({
    required this.id,
    required this.name,
    required this.description,
    required this.completionPercentage,
    required this.status,
    required this.startDate,
    required this.targetDate,
  });
}
