// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    required this.id,
    this.firstName,
    this.lastName,
    required this.email,
    this.adresse,
    this.emailVerifiedAt,
    required this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.pivot,
  });

  int id;
  dynamic firstName;
  dynamic lastName;
  String email;
  dynamic adresse;
  dynamic emailVerifiedAt;
  String phoneNumber;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  Pivot pivot;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        adresse: json["adresse"],
        emailVerifiedAt: json["email_verified_at"],
        phoneNumber: json["phone_number"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "adresse": adresse,
        "email_verified_at": emailVerifiedAt,
        "phone_number": phoneNumber,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
        "pivot": pivot.toJson(),
      };
}

class Pivot {
  Pivot({
    required this.subId,
    required this.adminId,
  });

  int subId;
  int adminId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        subId: json["sub_id"],
        adminId: json["admin_id"],
      );

  Map<String, dynamic> toJson() => {
        "sub_id": subId,
        "admin_id": adminId,
      };
}
