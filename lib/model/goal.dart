import 'dart:ui';

import 'package:timeless/model/goal_type.dart';

import '../styles/styles.dart';

class Goal{
  String name;
  GoalType type;
  Color color;

  Goal.public(this.name) : type = GoalType.Public, color =  MyColors.publicYellow;

  Goal.private(this.name) : type = GoalType.Private, color =  MyColors.privatePurple;

}