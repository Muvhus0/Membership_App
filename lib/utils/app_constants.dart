class AppConstants {
  static const String appName = 'Membership App';

  // Shared preferences //
  static const String keyHasSeededProfiles = 'has_seeded_profiles';
  static const String keyUsersJson = 'users_json';
  static const String keyCurrentUserEmail = 'current_user_email';

  // Asset paths for the provided data//
  static const String usersJsonPath = 'assets/data/users.json';
  static const String membershipsJsonPath = 'assets/data/memberships.json';

  // Membership tier IDs
  static const String tierStarter = 'starter';
  static const String tierPlus = 'plus';
  static const String tierPremium = 'premium';

  // Tier hierarchy
  static const Map<String, int> tierRank = {
    tierStarter: 1,
    tierPlus: 2,
    tierPremium: 3,
  };
}
