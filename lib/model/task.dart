import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:timeless/model/repetitive_type.dart';
import 'package:timeless/model/task_type.dart';

import '../styles/styles.dart';

class Task {
  String? id;
  String name;
  TaskType type;
  RepetitiveType? repetitiveType;
  DateTime time;
  int notificationId;

  DateTime getDateTime() {
    return this.time;
  }

  Task.repetitive(
      this.name, this.repetitiveType, this.time, this.id, this.notificationId)
      : type = TaskType.Repetitive;

  Task.dueTo(this.name, this.time, this.id, this.notificationId)
      : type = TaskType.DueTo;

  Task.appointment(this.name, this.time, this.id, this.notificationId)
      : type = TaskType.Appointment;

  Task(
      {this.id,
      required this.name,
      required this.type,
      this.repetitiveType,
      required this.time,
      required this.notificationId});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'task_type': EnumToString.convertToString(type),
        'repetitive_type': repetitiveType == null
            ? null
            : EnumToString.convertToString(repetitiveType),
        'notification_id': notificationId,
        'time': time,
      };

  Color get color {
    if (type == TaskType.Repetitive)
      return MyColors().repetitiveBlue;
    else if (type == TaskType.DueTo) return MyColors().dueToRed;
    return MyColors().appointmentGreen;
  }

  static Task fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        name: json['name'],
        type: EnumToString.fromString(TaskType.values, json['task_type'])!,
        repetitiveType: EnumToString.fromString(
            RepetitiveType.values, json['repetitive_type']),
        notificationId: json['notification_id'],
        time: json['time'].toDate(),
      );

  static Task fromJson2(DocumentSnapshot json) => Task(
        id: json['id'],
        name: json['name'],
        type: EnumToString.fromString(TaskType.values, json['task_type'])!,
        repetitiveType: json['repetitive_type'] == null
            ? null
            : EnumToString.fromString(
                RepetitiveType.values, json['repetitive_type']),
        notificationId: json['notification_id'],
        time: json['time'].toDate(),
      );

  @override
  String toString() {
    return 'Task{id: $id, name: $name, type: $type, repetitiveType: $repetitiveType, time: $time, notification_id: $notificationId}';
  }
}
