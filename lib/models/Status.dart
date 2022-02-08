// To parse this JSON data, do
//
//     final status = statusFromJson(jsonString);

import 'dart:convert';

List<Status> statusFromJson(String str) =>
    List<Status>.from(json.decode(str).map((x) => Status.fromJson(x)));

String statusToJson(List<Status> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Status {
  Status({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
