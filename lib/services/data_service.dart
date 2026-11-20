import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/membership_model.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';
import 'storage_service.dart';

class DataService {
  Future<List<MembershipModel>> loadMemberships() async {
    final jsonString = await rootBundle.loadString(
      AppConstants.membershipsJsonPath,
    );
    final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded
        .map((item) => MembershipModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<UserModel>> loadInitialUsers() async {
    final jsonString = await rootBundle.loadString(AppConstants.usersJsonPath);
    final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded
        .map((item) => UserModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<UserModel>> seedInitialUsersIfNeeded(
    StorageService storageService,
  ) async {
    //this seeds the supplied profiles only on the first launch.
    if (!storageService.hasSeeded()) {
      final initialUsers = await loadInitialUsers();
      await storageService.saveUsers(initialUsers);
      await storageService.setSeeded(true);
      return initialUsers;
    } else {
      return storageService.getUsers();
    }
  }
}
