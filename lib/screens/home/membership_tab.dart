import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  Future<void> _hangleSignOut(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) return;

    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Sign Out',
      message: 'Are you sure you want to Sign out?',
      confirmLabel: 'Yes',
      cancelLabel: 'Cancel',
    );

    if (confirmed == true && context.mounted) {
      await authProvider.signOut();
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
        Text(
          'Your Membership',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        if (membership != null)
          MembershipCard(membership: membership, isCurrent: true),
        const SizedBox(height: 16),
        Card(
          elevation: 3,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Info',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                profileText('Name: ${user.name}'),
                profileText('Email: ${user.email}'),
                profileText('User ID: ${user.id}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            elevation: const WidgetStatePropertyAll(0),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          onPressed: () => _hangleSignOut(context),
          child: Text(
            'Sign Out',
            style: GoogleFonts.inter(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 15,
              letterSpacing: 0.25,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _confirmDeleteProfile(context),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            elevation: const WidgetStatePropertyAll(0),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          child: Text(
            'Delete Profile',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.normal,
              fontSize: 15,
              letterSpacing: 0.25,
            ),
          ),
        ),
      ],
    );
  }

  Widget profileText(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(fontWeight: FontWeight.normal, fontSize: 14),
    );
  }
}
