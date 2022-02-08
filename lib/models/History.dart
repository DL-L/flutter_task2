// To parse this JSON data, do
//
//     final history = historyFromJson(jsonString);

import 'dart:convert';

List<History> historyFromJson(String str) =>
    List<History>.from(json.decode(str).map((x) => History.fromJson(x)));

String historyToJson(List<History> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class History {
  History({
    required this.idTask,
    required this.titleTask,
    required this.descriptionTask,
    required this.statusIdTask,
    this.deadlineTask,
    required this.createdAt,
  });

  String idTask;
  String titleTask;
  String descriptionTask;
  int statusIdTask;
  DateTime? deadlineTask;
  DateTime createdAt;

  factory History.fromJson(Map<String, dynamic> json) => History(
        idTask: json["id_task"],
        titleTask: json["title_task"],
        descriptionTask: json["description_task"],
        statusIdTask: json["status_id_task"],
        deadlineTask: json["deadline_task"] == null
            ? null
            : DateTime.parse(json["deadline_task"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_task": idTask,
        "title_task": titleTask,
        "description_task": descriptionTask,
        "status_id_task": statusIdTask,
        "deadline_task": deadlineTask == null
            ? null
            : "${deadlineTask!.year.toString().padLeft(4, '0')}-${deadlineTask!.month.toString().padLeft(2, '0')}-${deadlineTask!.day.toString().padLeft(2, '0')}",
        "created_at": createdAt.toIso8601String(),
      };
}
