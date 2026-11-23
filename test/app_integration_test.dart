import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:membership_app/main.dart' as app;
import 'package:membership_app/models/feature_model.dart';
import 'package:membership_app/models/membership_model.dart';
import 'package:membership_app/models/user_model.dart';
import 'package:membership_app/providers/auth_provider.dart';
import 'package:membership_app/providers/membership_provider.dart';
import 'package:membership_app/services/storage_service.dart';
import 'package:membership_app/widgets/buttons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Application Integration Tests...', () {
    late StorageService storageService;

    final testUsers = [
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
      const UserModel(
        id: 'usr_1003',
        name: 'Aisha Jacobs',
        email: 'aisha.jacobs@example.com',
        membershipId: 'premium',
      ),
      const UserModel(
        id: 'usr_1004',
        name: 'Lerato Nkosi',
        email: 'lerato.nkosi@example.com',
        membershipId: 'starter',
      ),
      const UserModel(
        id: 'usr_1005',
        name: 'Sipho Khumalo',
        email: 'sipho.khumalo@example.com',
        membershipId: 'plus',
      ),
    ];

    final testMemberships = [
      const MembershipModel(
        id: 'starter',
        name: 'Starter',
        features: [
          FeatureModel(id: 'browse_catalogue', name: 'Browse Catalogue'),
          FeatureModel(id: 'starter_guides', name: 'Starter Guides'),
        ],
      ),
      const MembershipModel(
        id: 'plus',
        name: 'Plus',
        features: [
          FeatureModel(id: 'browse_catalogue', name: 'Browse Catalogue'),
          FeatureModel(id: 'member_offers', name: 'Member Offers'),
        ],
      ),
      const MembershipModel(
        id: 'premium',
        name: 'Premium',
        features: [
          FeatureModel(id: 'browse_catalogue', name: 'Browse Catalogue'),
          FeatureModel(id: 'priority_support', name: 'Priority Support'),
        ],
      ),
    ];

    Future<void> pumpTestApp(
      WidgetTester tester, {
      AuthProvider? overrideAuth,
      MembershipProvider? overrideMembership,
    }) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      SharedPreferences.setMockInitialValues({});
      storageService = await StorageService.getInstance();

      final authProvider =
          overrideAuth ?? (AuthProvider(storageService)..initialize(testUsers));
      final membershipProvider =
          overrideMembership ??
          (MembershipProvider()..initialize(testMemberships));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: authProvider),
            ChangeNotifierProvider.value(value: membershipProvider),
          ],
          child: const app.MyApp(),
        ),
      );
      await tester.pumpAndSettle();
    }

    final homeTabNav = find.byWidgetPredicate(
      (w) => w is HugeIcon && w.icon == HugeIcons.strokeRoundedHome04,
    );
    final membershipTabNav = find.byWidgetPredicate(
      (w) => w is HugeIcon && w.icon == HugeIcons.strokeRoundedUserCheck01,
    );
    final upgradeTabNav = find.byWidgetPredicate(
      (w) => w is HugeIcon && w.icon == HugeIcons.strokeRoundedSquareArrowUp01,
    );

    testWidgets(
      '1. Sign in with test profiles across Starter, Plus, Premium and verify features...',
      (WidgetTester tester) async {
        await pumpTestApp(tester);

        //Sign in as Starter
        await tester.enterText(
          find.byType(TextFormField).first,
          'naledi.mokoena@example.com',
        );
        await tester.tap(find.byType(Buttons));
        await tester.pumpAndSettle();

        expect(find.text('Welcome, Naledi Mokoena!'), findsOneWidget);
        expect(find.text('Starter Guides'), findsOneWidget);

        //Switch to Membership tab and Sign out
        await tester.tap(membershipTabNav);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Sign Out'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Yes'));
        await tester.pumpAndSettle();

        //Signin as Plus
        await tester.enterText(
          find.byType(TextFormField).first,
          'thabo.dlamini@example.com',
        );
        await tester.tap(find.byType(Buttons));
        await tester.pumpAndSettle();

        expect(find.text('Welcome, Thabo Dlamini!'), findsOneWidget);
        expect(find.text('Member Offers'), findsOneWidget);

        //Switch to Membership tab and Sign out
        await tester.tap(membershipTabNav);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Sign Out'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Yes'));
        await tester.pumpAndSettle();

        //sign in as Premium
        await tester.enterText(
          find.byType(TextFormField).first,
          'aisha.jacobs@example.com',
        );
        await tester.tap(find.byType(Buttons));
        await tester.pumpAndSettle();

        expect(find.text('Welcome, Aisha Jacobs!'), findsOneWidget);
        expect(find.text('Priority Support'), findsOneWidget);
      },
    );

    testWidgets('2. Sign up new user with duplicate email prevention...', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(tester);

      //Navigate to Sign Up screen
      await tester.tap(find.text("Don't have an account? Sign Up"));
      await tester.pumpAndSettle();

      //fill form with duplicate email
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Duplicate Person',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'naledi.mokoena@example.com',
      );
      await tester.tap(find.byType(Buttons));
      await tester.pumpAndSettle();

      //Verify duplicate error
      expect(
        find.text('An account with this email address already exists.'),
        findsOneWidget,
      );

      //hange email to unique address and submit
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'new.user@example.com',
      );
      await tester.tap(find.byType(Buttons));
      await tester.pumpAndSettle();

      //verify new user is signed in
      expect(find.text('Welcome, Duplicate Person!'), findsOneWidget);
    });

    testWidgets(
      '3. Upgrade membership and verify immediate updates across all 3 tabs...',
      (WidgetTester tester) async {
        await pumpTestApp(tester);

        //sign in as Starter
        await tester.enterText(
          find.byType(TextFormField).first,
          'lerato.nkosi@example.com',
        );
        await tester.tap(find.byType(Buttons));
        await tester.pumpAndSettle();

        //tab 0 (Home): Verify Starter Guides
        expect(find.text('Starter Guides'), findsOneWidget);

        //switch to Tab 2
        await tester.tap(upgradeTabNav);
        await tester.pumpAndSettle();

        //Tap Upgrade to Plus
        await tester.tap(find.text('Upgrade to Plus'));
        await tester.pumpAndSettle();

        //Confirm in dialog
        await tester.tap(find.text('Upgrade'));
        await tester.pumpAndSettle();

        //Switch to Tab 0-> verify Plus feature "Member Offers"
        await tester.tap(homeTabNav);
        await tester.pumpAndSettle();
        expect(find.text('Member Offers'), findsOneWidget);

        //switch to Tab 1-> verify Plus tier name
        await tester.tap(membershipTabNav);
        await tester.pumpAndSettle();
        expect(find.text('Plus'), findsWidgets);
      },
    );

    testWidgets(
      '4. Profile deletion prevents deleted user from signing back in...',
      (WidgetTester tester) async {
        await pumpTestApp(tester);

        //signin as Sipho Khumalo
        await tester.enterText(
          find.byType(TextFormField).first,
          'sipho.khumalo@example.com',
        );
        await tester.tap(find.byType(Buttons));
        await tester.pumpAndSettle();

        //Go to Membership tab & delete profile
        await tester.tap(membershipTabNav);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Delete Profile'));
        await tester.pumpAndSettle();

        //Confirm deletion in dialog
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        //returned to Sign In screen
        expect(find.text('Sign In to continue'), findsOneWidget);

        //signing in as deleted user
        await tester.enterText(
          find.byType(TextFormField).first,
          'sipho.khumalo@example.com',
        );
        await tester.tap(find.byType(Buttons));
        await tester.pumpAndSettle();

        expect(
          find.text('No profile found with this email address.'),
          findsOneWidget,
        );

        //other use can still sign in
        await tester.enterText(
          find.byType(TextFormField).first,
          'thabo.dlamini@example.com',
        );
        await tester.tap(find.byType(Buttons));
        await tester.pumpAndSettle();

        expect(find.text('Welcome, Thabo Dlamini!'), findsOneWidget);
      },
    );
  });
}
