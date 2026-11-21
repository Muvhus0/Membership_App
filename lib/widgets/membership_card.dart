import 'package:flutter/material.dart';

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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isCurrent) const Chip(label: Text('Current Plan')),
              ],
            ),
            const Divider(),
            const Text(
              'Included Features:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...membership.features.map(
              (f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    const Icon(Icons.check, size: 16),
                    const SizedBox(width: 8),
                    Text(f.name),
                  ],
                ),
              ),
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
