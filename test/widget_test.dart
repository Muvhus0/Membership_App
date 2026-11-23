import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:membership_app/models/feature_model.dart';
import 'package:membership_app/models/membership_model.dart';
import 'package:membership_app/models/user_model.dart';
import 'package:membership_app/providers/auth_provider.dart';
import 'package:membership_app/providers/membership_provider.dart';
import 'package:membership_app/screens/auth/sign_in_screen.dart';
import 'package:membership_app/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SignInScreen renders correctly with test accounts', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final storageService = await StorageService.getInstance();

    final testUsers = [
      const UserModel(
        id: 'usr_1001',
        name: 'Naledi Mokoena',
        email: 'naledi.mokoena@example.com',
        membershipId: 'starter',
      ),
    ];

    final testMemberships = [
      const MembershipModel(
        id: 'starter',
        name: 'Starter',
        features: [
          FeatureModel(id: 'browse_catalogue', name: 'Browse Catalogue'),
        ],
      ),
    ];

    final authProvider = AuthProvider(storageService)..initialize(testUsers);
    final membershipProvider = MembershipProvider()
      ..initialize(testMemberships);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authProvider),
          ChangeNotifierProvider.value(value: membershipProvider),
        ],
        child: const MaterialApp(home: SignInScreen()),
      ),
    );

    expect(find.text('Sign In'), findsWidgets);
    expect(find.text('Email Address'), findsOneWidget);
  });

  testWidgets(
    'SignInScreen submits when email is entered and button is pressed',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final storageService = await StorageService.getInstance();

      final testUsers = [
        const UserModel(
          id: 'usr_1001',
          name: 'Naledi Mokoena',
          email: 'naledi.mokoena@example.com',
          membershipId: 'starter',
        ),
      ];

      final testMemberships = [
        const MembershipModel(
          id: 'starter',
          name: 'Starter',
          features: [
            FeatureModel(id: 'browse_catalogue', name: 'Browse Catalogue'),
          ],
        ),
      ];

      final authProvider = AuthProvider(storageService)..initialize(testUsers);
      final membershipProvider = MembershipProvider()
        ..initialize(testMemberships);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: authProvider),
            ChangeNotifierProvider.value(value: membershipProvider),
          ],
          child: const MaterialApp(home: SignInScreen()),
        ),
      );

      //Enter email
      await tester.enterText(
        find.byType(TextFormField),
        'naledi.mokoena@example.com',
      );
      await tester.pump();

      //tap the custom button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(authProvider.isAuthenticated, isTrue);
    },
  );
}
