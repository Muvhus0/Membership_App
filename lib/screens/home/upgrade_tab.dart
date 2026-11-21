import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/membership_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/membership_provider.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/membership_card.dart';

class UpgradeTab extends StatelessWidget {
  const UpgradeTab({super.key});

  Future<void> _handleUpgrade(
    BuildContext context,
    MembershipModel newTier,
  ) async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) return;

    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Confirm Upgrade',
      message:
          'Are you sure you want to upgrade your membership to ${newTier.name}?',
      confirmLabel: 'Upgrade',
      cancelLabel: 'Cancel',
    );

    if (confirmed == true && context.mounted) {
      await authProvider.updateUserMembership(user.id, newTier.id);

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upgraded to ${newTier.name}!')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final membershipProvider = context.watch<MembershipProvider>();

    final user = authProvider.currentUser;
    if (user == null) return const SizedBox.shrink();

    final isHighest = membershipProvider.isHighestTier(user.membershipId);
    final eligibleUpgrades = membershipProvider.getEligibleUpgrades(
      user.membershipId,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Upgrade Membership',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (isHighest)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'You are currently on the highest membership tier (Premium).',
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        else ...[
          const Text('Select a tier to upgrade:'),
          const SizedBox(height: 8),
          ...eligibleUpgrades.map(
            (tier) => MembershipCard(
              membership: tier,
              isCurrent: false,
              actionLabel: 'Upgrade to ${tier.name}',
              onAction: () => _handleUpgrade(context, tier),
            ),
          ),
        ],
      ],
    );
  }
}
