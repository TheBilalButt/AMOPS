/// ================================================
/// File    : drone_model.dart
/// Module  : Models
/// Desc    : Drone asset model
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

class DroneModel {
  final String id;
  final int battery;
  final int altitude;
  final int signal;
  final String status;
  final String camera;

  DroneModel({
    required this.id,
    required this.battery,
    required this.altitude,
    required this.signal,
    required this.status,
    required this.camera,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'battery': battery,
      'altitude': altitude,
      'signal': signal,
      'status': status,
      'camera': camera,
    };
  }

  factory DroneModel.fromMap(Map<String, dynamic> map, String id) {
    return DroneModel(
      id: id,
      battery: map['battery'] ?? 0,
      altitude: map['altitude'] ?? 0,
      signal: map['signal'] ?? 0,
      status: map['status'] ?? 'Standby',
      camera: map['camera'] ?? 'Offline',
    );
  }
}
