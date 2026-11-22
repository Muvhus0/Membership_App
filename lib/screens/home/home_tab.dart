import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/feature_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/membership_provider.dart';
import '../../widgets/feature_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  void _showFeatureDetails(BuildContext context, FeatureModel feature) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(feature.name),
          content: Text(
            'Feature ID: ${feature.id}\n\nThis feature is included in your current membership tier.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final membershipProvider = context.watch<MembershipProvider>();

    final user = authProvider.currentUser;
    if (user == null) return const SizedBox.shrink();

    final membership = membershipProvider.getMembershipById(user.membershipId);
    final features = membershipProvider.getFeaturesForMembership(
      user.membershipId,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Welcome, ${user.name}!',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Current Membership: ${membership?.name ?? user.membershipId}',
          style: GoogleFonts.inter(fontWeight: FontWeight.normal, fontSize: 14),
        ),
        const SizedBox(height: 16),
        Text(
          'Membership Features',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        if (features.isEmpty)
          const Text('No features available.')
        else
          ...features.map(
            (feature) => FeatureCard(
              feature: feature,
              onTap: () => _showFeatureDetails(context, feature),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
