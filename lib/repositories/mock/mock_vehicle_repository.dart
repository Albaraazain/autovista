// lib/repositories/mock/mock_vehicle_repository.dart
import '../interfaces/vehicle_repository.dart';
import '../../models/vehicle_model.dart';

class MockVehicleRepository implements VehicleRepository {
  final Map<String, VehicleModel> _vehicles = {};

  @override
  Future<List<VehicleModel>> getVehiclesByUserId(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _vehicles.values
        .where((vehicle) => vehicle.userId == userId)
        .toList();
  }

  @override
  Future<VehicleModel?> getVehicleById(String vehicleId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _vehicles[vehicleId];
  }

  @override
  Future<VehicleModel> addVehicle(VehicleModel vehicle) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _vehicles[vehicle.id] = vehicle;
    return vehicle;
  }

  @override
  Future<void> updateVehicle(VehicleModel vehicle) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _vehicles[vehicle.id] = vehicle;
  }

  @override
  Future<void> deleteVehicle(String vehicleId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _vehicles.remove(vehicleId);
  }
}