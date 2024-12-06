import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_model.dart';

class ViewVehicleScreen extends StatefulWidget {
  final Map<String, dynamic>? vehicleData; // Vehicle data if editing
  final String? carId; // Car ID if editing an existing car (Firebase document ID)
  final String userId; // Firebase UID for the logged-in user

  const ViewVehicleScreen({
    Key? key,
    this.vehicleData,
    this.carId,
    required this.userId,
  }) : super(key: key);

  @override
  State<ViewVehicleScreen> createState() => _ViewVehicleScreenState();
}

class _ViewVehicleScreenState extends State<ViewVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _engineTypeController;
  late TextEditingController _mileageController;
  late TextEditingController _regionController;
  late TextEditingController _makeYearController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(text: widget.vehicleData?['brand'] ?? '');
    _modelController = TextEditingController(text: widget.vehicleData?['model'] ?? '');
    _engineTypeController = TextEditingController(text: widget.vehicleData?['engine_type'] ?? '');
    _mileageController = TextEditingController(text: widget.vehicleData?['mileage']?.toString() ?? '');
    _regionController = TextEditingController(text: widget.vehicleData?['region'] ?? '');
    _makeYearController = TextEditingController(text: widget.vehicleData?['make_year']?.toString() ?? '');
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _engineTypeController.dispose();
    _mileageController.dispose();
    _regionController.dispose();
    _makeYearController.dispose();
    super.dispose();
  }

  Future<void> _saveVehicleInfo() async {
    if (_formKey.currentState!.validate()) {
      final car = Car(
        id: widget.carId ?? '', // Use Firebase document ID or empty for new cars
        userId: widget.userId, // Use Firebase UID
        brand: _brandController.text,
        model: _modelController.text,
        engineType: _engineTypeController.text,
        mileage: int.tryParse(_mileageController.text) ?? 0,
        region: _regionController.text,
        makeYear: int.tryParse(_makeYearController.text) ?? 0,
      );

      try {
        if (widget.carId == null) {
          // Register new car
          await _registerCar(car);
        } else {
          // Update existing car
          await _updateCar(car);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vehicle info saved successfully!")),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving vehicle: $e")),
        );
      }
    }
  }

  Future<void> _registerCar(Car car) async {
    try {
      await _firestore.collection('cars').add(car.toJson());
      print("Car added successfully!");
    } catch (e) {
      throw Exception("Failed to register car: $e");
    }
  }

  Future<void> _updateCar(Car car) async {
    if (widget.carId == null) return;

    try {
      await _firestore.collection('cars').doc(widget.carId).update(car.toJson());
      print("Car updated successfully!");
    } catch (e) {
      throw Exception("Failed to update car: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View/Edit Vehicle Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: "Brand"),
                validator: (value) => value == null || value.isEmpty ? "Please enter the brand" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: "Model"),
                validator: (value) => value == null || value.isEmpty ? "Please enter the model" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _engineTypeController,
                decoration: const InputDecoration(labelText: "Engine Type"),
                validator: (value) => value == null || value.isEmpty ? "Please enter the engine type" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mileageController,
                decoration: const InputDecoration(labelText: "Mileage (km)"),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? "Please enter the mileage" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _regionController,
                decoration: const InputDecoration(labelText: "Region"),
                validator: (value) => value == null || value.isEmpty ? "Please enter the region" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _makeYearController,
                decoration: const InputDecoration(labelText: "Make Year"),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? "Please enter the make year" : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveVehicleInfo,
                child: const Text("Save Vehicle Info"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
