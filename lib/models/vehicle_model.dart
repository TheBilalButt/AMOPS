/// ================================================
/// File    : vehicle_model.dart
/// Module  : Models
/// Desc    : Vehicle asset model (Tanks, APCs, ASVs)
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

class VehicleModel {
  final String id;
  final String type;
  final int fuel;
  final int ammo;
  final int engineHours;
  final String status;
  final int readiness;

  VehicleModel({
    required this.id,
    required this.type,
    required this.fuel,
    required this.ammo,
    required this.engineHours,
    required this.status,
    required this.readiness,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'fuel': fuel,
      'ammo': ammo,
      'engine_hours': engineHours,
      'status': status,
      'readiness': readiness,
    };
  }

  factory VehicleModel.fromMap(Map<String, dynamic> map, String id) {
    return VehicleModel(
      id: id,
      type: map['type'] ?? 'Unknown',
      fuel: map['fuel'] ?? 0,
      ammo: map['ammo'] ?? 0,
      engineHours: map['engine_hours'] ?? 0,
      status: map['status'] ?? 'Operational',
      readiness: map['readiness'] ?? 0,
    );
  }
}
