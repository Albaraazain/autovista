// lib/repositories/interfaces/auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  // Authentication state
  Stream<User?> get authStateChanges;

  // Sign in
  Future<UserCredential> signIn({
    required String email,
    required String password,
  });

  // Sign up
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
    required String location,
  });

  // Sign out
  Future<void> signOut();

  // Get current user
  User? get currentUser;
}
