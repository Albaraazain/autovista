// lib/main.dart
import 'package:autovista/providers/vehicle_provider.dart';
import 'package:autovista/repositories/firebase/firebase_vehicle_repository.dart';
import 'package:autovista/repositories/interfaces/vehicle_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'config/firebase_initialize.dart';
import 'repositories/firebase/firebase_auth_repository.dart';
import 'repositories/firebase/firebase_user_repository.dart'; // Add this import
import 'repositories/interfaces/auth_repository.dart';
import 'repositories/interfaces/user_repository.dart'; // Add this import
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart'; // Add this import
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
    return MultiProvider(
      providers: [
        // Repositories
        Provider<AuthRepository>(
          create: (_) => FirebaseAuthRepository(),
        ),
        Provider<UserRepository>(
          create: (_) => FirebaseUserRepository(),
        ),
        Provider<VehicleRepository>(
          create: (_) => FirebaseVehicleRepository(),
        ),

        // Providers
        ChangeNotifierProxyProvider<AuthRepository, AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
          update: (context, authRepository, previous) =>
              previous ?? AuthProvider(authRepository),
        ),
        ChangeNotifierProxyProvider<UserRepository, UserProvider>(
          create: (context) => UserProvider(context.read<UserRepository>()),
          update: (context, userRepository, previous) =>
              previous ?? UserProvider(userRepository),
        ),
        ChangeNotifierProxyProvider<VehicleRepository, VehicleProvider>(
          create: (context) =>
              VehicleProvider(context.read<VehicleRepository>()),
          update: (context, vehicleRepository, previous) =>
              previous ?? VehicleProvider(vehicleRepository),
        ),
      ],
      child: MaterialApp(
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
              final Map<String, dynamic>? args =
                  settings.arguments as Map<String, dynamic>?;
              if (args != null && args['userId'] is String) {
                final String userId = args['userId'] as String;
                final Map<String, dynamic>? vehicleData =
                    args['vehicleData'] as Map<String, dynamic>?;
                return MaterialPageRoute(
                  builder: (_) => ViewVehicleScreen(
                      userId: userId, vehicleData: vehicleData),
                );
              }
              return _errorRoute(
                  "Missing or invalid arguments for ViewVehicleScreen");
            case '/viewDocuments':
              return MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: const Text('Documents')),
                  body: const Center(
                      child: Text('Documents feature coming soon')),
                ),
              );
            case '/eventScreen':
              return MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: const Text('Events')),
                  body: const Center(child: Text('Events feature coming soon')),
                ),
              );
            default:
              return _errorRoute("Unknown route: ${settings.name}");
          }
        },
      ),
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
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return StreamBuilder<firebase_auth.User?>(
          stream: authProvider.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
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
              return HomeScreen(userId: snapshot.data!.uid);
            } else {
              return const LoginScreen();
            }
          },
        );
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
