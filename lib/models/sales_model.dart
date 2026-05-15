/// ================================================
/// File    : sales_model.dart
/// Module  : Models
/// Desc    : Sales deal and opportunity model
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

class SalesModel {
  final String id;
  final String country;
  final String product;
  final String value;
  final String stage;
  final int winProbability;

  SalesModel({
    required this.id,
    required this.country,
    required this.product,
    required this.value,
    required this.stage,
    required this.winProbability,
  });

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'product': product,
      'value': value,
      'stage': stage,
      'win_probability': winProbability,
    };
  }

  factory SalesModel.fromMap(Map<String, dynamic> map, String id) {
    return SalesModel(
      id: id,
      country: map['country'] ?? '',
      product: map['product'] ?? '',
      value: map['value'] ?? '',
      stage: map['stage'] ?? 'Lead',
      winProbability: map['win_probability'] ?? 0,
    );
  }
}
