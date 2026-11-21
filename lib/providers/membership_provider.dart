import 'package:flutter/foundation.dart';

import '../models/feature_model.dart';
import '../models/membership_model.dart';

class MembershipProvider with ChangeNotifier {
  List<MembershipModel> _memberships = [];
  bool _isLoading = true;

  List<MembershipModel> get memberships => List.unmodifiable(_memberships);
  bool get isLoading => _isLoading;

  void initialize(List<MembershipModel> memberships) {
    _memberships = List.from(memberships);
    _isLoading = false;
    notifyListeners();
  }

  MembershipModel? getMembershipById(String id) {
    try {
      return _memberships.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  List<FeatureModel> getFeaturesForMembership(String membershipId) {
    final membership = getMembershipById(membershipId);
    return membership?.features ?? [];
  }

  List<MembershipModel> getEligibleUpgrades(String currentMembershipId) {
    final currentMembership = getMembershipById(currentMembershipId);
    final currentRank = currentMembership?.rank ?? 0;

    final eligible = _memberships.where((m) => m.rank > currentRank).toList();

    eligible.sort((a, b) => a.rank.compareTo(b.rank));
    return eligible;
  }

  bool isHighestTier(String currentMembershipId) {
    return getEligibleUpgrades(currentMembershipId).isEmpty;
  }
}
