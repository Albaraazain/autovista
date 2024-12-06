import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../interfaces/auth_repository.dart';

class MockUser implements User {
  @override
  final String uid;
  @override
  final String? email;
  @override
  final String? displayName;

  MockUser({required this.uid, this.email, this.displayName});

  // Implement other User methods with dummy returns...
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockUserCredential implements UserCredential {
  @override
  final User? user;

  MockUserCredential({this.user});

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockAuthRepository implements AuthRepository {
  User? _currentUser;
  final _authStateController = StreamController<User?>.broadcast();

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  User? get currentUser => _currentUser;

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate basic validation
    if (!email.contains('@') || password.length < 6) {
      throw FirebaseAuthException(
        code: 'invalid-credential',
        message: 'Invalid email or password',
      );
    }

    // Simulate successful login
    _currentUser = MockUser(
      uid: 'mock-uid',
      email: email,
      displayName: 'Mock User',
    );
    _authStateController.add(_currentUser);

    return MockUserCredential(user: _currentUser);
  }

  @override
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
    required String location,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate basic validation
    if (!email.contains('@') || password.length < 6) {
      throw FirebaseAuthException(
        code: 'invalid-credential',
        message: 'Invalid email or password',
      );
    }

    // Simulate successful registration
    _currentUser = MockUser(
      uid: 'mock-uid-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: name,
    );
    _authStateController.add(_currentUser);

    return MockUserCredential(user: _currentUser);
  }

  @override
  Future<void> signOut() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    _currentUser = null;
    _authStateController.add(null);
  }

  // Clean up resources
  void dispose() {
    _authStateController.close();
  }
}