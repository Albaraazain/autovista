// lib/models/vehicle_model.dart
class VehicleModel {
  final String id;
  final String userId;
  final String brand;
  final String model;
  final String engineType;
  final int mileage;
  final String region;
  final int makeYear;

  VehicleModel({
    required this.id,
    required this.userId,
    required this.brand,
    required this.model,
    required this.engineType,
    required this.mileage,
    required this.region,
    required this.makeYear,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'brand': brand,
      'model': model,
      'engine_type': engineType,
      'mileage': mileage,
      'region': region,
      'make_year': makeYear,
    };
  }

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      brand: map['brand'] as String,
      model: map['model'] as String,
      engineType: map['engine_type'] as String,
      mileage: map['mileage'] as int,
      region: map['region'] as String,
      makeYear: map['make_year'] as int,
    );
  }
}
