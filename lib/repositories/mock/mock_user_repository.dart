// lib/repositories/mock/mock_user_repository.dart
import '../interfaces/user_repository.dart';
import '../../models/user_model.dart';

class MockUserRepository implements UserRepository {
  final Map<String, UserModel> _users = {};

  @override
  Future<UserModel?> getUserById(String uid) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return _users[uid];
  }

  @override
  Future<String> getUserName(String uid) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _users[uid]?.name ?? 'Mock User';
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _users[user.uid] = user;
  }

  @override
  Future<void> deleteUser(String uid) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _users.remove(uid);
  }
}