// lib/repositories/interfaces/vehicle_repository.dart
import '../../models/vehicle_model.dart';

abstract class VehicleRepository {
  Future<List<VehicleModel>> getVehiclesByUserId(String userId);
  Future<VehicleModel?> getVehicleById(String vehicleId);
  Future<VehicleModel> addVehicle(VehicleModel vehicle);
  Future<void> updateVehicle(VehicleModel vehicle);
  Future<void> deleteVehicle(String vehicleId);
}