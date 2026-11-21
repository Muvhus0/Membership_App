import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/membership_provider.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/membership_card.dart';

class MembershipTab extends StatelessWidget {
  const MembershipTab({super.key});

  Future<void> _confirmDeleteProfile(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.currentUser;
    if (currentUser == null) return;

    final confirm = await ConfirmationDialog.show(
      context,
      title: 'Delete Profile',
      message:
          'Are you sure you want to delete your profile (${currentUser.email})?',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      isDestructive: true,
    );

    if (confirm == true && context.mounted) {
      await authProvider.deleteCurrentProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final membershipProvider = context.watch<MembershipProvider>();

    final user = authProvider.currentUser;
    if (user == null) return const SizedBox.shrink();

    final membership = membershipProvider.getMembershipById(user.membershipId);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Your Membership',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (membership != null)
          MembershipCard(membership: membership, isCurrent: true),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile Info',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Name: ${user.name}'),
                Text('Email: ${user.email}'),
                Text('User ID: ${user.id}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () => authProvider.signOut(),
          child: const Text('Sign Out'),
        ),
        ElevatedButton(
          onPressed: () => _confirmDeleteProfile(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Delete Profile'),
        ),
      ],
    );
  }
}
