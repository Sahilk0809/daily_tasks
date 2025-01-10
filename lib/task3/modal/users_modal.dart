class UsersModal {
  int id;
  String email;
  String password;
  String name;
  Role role;
  String avatar;
  DateTime creationAt;
  DateTime updatedAt;

  UsersModal({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    required this.avatar,
    required this.creationAt,
    required this.updatedAt,
  });

  factory UsersModal.fromJson(Map<String, dynamic> json) => UsersModal(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        name: json["name"],
        role: roleValues.map[json["role"]]!,
        avatar: json["avatar"],
        creationAt: DateTime.parse(json["creationAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "name": name,
        "role": roleValues.reverse[role],
        "avatar": avatar,
        "creationAt": creationAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

enum Role { ADMIN, CUSTOMER }

final roleValues = EnumValues({"admin": Role.ADMIN, "customer": Role.CUSTOMER});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class DatabaseUsers {
  int id;
  String email;
  String name;
  String role;
  String avatar;
  String creationAt;
  String updatedAt;

  DatabaseUsers({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.avatar,
    required this.creationAt,
    required this.updatedAt,
  });

  factory DatabaseUsers.fromMap(Map m1) {
    return DatabaseUsers(
      id: m1['id'],
      email: m1['email'],
      name: m1['name'],
      role: m1['role'],
      avatar: m1['avatar'],
      creationAt: m1['creationAt'],
      updatedAt: m1['updatedAt'],
    );
  }
}

Map<String, dynamic> toMap(DatabaseUsers m1) {
  return {
    'id': m1.id,
    'email': m1.email,
    'name': m1.name,
    'role': m1.role,
    'avatar': m1.avatar,
    'creationAt': m1.creationAt,
    'updatedAt': m1.updatedAt,
  };
}
