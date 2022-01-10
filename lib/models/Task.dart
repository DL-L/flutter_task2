// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

List<Task> taskFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String taskToJson(List<Task> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.deadline,
    required this.comments,
    required this.relation,
    this.createdAt,
    required this.updatedAt,
  });

  String id;
  String title;
  String description;
  Status status;
  DateTime? deadline;
  List<Comment> comments;
  Relation relation;
  dynamic? createdAt;
  DateTime? updatedAt;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        status: Status.fromJson(json["status"]),
        deadline:
            json["deadline"] == null ? null : DateTime.parse(json["deadline"]),
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
        relation: Relation.fromJson(json["relation"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "status": status.toJson(),
        "deadline": deadline == null
            ? null
            : "${deadline!.year.toString().padLeft(4, '0')}-${deadline!.month.toString().padLeft(2, '0')}-${deadline!.day.toString().padLeft(2, '0')}",
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
        "relation": relation.toJson(),
        "created_at": createdAt,
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}

class Comment {
  Comment({
    required this.id,
    required this.userId,
    required this.seen,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int userId;
  bool seen;
  String body;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        userId: json["user_id"],
        seen: json["seen"],
        body: json["body"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "seen": seen,
        "body": body,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}

class Relation {
  Relation({
    required this.id,
    required this.adminId,
    required this.subId,
    this.deletedAt,
  });

  int id;
  int adminId;
  int subId;
  dynamic? deletedAt;

  factory Relation.fromJson(Map<String, dynamic> json) => Relation(
        id: json["id"],
        adminId: json["admin_id"],
        subId: json["sub_id"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "admin_id": adminId,
        "sub_id": subId,
        "deleted_at": deletedAt,
      };
}

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
