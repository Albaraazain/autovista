// lib/repositories/interfaces/user_repository.dart
import '../../models/user_model.dart';

abstract class UserRepository {
  Future<UserModel?> getUserById(String uid);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String uid);
  Future<String> getUserName(String uid);
}
