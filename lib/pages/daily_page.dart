import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:timeless/model/repetitive_type.dart';
import 'package:timeless/model/task_type.dart';

import '../model/task.dart';
import '../styles/styles.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({Key? key}) : super(key: key);

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  int selectedDailyIndex = 0;

  static List<Task> tasks = [
    Task.repetitive("hello1", RepetitiveType.Daily,
        DateTime.now().add(Duration(minutes: 10))),
    Task.repetitive("hello4", RepetitiveType.Daily,
        DateTime.now().add(Duration(minutes: 10))),
    Task.appointment("hello6", DateTime.now().add(Duration(minutes: 10))),
    Task.repetitive("hello2", RepetitiveType.Daily,
        DateTime.now().add(Duration(minutes: 10, days: 1))),
    Task.repetitive("hello3", RepetitiveType.Daily,
        DateTime.now().add(Duration(minutes: 10, days: 3))),
    Task.dueTo("hello5", DateTime.now().add(Duration(minutes: 10, days: 3))),
  ];
  List<Task> filteredTasks = tasks;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: <Widget>[
          _filterWidget(title: 'All', index: 0, hasCircle: false),
          SizedBox(width: 10),
          _filterWidget(
              title: 'Repetitive', index: 1, color:  MyColors.repetitiveBlue),
          SizedBox(width: 10),
          _filterWidget(title: 'Due to', index: 2, color:  MyColors.dueToRed),
          SizedBox(width: 10),
          _filterWidget(
              title: 'Appointment', index: 3, color:  MyColors.appointmentGreen),
        ],
      ),
      Expanded(
        child: GroupedListView<Task, String>(
          elements: filteredTasks,
          groupBy: (element) => _buildGroupByString(element),
          groupSeparatorBuilder: (String groupByValue) => Text(groupByValue),
          itemBuilder: (context, Task task) => _taskWidget(task),
          shrinkWrap: true,
        ),
      ),
    ]);
  }

  String _buildGroupByString(Task element) {
    DateTime now = DateTime.now();
    int diff = DateTime(element.time.year, element.time.month, element.time.day).difference(DateTime(now.year, now.month, now.day)).inDays;
    if(diff == 0)
      return '${DateFormat('yyyy-MM-dd').format(element.time)} (Today)';
    else if(diff == 1)
      return '${DateFormat('yyyy-MM-dd').format(element.time)} (Tomorrow)';
    return '${DateFormat('yyyy-MM-dd').format(element.time)}';
  }

  Widget _taskWidget(Task task) {
    return Card(
        child: Row(
      children: [
        Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
            color: task.color,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Column(
            children: [Text(task.name), Text(task.type.toString())],
          ),
        ),
        Text(DateFormat('yyyy-MM-dd – kk:mm').format(task.time))
      ],
    ));
  }

  Widget _filterWidget(
      {required String title,
      required int index,
      bool hasCircle = true,
      Color? color}) {
    bool isSelected = index == selectedDailyIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDailyIndex = index;
          _filterTasks();
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
          color: isSelected ? MyColors.primaryNormal :  MyColors.taintedWhite,
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
                color: isSelected ?  MyColors.taintedWhite :  MyColors.textNormal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _filterTasks() {
    if (selectedDailyIndex == 0) {
      filteredTasks = tasks;
    } else if (selectedDailyIndex == 1) {
      filteredTasks =
          tasks.where((task) => task.type == TaskType.Repetitive).toList();
    } else if (selectedDailyIndex == 2) {
      filteredTasks =
          tasks.where((task) => task.type == TaskType.DueTo).toList();
    } else if (selectedDailyIndex == 3) {
      filteredTasks =
          tasks.where((task) => task.type == TaskType.Appointment).toList();
    }
  }

}
