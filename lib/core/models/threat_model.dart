// =============================================================================
// File: threat_model.dart
// Module: Core / Models
// Description: Data model for threat intelligence events and risk tracking.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

/// Represents a threat event detected by the intelligence engine.
class ThreatModel {
  final String id;
  final String type; // Aerial Intrusion, Ground Movement, Cyber Attack, etc.
  final String riskLevel; // Low, Medium, High, Critical
  final String sector;
  final String location;
  final double latitude;
  final double longitude;
  final String description;
  final DateTime timestamp;
  final bool isPatternMatch;
  final bool isGeoFenceViolation;

  const ThreatModel({
    required this.id,
    required this.type,
    required this.riskLevel,
    required this.sector,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.timestamp,
    this.isPatternMatch = false,
    this.isGeoFenceViolation = false,
  });
}

/// Represents a radar alert event.
class RadarAlert {
  final String id;
  final String type;
  final String bearing;
  final double distance;
  final DateTime timestamp;
  final String status; // Active, Resolved, Monitoring

  const RadarAlert({
    required this.id,
    required this.type,
    required this.bearing,
    required this.distance,
    required this.timestamp,
    required this.status,
  });
}
