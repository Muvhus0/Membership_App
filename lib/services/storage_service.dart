import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  bool hasSeeded() {
    return _prefs.getBool(AppConstants.keyHasSeededProfiles) ?? false;
  }

  Future<void> setSeeded(bool seeded) async {
    await _prefs.setBool(AppConstants.keyHasSeededProfiles, seeded);
  }

  List<UserModel> getUsers() {
    final jsonString = _prefs.getString(AppConstants.keyUsersJson);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded
          .map((item) => UserModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveUsers(List<UserModel> users) async {
    final jsonString = jsonEncode(users.map((u) => u.toJson()).toList());
    await _prefs.setString(AppConstants.keyUsersJson, jsonString);
  }

  String? getCurrentUserEmail() {
    return _prefs.getString(AppConstants.keyCurrentUserEmail);
  }

  Future<void> saveCurrentUserEmail(String? email) async {
    if (email == null) {
      await _prefs.remove(AppConstants.keyCurrentUserEmail);
    } else {
      await _prefs.setString(AppConstants.keyCurrentUserEmail, email);
    }
  }

  Future<void> clearSession() async {
    await _prefs.remove(AppConstants.keyCurrentUserEmail);
  }
}
