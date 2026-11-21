import 'package:flutter_test/flutter_test.dart';
import 'package:membership_app/models/feature_model.dart';
import 'package:membership_app/models/membership_model.dart';
import 'package:membership_app/providers/membership_provider.dart';

void main() {
  late MembershipProvider membershipProvider;

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

  setUp(() {
    membershipProvider = MembershipProvider();
    membershipProvider.initialize(testMemberships);
  });

  test('getMembershipById returns correct tier', () {
    final starter = membershipProvider.getMembershipById('starter');
    expect(starter?.name, equals('Starter'));

    final nonExistent = membershipProvider.getMembershipById('unknown');
    expect(nonExistent, isNull);
  });

  test('getEligibleUpgrades returns correct higher tiers', () {
    final starterUpgrades = membershipProvider.getEligibleUpgrades('starter');
    expect(starterUpgrades.length, equals(2));
    expect(starterUpgrades.map((m) => m.id), containsAll(['plus', 'premium']));

    final plusUpgrades = membershipProvider.getEligibleUpgrades('plus');
    expect(plusUpgrades.length, equals(1));
    expect(plusUpgrades.first.id, equals('premium'));

    final premiumUpgrades = membershipProvider.getEligibleUpgrades('premium');
    expect(premiumUpgrades, isEmpty);
  });

  test('isHighestTier identifies premium as highest tier', () {
    expect(membershipProvider.isHighestTier('starter'), isFalse);
    expect(membershipProvider.isHighestTier('plus'), isFalse);
    expect(membershipProvider.isHighestTier('premium'), isTrue);
  });
}
