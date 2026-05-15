/// ================================================
/// File    : production_model.dart
/// Module  : Models
/// Desc    : Manufacturing order model
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

class ProductionModel {
  final String id;
  final String vehicleType;
  final int quantity;
  final int progress;
  final String status;
  final String expectedDate;

  ProductionModel({
    required this.id,
    required this.vehicleType,
    required this.quantity,
    required this.progress,
    required this.status,
    required this.expectedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'vehicle_type': vehicleType,
      'quantity': quantity,
      'progress': progress,
      'status': status,
      'expected_date': expectedDate,
    };
  }

  factory ProductionModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductionModel(
      id: id,
      vehicleType: map['vehicle_type'] ?? '',
      quantity: map['quantity'] ?? 0,
      progress: map['progress'] ?? 0,
      status: map['status'] ?? 'Scheduled',
      expectedDate: map['expected_date'] ?? '',
    );
  }
}
