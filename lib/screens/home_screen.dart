import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  final String userId; // Firebase UID

  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  Future<String> _getUserName() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        return userData?['name'] ??
            'User'; // Default to 'User' if name is not found
      } else {
        return 'User';
      }
    } catch (e) {
      return 'User'; // Fallback in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              FutureBuilder<String>(
                future: _getUserName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Show a loader while fetching the name
                  } else if (snapshot.hasError) {
                    return const Text("Error loading user information.");
                  } else {
                    return Text(
                      "Welcome to AutoVista, ${snapshot.data}!",
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                "Your one-stop solution for managing your vehicles.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Icon-based Menu
              Flexible(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    // View Profile Button
                    _buildMenuButton(
                      context,
                      icon: Icons.person,
                      label: "View Profile",
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/profile',
                          arguments: userId, // Pass userId as String
                        );
                      },
                    ),
                    // Edit Vehicle Information Button
                    _buildMenuButton(
                      context,
                      icon: Icons.car_repair,
                      label: "Edit Vehicle Info",
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/viewVehicle',
                          arguments: {
                            'userId': userId,
                            'vehicleData': null,
                          },
                        );
                      },
                    ),
                    // View Scanned Documents Button
                    _buildMenuButton(
                      context,
                      icon: Icons.document_scanner,
                      label: "View Documents",
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/viewDocuments',
                          arguments: userId,
                        );
                      },
                    ),
                    // Event Planner Button
                    _buildMenuButton(
                      context,
                      icon: Icons.event,
                      label: "Event Planner",
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/eventScreen',
                          arguments: userId,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Logout Functionality
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }
}
