import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_model.dart';

class CarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create (Add a new car)
  Future<void> addCar(Car car) async {
    try {
      await _firestore.collection('cars').add(car.toJson());
      print("Car added successfully!");
    } catch (e) {
      print("Error adding car: $e");
      throw e;
    }
  }

  // Read (Get all cars for a specific user)
  Future<List<Car>> getCarsByUserId(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('cars')
          .where('user_id', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => Car.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
          .toList();
    } catch (e) {
      print("Error fetching cars: $e");
      throw e;
    }
  }

  // Update (Edit an existing car)
  Future<void> updateCar(String carId, Car car) async {
    try {
      await _firestore.collection('cars').doc(carId).update(car.toJson());
      print("Car updated successfully!");
    } catch (e) {
      print("Error updating car: $e");
      throw e;
    }
  }

  // Delete (Remove a car)
  Future<void> deleteCar(String carId) async {
    try {
      await _firestore.collection('cars').doc(carId).delete();
      print("Car deleted successfully!");
    } catch (e) {
      print("Error deleting car: $e");
      throw e;
    }
  }
}
