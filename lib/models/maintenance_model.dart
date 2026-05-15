/// ================================================
/// File    : maintenance_model.dart
/// Module  : Models
/// Desc    : Maintenance log and work order model
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

class MaintenanceModel {
  final String id;
  final String vehicleId;
  final String fault;
  final String date;
  final String technician;
  final String status;

  MaintenanceModel({
    required this.id,
    required this.vehicleId,
    required this.fault,
    required this.date,
    required this.technician,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'vehicle_id': vehicleId,
      'fault': fault,
      'date': date,
      'technician': technician,
      'status': status,
    };
  }

  factory MaintenanceModel.fromMap(Map<String, dynamic> map, String id) {
    return MaintenanceModel(
      id: id,
      vehicleId: map['vehicle_id'] ?? '',
      fault: map['fault'] ?? '',
      date: map['date'] ?? '',
      technician: map['technician'] ?? '',
      status: map['status'] ?? 'Open',
    );
  }
}
