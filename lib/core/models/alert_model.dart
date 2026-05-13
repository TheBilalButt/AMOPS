// =============================================================================
// File: alert_model.dart
// Module: Core / Models
// Description: Model for system alerts and notifications.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

/// Represents a system alert or notification.
class AlertModel {
  final String id;
  final String title;
  final String message;
  final String severity; // Info, Warning, Critical
  final String module; // Dashboard, Drones, Vehicles, etc.
  final DateTime timestamp;
  final bool isRead;

  const AlertModel({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.module,
    required this.timestamp,
    this.isRead = false,
  });
}
