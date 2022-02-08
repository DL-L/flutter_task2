// To parse this JSON data, do
//
//     final invitation = invitationFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_task2/models/Users.dart';

List<Invitation> invitationFromJson(String str) =>
    List<Invitation>.from(json.decode(str).map((x) => Invitation.fromJson(x)));

String invitationToJson(List<Invitation> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Invitation {
  Invitation({
    required this.id,
    required this.from,
    required this.to,
    required this.validated,
    required this.createdAt,
    required this.updatedAt,
    required this.receiver,
    required this.transmitter,
  });

  int id;
  int from;
  int to;
  bool validated;
  DateTime? createdAt;
  DateTime? updatedAt;
  User receiver;
  User transmitter;

  factory Invitation.fromJson(Map<String, dynamic> json) => Invitation(
        id: json["id"],
        from: json["from"],
        to: json["to"],
        validated: json["validated"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        receiver: User.fromJson(json["receiver"]),
        transmitter: User.fromJson(json["transmitter"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "from": from,
        "to": to,
        "validated": validated,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}
