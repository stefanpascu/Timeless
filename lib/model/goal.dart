import 'dart:ui';

import 'package:timeless/model/goal_type.dart';

import '../styles/styles.dart';

class Goal{
  int? id;
  String name;
  GoalType type;
  Color color;

  Goal.public(this.name, this.id) : type = GoalType.Public, color =  MyColors.publicYellow;

  Goal.private(this.name, this.id) : type = GoalType.Private, color =  MyColors.privatePurple;

}