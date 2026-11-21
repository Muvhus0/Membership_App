import 'package:flutter_test/flutter_test.dart';
import 'package:membership_app/models/user_model.dart';
import 'package:membership_app/providers/auth_provider.dart';
import 'package:membership_app/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storageService;
  late AuthProvider authProvider;

  final initialUsers = [
    const UserModel(
      id: 'usr_1001',
      name: 'Naledi Mokoena',
      email: 'naledi.mokoena@example.com',
      membershipId: 'starter',
    ),
    const UserModel(
      id: 'usr_1002',
      name: 'Thabo Dlamini',
      email: 'thabo.dlamini@example.com',
      membershipId: 'plus',
    ),
  ];

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    storageService = await StorageService.getInstance();
    authProvider = AuthProvider(storageService);

    authProvider.initialize(initialUsers);
  });

  test('AuthProvider loads initial users on initialize', () {
    expect(authProvider.users.length, equals(2));
    expect(authProvider.isAuthenticated, isFalse);
  });

  test('SignIn succeeds with valid email', () async {
    final success = await authProvider.signIn('thabo.dlamini@example.com');

    expect(success, isTrue);
    expect(authProvider.isAuthenticated, isTrue);
    expect(authProvider.currentUser?.name, equals('Thabo Dlamini'));
  });

  test('SignIn fails with invalid email', () async {
    final success = await authProvider.signIn('unknown@example.com');

    expect(success, isFalse);
    expect(authProvider.isAuthenticated, isFalse);
  });

  test('SignUp creates a new user and signs in', () async {
    await authProvider.signUp(
      name: 'New User',
      email: 'new.user@example.com',
      membershipId: 'plus',
    );

    expect(authProvider.users.length, equals(3));
    expect(authProvider.isAuthenticated, isTrue);
    expect(authProvider.currentUser?.email, equals('new.user@example.com'));
    expect(authProvider.currentUser?.membershipId, equals('plus'));
  });

  test('SignUp throws exception when email already exists', () async {
    await expectLater(
      authProvider.signUp(
        name: 'Duplicate',
        email: 'naledi.mokoena@example.com',
        membershipId: 'starter',
      ),
      throwsA(isA<Exception>()),
    );
  });

  test('updateUserMembership changes membership ID and persists', () async {
    await authProvider.signIn('naledi.mokoena@example.com');

    expect(authProvider.currentUser?.membershipId, equals('starter'));

    await authProvider.updateUserMembership('usr_1001', 'premium');

    expect(authProvider.currentUser?.membershipId, equals('premium'));

    expect(
      authProvider.users.firstWhere((u) => u.id == 'usr_1001').membershipId,
      equals('premium'),
    );

    //check that the updated membership was saved locally.
    final savedUsers = storageService.getUsers();

    expect(
      savedUsers.firstWhere((u) => u.id == 'usr_1001').membershipId,
      equals('premium'),
    );
  });

  test('deleteCurrentProfile removes profile and signs out', () async {
    await authProvider.signIn('naledi.mokoena@example.com');

    expect(authProvider.users.length, equals(2));

    await authProvider.deleteCurrentProfile();

    expect(authProvider.isAuthenticated, isFalse);
    expect(authProvider.users.length, equals(1));

    expect(
      authProvider.users.any((u) => u.email == 'naledi.mokoena@example.com'),
      isFalse,
    );

    //check that deletion was persisted.
    expect(storageService.getUsers().length, equals(1));
  });
}
