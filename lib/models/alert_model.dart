/// ================================================
/// File    : alert_model.dart
/// Module  : Models
/// Desc    : System alert and notification model
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

class AlertModel {
  final String id;
  final String title;
  final String message;
  final String level; // Critical, Warning, Info
  final DateTime timestamp;

  AlertModel({
    required this.id,
    required this.title,
    required this.message,
    required this.level,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'level': level,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory AlertModel.fromMap(Map<String, dynamic> map, String id) {
    return AlertModel(
      id: id,
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      level: map['level'] ?? 'Info',
      timestamp: map['timestamp'] != null 
          ? DateTime.parse(map['timestamp']) 
          : DateTime.now(),
    );
  }
}
