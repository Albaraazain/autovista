// lib/providers/vehicle_provider.dart
import 'package:flutter/foundation.dart';
import '../repositories/interfaces/vehicle_repository.dart';
import '../models/vehicle_model.dart';

class VehicleProvider extends ChangeNotifier {
  final VehicleRepository _vehicleRepository;
  List<VehicleModel> _userVehicles = [];
  VehicleModel? _selectedVehicle;
  bool _isLoading = false;
  String? _error;

  VehicleProvider(this._vehicleRepository);

  List<VehicleModel> get userVehicles => _userVehicles;
  VehicleModel? get selectedVehicle => _selectedVehicle;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUserVehicles(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _userVehicles = await _vehicleRepository.getVehiclesByUserId(userId);
    } catch (e) {
      _error = 'Failed to load vehicles: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addVehicle(VehicleModel vehicle) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newVehicle = await _vehicleRepository.addVehicle(vehicle);
      _userVehicles.add(newVehicle);
    } catch (e) {
      _error = 'Failed to add vehicle: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateVehicle(VehicleModel vehicle) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _vehicleRepository.updateVehicle(vehicle);
      final index = _userVehicles.indexWhere((v) => v.id == vehicle.id);
      if (index != -1) {
        _userVehicles[index] = vehicle;
      }
      if (_selectedVehicle?.id == vehicle.id) {
        _selectedVehicle = vehicle;
      }
    } catch (e) {
      _error = 'Failed to update vehicle: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteVehicle(String vehicleId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _vehicleRepository.deleteVehicle(vehicleId);
      _userVehicles.removeWhere((v) => v.id == vehicleId);
      if (_selectedVehicle?.id == vehicleId) {
        _selectedVehicle = null;
      }
    } catch (e) {
      _error = 'Failed to delete vehicle: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectVehicle(VehicleModel vehicle) {
    _selectedVehicle = vehicle;
    notifyListeners();
  }

  void clearSelectedVehicle() {
    _selectedVehicle = null;
    notifyListeners();
  }
}