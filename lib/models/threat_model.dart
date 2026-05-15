/// ================================================
/// File    : threat_model.dart
/// Module  : Models
/// Desc    : Threat detection model
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

class ThreatModel {
  final String id;
  final String sector;
  final String type;
  final String risk;
  final String description;
  final DateTime timestamp;

  ThreatModel({
    required this.id,
    required this.sector,
    required this.type,
    required this.risk,
    required this.description,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'sector': sector,
      'type': type,
      'risk': risk,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ThreatModel.fromMap(Map<String, dynamic> map, String id) {
    return ThreatModel(
      id: id,
      sector: map['sector'] ?? 'Unknown',
      type: map['type'] ?? 'General',
      risk: map['risk'] ?? 'Low',
      description: map['description'] ?? '',
      timestamp: map['timestamp'] != null 
          ? DateTime.parse(map['timestamp']) 
          : DateTime.now(),
    );
  }
}
