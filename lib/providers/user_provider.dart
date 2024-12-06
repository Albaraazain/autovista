// lib/providers/user_provider.dart
import 'package:flutter/foundation.dart';
import '../repositories/interfaces/user_repository.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository;
  UserModel? _currentUser;
  bool _isLoading = false;

  UserProvider(this._userRepository);

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> loadUser(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _userRepository.getUserById(uid);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> getUserName(String uid) async {
    return await _userRepository.getUserName(uid);
  }

  Future<void> updateUser(UserModel user) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userRepository.updateUser(user);
      _currentUser = user;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userRepository.deleteUser(uid);
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}