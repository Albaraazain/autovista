class Car {
  final String id; // Firebase document ID
  final String userId; // Firebase UID
  final String brand;
  final String model;
  final String engineType;
  final int mileage;
  final String region;
  final int makeYear;

  Car({
    required this.id, // Accepts String instead of int
    required this.userId,
    required this.brand,
    required this.model,
    required this.engineType,
    required this.mileage,
    required this.region,
    required this.makeYear,
  });

  // Convert Car object to JSON
  Map<String, dynamic> toJson() {
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

  // Convert JSON to Car object
  static Car fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] as String, // Expecting String for id
      userId: json['user_id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      engineType: json['engine_type'] as String,
      mileage: json['mileage'] as int,
      region: json['region'] as String,
      makeYear: json['make_year'] as int,
    );
  }
}
