import 'dart:typed_data';

import 'package:hive/hive.dart';

class User extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  String email;
  @HiveField(2)
  String firstName;
  @HiveField(3)
  final String lastName;
  @HiveField(4)
  final String role;
  @HiveField(5)
  bool enabled;

  User(
      {required this.email,
      required this.firstName,
      required this.id,
      required this.enabled,
      required this.lastName,
      required this.role});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      email: json["email"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      role: json["role"],
      enabled: json["enabled"]);
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 7;

  @override
  User read(BinaryReader reader) {
    return User(
        id: reader.read(),
        email: reader.read(),
        firstName: reader.read(),
        lastName: reader.read(),
        role: reader.read(),
        enabled: reader.read());
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.write(obj.id);
    writer.write(obj.email);
    writer.write(obj.firstName);
    writer.write(obj.lastName);
    writer.write(obj.role);
    writer.write(obj.enabled);
  }
}
