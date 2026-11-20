import 'feature_model.dart';
import '../utils/app_constants.dart';

class MembershipModel {
  final String id;
  final String name;
  final List<FeatureModel> features;

  const MembershipModel({
    required this.id,
    required this.name,
    required this.features,
  });

  factory MembershipModel.fromJson(Map<String, dynamic> json) {
    final rawFeatures = json['features'] as List<dynamic>? ?? [];
    return MembershipModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      features: rawFeatures
          .map((f) => FeatureModel.fromJson(f as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'features': features.map((f) => f.toJson()).toList(),
    };
  }

  int get rank => AppConstants.tierRank[id] ?? 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MembershipModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
