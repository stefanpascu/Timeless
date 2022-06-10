import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:timeless/model/repetitive_type.dart';
import 'package:timeless/model/task_type.dart';
import 'package:enum_to_string/enum_to_string.dart';

import '../model/task.dart';
import '../styles/styles.dart';
import 'add_new_task_page.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({Key? key}) : super(key: key);

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  int selectedDailyIndex = 0;

  static List<Task> tasks = [
    Task.repetitive("hello1", RepetitiveType.Daily,
        DateTime.now().add(Duration(minutes: 10)), 1),
    Task.repetitive("Nameless Task", RepetitiveType.Daily,
        DateTime.now().add(Duration(minutes: 10)), 2),
    Task.repetitive("hello4", RepetitiveType.Daily,
        DateTime.now().add(Duration(minutes: 20)), 3),
    Task.appointment("hello6", DateTime.now().add(Duration(minutes: 10)), 4),
    Task.repetitive("hello2", RepetitiveType.Daily,
        DateTime.now().add(Duration(minutes: 30, days: 1)), 5),
    Task.repetitive("hello3", RepetitiveType.Daily,
        DateTime.now().add(Duration(minutes: 5, days: 3)), 6),
    Task.dueTo("hello5", DateTime.now().add(Duration(minutes: 10, days: 3)), 7),
  ];
  List<Task> filteredTasks = tasks;
  String repetitiveDropdownValue = 'Daily';

  String? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: 60.0,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _filterWidget(title: 'All', index: 0, hasCircle: false),
                _filterWidget(
                    title: 'Repetitive',
                    index: 1,
                    color: MyColors().repetitiveBlue),
                _filterWidget(
                    title: 'Due to', index: 2, color: MyColors().dueToRed),
                _filterWidget(
                    title: 'Appointment',
                    index: 3,
                    color: MyColors().appointmentGreen),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Expanded(
            child: GroupedListView<Task, String>(
              elements: sortTaskList(filteredTasks),
              groupBy: (element) => _buildGroupByString(element),
              groupSeparatorBuilder: (String groupByValue) => Padding(
                padding: EdgeInsets.only(top: 30.0, bottom: 5.0),
                child: Text(
                  groupByValue,
                  style: TextStyle(
                      color: MyColors().textNormal,
                      fontSize: 15.0,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w500),
                ),
              ),
              itemBuilder: (context, Task task) => _taskWidget(task),
              shrinkWrap: true,
            ),
          ),
        ),
      ]),
    );
  }

  String to24hours(TimeOfDay? tod) {
    final time = tod.toString().padLeft(2, "0");
    return "$time";
  }

  List<Task> sortTaskList(List<Task> filteredTasks) {
    List<Task> filteredTasksAux = filteredTasks;
    filteredTasksAux.sort((a, b) => a.getDateTime().compareTo(b.getDateTime()));
    ;
    return filteredTasksAux;
  }

  String _buildGroupByString(Task element) {
    DateTime now = DateTime.now();
    int diff = DateTime(element.time.year, element.time.month, element.time.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (diff == 0)
      return '${DateFormat('yyyy-MM-dd').format(element.time)} (Today)';
    else if (diff == 1)
      return '${DateFormat('yyyy-MM-dd').format(element.time)} (Tomorrow)';
    return '${DateFormat('yyyy-MM-dd').format(element.time)}';
  }

  Widget _taskWidget(Task task) {
    return GestureDetector(
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewTaskPage(id: 1)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: MyColors().lightGray, width: 0.2),
              color: MyColors().overBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 1.0,
                  spreadRadius: 0.2,
                  offset: Offset(1.0, 1.0),
                )
              ]),
          child: Container(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: task.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 20.0),
                    child: Container(
                      alignment: FractionalOffset(0.0, 0.0),
                      child: Column(
                        children: [
                          Text(
                            task.name,
                            style: TextStyle(
                                fontSize: 20.0,
                                color: MyColors().textNormal,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            EnumToString.convertToString(task.type),
                            style: TextStyle(
                                fontSize: 13.0,
                                color: MyColors().textNormal,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    DateFormat('kk:mm').format(task.time),
                    style: TextStyle(
                        color: MyColors().textNormal,
                        fontSize: 15.0,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(minWidth: 35),
          height: 35,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            border: Border.all(color: MyColors().lightGray, width: 0.2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 1.0,
                spreadRadius: 0.2,
                offset: Offset(1.0, 1.0), // changes position of shadow
              ),
            ],
            color: isSelected ? MyColors().primaryNormal : MyColors().overBackground,
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
                  color:
                      isSelected ? MyColors().highlightedFilterText : MyColors().textNormal,
                  fontSize: 13.0,
                  fontFamily: 'OpenSans',
                ),
              ),
            ],
          ),
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
