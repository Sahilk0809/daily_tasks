class UserModal {
  late String name, email, profile;

  UserModal({
    required this.name,
    required this.email,
    required this.profile,
  });

  factory UserModal.fromMap(Map m1) {
    return UserModal(
      name: m1['name'],
      email: m1['email'],
      profile: m1['profile'],
    );
  }
}

Map<String, dynamic> toMap(UserModal user) {
  return {
    'name': user.name,
    'email': user.email,
    'profile': user.profile,
  };
}
