import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:timeless/model/goal_type.dart';

import '../styles/styles.dart';

class Goal{
  String? id;
  String name;
  GoalType type;

  Goal.public(this.name, this.id) : type = GoalType.Public;

  Goal.private(this.name, this.id) : type = GoalType.Private;

  Goal({this.id, required this.name, required this.type});

  Color get color{
    if (type == GoalType.Private)
      return MyColors().privatePurple;
    return MyColors().publicYellow;
  }

  static Goal fromJson(Map<String, dynamic> json) => Goal(
    id: json['id'],
    name: json['name'],
    type: EnumToString.fromString(GoalType.values, json['goal_type'])!,
  );

  static Goal fromJson2(DocumentSnapshot json) => Goal(
    id: json['id'],
    name: json['name'],
    type: EnumToString.fromString(GoalType.values, json['goal_type'])!,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'goal_type': EnumToString.convertToString(type),
  };


}