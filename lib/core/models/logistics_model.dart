// =============================================================================
// File: logistics_model.dart
// Module: Core / Models
// Description: Models for logistics, supply chain, inventory, and deliveries.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

/// Represents an inventory item in the logistics system.
class InventoryItem {
  final String id;
  final String name;
  final String category;
  final double currentStock;
  final double maxCapacity;
  final double safeLevel;
  final String unit;
  final DateTime lastRestocked;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.currentStock,
    required this.maxCapacity,
    required this.safeLevel,
    required this.unit,
    required this.lastRestocked,
  });

  double get stockPercentage =>
      maxCapacity > 0 ? (currentStock / maxCapacity) * 100 : 0;

  bool get isLowStock => currentStock < safeLevel;
}

/// Represents a delivery being tracked.
class DeliveryTracking {
  final String id;
  final String description;
  final String origin;
  final String destination;
  final String status;
  final DateTime estimatedArrival;
  final double progress;
  final String vehicleId;

  const DeliveryTracking({
    required this.id,
    required this.description,
    required this.origin,
    required this.destination,
    required this.status,
    required this.estimatedArrival,
    required this.progress,
    required this.vehicleId,
  });
}

/// Supplier performance record.
class SupplierScore {
  final String id;
  final String name;
  final double qualityScore;
  final double deliveryScore;
  final double overallScore;
  final int totalOrders;
  final int defectiveOrders;

  const SupplierScore({
    required this.id,
    required this.name,
    required this.qualityScore,
    required this.deliveryScore,
    required this.overallScore,
    required this.totalOrders,
    required this.defectiveOrders,
  });
}
