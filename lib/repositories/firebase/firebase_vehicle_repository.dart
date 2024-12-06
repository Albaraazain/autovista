// lib/repositories/firebase/firebase_vehicle_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../interfaces/vehicle_repository.dart';
import '../../models/vehicle_model.dart';

class FirebaseVehicleRepository implements VehicleRepository {
  final FirebaseFirestore _firestore;

  FirebaseVehicleRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<VehicleModel>> getVehiclesByUserId(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('vehicles')
          .where('user_id', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => VehicleModel.fromMap({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      print('Error getting vehicles: $e');
      rethrow;
    }
  }

  @override
  Future<VehicleModel?> getVehicleById(String vehicleId) async {
    try {
      final doc = await _firestore.collection('vehicles').doc(vehicleId).get();
      if (doc.exists) {
        return VehicleModel.fromMap({
          ...doc.data()!,
          'id': doc.id,
        });
      }
      return null;
    } catch (e) {
      print('Error getting vehicle: $e');
      rethrow;
    }
  }

  @override
  Future<VehicleModel> addVehicle(VehicleModel vehicle) async {
    try {
      final docRef = await _firestore.collection('vehicles').add(vehicle.toMap());
      return vehicle;
    } catch (e) {
      print('Error adding vehicle: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateVehicle(VehicleModel vehicle) async {
    try {
      await _firestore
          .collection('vehicles')
          .doc(vehicle.id)
          .update(vehicle.toMap());
    } catch (e) {
      print('Error updating vehicle: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteVehicle(String vehicleId) async {
    try {
      await _firestore.collection('vehicles').doc(vehicleId).delete();
    } catch (e) {
      print('Error deleting vehicle: $e');
      rethrow;
    }
  }
}

