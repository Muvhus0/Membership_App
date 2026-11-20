class UserModel {
  final String id;
  final String name;
  final String email;
  final String membershipId;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.membershipId,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? membershipId,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      membershipId: membershipId ?? this.membershipId,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      membershipId: json['membershipId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'membershipId': membershipId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          membershipId == other.membershipId;

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ membershipId.hashCode;
}
