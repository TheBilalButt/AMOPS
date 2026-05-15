/// ================================================
/// File    : supply_model.dart
/// Module  : Models
/// Desc    : Inventory and supply item model
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

class SupplyModel {
  final String id;
  final String name;
  final int current;
  final int threshold;
  final String unit;

  SupplyModel({
    required this.id,
    required this.name,
    required this.current,
    required this.threshold,
    required this.unit,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'current': current,
      'threshold': threshold,
      'unit': unit,
    };
  }

  factory SupplyModel.fromMap(Map<String, dynamic> map, String id) {
    return SupplyModel(
      id: id,
      name: map['name'] ?? '',
      current: map['current'] ?? 0,
      threshold: map['threshold'] ?? 0,
      unit: map['unit'] ?? '',
    );
  }
}
