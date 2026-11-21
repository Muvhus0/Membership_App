import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/user_model.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final StorageService _storageService;

  List<UserModel> _users = [];
  UserModel? _currentUser;
  bool _isLoading = true;

  AuthProvider(this._storageService);

  List<UserModel> get users => List.unmodifiable(_users);
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  void initialize(List<UserModel> initialUsers) {
    _users = List.from(initialUsers);
    //restore the previous session using the saved email.
    //if the profile no longer exists, clear the invalid session.
    final savedEmail = _storageService.getCurrentUserEmail();
    if (savedEmail != null && savedEmail.isNotEmpty) {
      final index = _users.indexWhere(
        (u) => u.email.toLowerCase() == savedEmail.toLowerCase(),
      );
      if (index != -1) {
        _currentUser = _users[index];
      } else {
        _storageService.clearSession();
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> signIn(String email) async {
    final cleanEmail = email.trim().toLowerCase();
    final index = _users.indexWhere(
      (u) => u.email.trim().toLowerCase() == cleanEmail,
    );
    if (index == -1) return false;
    final user = _users[index];
    await _storageService.saveCurrentUserEmail(user.email);
    _currentUser = user;
    notifyListeners();
    return true;
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String membershipId,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanName = name.trim();

    final exists = _users.any((u) => u.email.toLowerCase() == cleanEmail);
    if (exists) {
      throw Exception('An account with this email address already exists.');
    }

    final newId = 'usr_${const Uuid().v4().substring(0, 8)}';
    final newUser = UserModel(
      id: newId,
      name: cleanName,
      email: cleanEmail,
      membershipId: membershipId,
    );

    _users.add(newUser);
    await _storageService.saveUsers(_users);

    _currentUser = newUser;
    await _storageService.saveCurrentUserEmail(newUser.email);
    notifyListeners();
  }

  Future<void> updateUserMembership(
    String userId,
    String newMembershipId,
  ) async {
    //only allow upgrades to a higher membership tier.
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      final updatedUser = _users[index].copyWith(membershipId: newMembershipId);
      _users[index] = updatedUser;
      await _storageService.saveUsers(_users);

      if (_currentUser?.id == userId) {
        _currentUser = updatedUser;
      }
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _currentUser = null;
    await _storageService.clearSession();
    notifyListeners();
  }

  Future<void> deleteCurrentProfile() async {
    if (_currentUser == null) return;
    //delete only the currently authenticated user's profile.
    //keep the seed flag unchanged so deleted default profiles stay deleted.
    final targetId = _currentUser!.id;
    _users.removeWhere((u) => u.id == targetId);
    await _storageService.saveUsers(_users);

    _currentUser = null;
    await _storageService.clearSession();
    notifyListeners();
  }
}
