import 'dart:ui';

import 'package:timeless/model/repetitive_type.dart';
import 'package:timeless/model/task_type.dart';

import '../styles/styles.dart';

class Task{
  int? id;
  String name;
  TaskType type;
  RepetitiveType? repetitiveType;
  DateTime time;
  Color color;

  DateTime getDateTime() {
    return this.time;
  }

  Task.repetitive(this.name, this.repetitiveType, this.time) : type = TaskType.Repetitive, color =  MyColors.repetitiveBlue;

  Task.dueTo(this.name, this.time) : type = TaskType.DueTo, color = MyColors.dueToRed;

  Task.appointment(this.name, this.time) : type = TaskType.Appointment, color = MyColors.appointmentGreen;

}