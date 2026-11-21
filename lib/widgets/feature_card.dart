import 'package:flutter/material.dart';

import '../models/feature_model.dart';

class FeatureCard extends StatelessWidget {
  final FeatureModel feature;
  final VoidCallback? onTap;

  const FeatureCard({super.key, required this.feature, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: ListTile(
        leading: const Icon(Icons.star),
        title: Text(feature.name),
        subtitle: Text('ID: ${feature.id}'),
        onTap: onTap,
      ),
    );
  }
}
