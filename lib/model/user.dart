import 'dart:ui';

import 'package:timeless/model/repetitive_type.dart';
import 'package:timeless/model/task_type.dart';

import '../styles/styles.dart';

class User{
  String uid;
  String name;
  TaskType type;
  RepetitiveType? repetitiveType;
  DateTime time;
  Color color;

  DateTime getDateTime() {
    return this.time;
  }

  User.repetitive(this.name, this.repetitiveType, this.time, this.uid) : type = TaskType.Repetitive, color =  MyColors().repetitiveBlue;

  User.dueTo(this.name, this.time, this.uid) : type = TaskType.DueTo, color = MyColors().dueToRed;

  User.appointment(this.name, this.time, this.uid) : type = TaskType.Appointment, color = MyColors().appointmentGreen;

}