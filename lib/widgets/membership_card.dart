import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../models/membership_model.dart';

class MembershipCard extends StatelessWidget {
  final MembershipModel membership;
  final bool isCurrent;
  final VoidCallback? onAction;
  final String? actionLabel;

  const MembershipCard({
    super.key,
    required this.membership,
    this.isCurrent = false,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: membershipColor(membership.id),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  membership.name,

                  style: GoogleFonts.marcellus(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    letterSpacing: 1.2,
                  ),
                ),
                if (isCurrent)
                  Chip(
                    backgroundColor: Colors.white,
                    label: Text(
                      'Current Plan',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
              ],
            ),
            const Divider(color: Colors.black),
            Text(
              'Included Features:',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            ...membership.features.map(
              (f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    HugeIcon(icon: HugeIcons.strokeRoundedTick01, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      f.name,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                    elevation: const WidgetStatePropertyAll(0),
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  onPressed: onAction,
                  child: Text(
                    actionLabel!,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      letterSpacing: 0.25,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color membershipColor(String membership) => switch (membership) {
    'premium' => Colors.orangeAccent,
    'plus' => Colors.lightBlueAccent,
    'starter' => Colors.lightGreen,
    _ => Colors.white,
  };
}
