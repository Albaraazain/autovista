import 'package:autovista/screens/profile_screen.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'config/firebase_initialize.dart';

import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/view_vehicle_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await FirebaseInitialize.init();
    runApp(const AutoVistaApp());
  } catch (e) {
    print('Failed to initialize Firebase: $e');
    runApp(ErrorApp(message: 'Failed to initialize Firebase: $e'));
  }
}

class AutoVistaApp extends StatelessWidget {
  const AutoVistaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AutoVista',
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());

          case '/signup':
            return MaterialPageRoute(builder: (_) => const SignupScreen());

          case '/home':
            final String? userId = settings.arguments as String?;
            if (userId != null) {
              return MaterialPageRoute(
                  builder: (_) => HomeScreen(userId: userId));
            }
            return _errorRoute("Missing or invalid 'userId' for HomeScreen");

          case '/viewVehicle':
            // Handle both String and Map arguments
            String? userId;
            Map<String, dynamic>? vehicleData;

            if (settings.arguments is String) {
              userId = settings.arguments as String;
            } else if (settings.arguments is Map<String, dynamic>) {
              final args = settings.arguments as Map<String, dynamic>;
              userId = args['userId'] as String?;
              vehicleData = args['vehicleData'] as Map<String, dynamic>?;
            }
            if (userId != null) {
              return MaterialPageRoute(
                builder: (_) => ViewVehicleScreen(
                  userId: userId!,
                  vehicleData: vehicleData,
                ),
              );
            }
            return _errorRoute(
                "Missing or invalid arguments for ViewVehicleScreen");

          case '/profile':
            final String? userId = settings.arguments as String?;
            if (userId != null) {
              return MaterialPageRoute(builder: (_) => ProfileScreen());
            }
            return _errorRoute("Missing or invalid 'userId' for ProfileScreen");

          case '/viewDocuments':
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Documents')),
                body: const Center(
                  child: Text('Documents feature coming soon!'),
                ),
              ),
            );

          case '/eventScreen':
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Events')),
                body: const Center(
                  child: Text('Event planning feature coming soon!'),
                ),
              ),
            );

          default:
            return _errorRoute("Unknown route: ${settings.name}");
        }
      },
    );
  }

  MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance
          .authStateChanges(), // Listen to auth state changes
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // Show a loading spinner
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: Center(
              child: Text(
                "An error occurred: ${snapshot.error}",
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          // If user is logged in, navigate to HomeScreen
          return HomeScreen(
              userId: snapshot.data!.uid); // Pass the Firebase UID
        } else {
          // If user is not logged in, navigate to LoginScreen
          return const LoginScreen();
        }
      },
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String message;

  const ErrorApp({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
