import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/grouped_list.dart';

import '../model/goal.dart';
import '../model/goal_type.dart';
import '../styles/styles.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  int selectedGoalsIndex = 0;

  static List<Goal> goals = [
    Goal.public("hello1"),
    Goal.private("hello2"),
    Goal.public("hello3"),
    Goal.public("hello4"),
    Goal.private("hello5"),
  ];
  List<Goal> filteredGoals = goals;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: <Widget>[
          _filterWidget(title: 'All', index: 0, hasCircle: false),
          SizedBox(width: 10),
          _filterWidget(
              title: 'Public', index: 1, color: MyColors.publicYellow),
          SizedBox(width: 10),
          _filterWidget(
              title: 'Private', index: 2, color: MyColors.privatePurple),
        ],
      ),
      Expanded(
        child: GroupedListView<Goal, String>(
          elements: filteredGoals,
          groupBy: (element) => _buildGroupByString(element),
          groupSeparatorBuilder: (String groupByValue) => Text(groupByValue),
          itemBuilder: (context, Goal goal) => _goalWidget(goal),
          shrinkWrap: true,
        ),
      ),
    ]);
  }

  String _buildGroupByString(Goal element) {
    if (element.type == GoalType.Public) return 'Public';
    return 'Private';
  }

  Widget _goalWidget(Goal goal) {
    return Card(
        child: Row(
      children: [
        Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
            color: goal.color,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Column(
            children: [Text(goal.name)],
          ),
        ),
      ],
    ));
  }

  Widget _filterWidget(
      {required String title,
      required int index,
      bool hasCircle = true,
      Color? color}) {
    bool isSelected = index == selectedGoalsIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGoalsIndex = index;
          _filterGoals();
        });
      },
      child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(minWidth: 50),
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(1),
              spreadRadius: 1,
              blurRadius: 1.0,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          color: isSelected ? MyColors.primaryNormal : MyColors.taintedWhite,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasCircle) ...[
              Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
            Text(
              title,
              style: TextStyle(
                color: isSelected ? MyColors.taintedWhite : MyColors.textNormal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _filterGoals() {
    if (selectedGoalsIndex == 0) {
      filteredGoals = goals;
    } else if (selectedGoalsIndex == 1) {
      filteredGoals =
          goals.where((goal) => goal.type == GoalType.Public).toList();
    } else if(selectedGoalsIndex == 2) {
      filteredGoals =
          goals.where((goal) => goal.type == GoalType.Private).toList();
    }
  }

}
