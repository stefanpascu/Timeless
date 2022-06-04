import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/repetitive_type.dart';
import '../model/task.dart';
import '../model/task_type.dart';
import '../styles/styles.dart';
import 'new_due_to_page.dart';
import 'new_repetitive_page.dart';

class NewTaskPage extends StatefulWidget {
  final int? id;

  NewTaskPage({Key? key, this.id}) : super(key: key);

  @override
  State<NewTaskPage> createState() => NewTaskPageState();
}

class NewTaskPageState extends State<NewTaskPage> {
  late bool editMode;
  late Task task;
  late bool isSwitched = false;
  late String formattedTime = 'Set Time';
  late TextEditingController _controller;
  int selectedDailyIndex = 0;
  String repetitiveDropdownValue = 'Daily';

  @override
  void initState() {
    editMode = widget.id != null;
    if(editMode) {
      task = findTaskById(widget.id);

      if (task.repetitiveType == null)
        isSwitched = false;
      else
        isSwitched = true;

      repetitiveDropdownValue = task.repetitiveType.toString().split('.')[1];
      String formattedTimeAux = '';
      for (int i = 0; i <= 4; i++) {
        formattedTimeAux += DateFormat.Hms().format(task.time)[i];
      }
      formattedTime = formattedTimeAux;
      _controller = TextEditingController(text: task.name);
    } else {
      task = Task.repetitive("hello1", RepetitiveType.Weekly,
          DateTime.now().add(Duration(minutes: 10)));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: MyColors.primaryDarkest,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: MyColors.taintedWhite.withOpacity(0),
        title: Text(
          editMode ? 'EDIT TASK' : 'NEW TASK',
          style: TextStyle(
            color: MyColors.primaryDarkest,
            fontSize: 25.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        elevation: 0,
      ),
      body: Column(children: [
        Container(
          height: 60.0,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                _filterWidget(
                    title: 'Repetitive',
                    index: 0,
                    color: MyColors.repetitiveBlue),
                SizedBox(width: 10),
                _filterWidget(
                    title: 'Due to', index: 1, color: MyColors.dueToRed),
                SizedBox(width: 10),
                _filterWidget(
                    title: 'Appointment',
                    index: 2,
                    color: MyColors.appointmentGreen),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
              child: selectedDailyIndex == 0
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          child: TextField(
                            controller: widget.id == null ? null : _controller,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        MyColors.primaryNormal.withOpacity(0.7),
                                    width: 1.5),
                              ),
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(
                                color: MyColors.primaryNormal,
                              ),
                              hintText: 'Task Name',
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Set Time'),
                            StatefulBuilder(builder: (BuildContext context,
                                StateSetter timePickState) {
                              return OutlinedButton(
                                onPressed: () async {
                                  await _show();
                                  timePickState(() {});
                                },
                                child: Text(formattedTime != null
                                    ? formattedTime
                                    : 'No time selected!'),
                              );
                            }),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Repetitive task'),
                            Switch(
                              value: isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Visibility(
                          visible: isSwitched,
                          child: StatefulBuilder(
                            builder: (BuildContext context,
                                StateSetter dropDownState) {
                              return DropdownButton<String>(
                                value: repetitiveDropdownValue,
                                icon: Icon(Icons.arrow_downward),
                                elevation: 0,
                                style: TextStyle(
                                    color:
                                        MyColors.textNormal.withOpacity(1.0)),
                                underline: Container(
                                  height: 2,
                                  color:
                                      MyColors.primaryNormal.withOpacity(0.7),
                                ),
                                onChanged: (String? newRepetitiveValue) {
                                  dropDownState(() {
                                    repetitiveDropdownValue =
                                        newRepetitiveValue!;
                                  });
                                },
                                items: <String>[
                                  'Daily',
                                  'Weekly'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : selectedDailyIndex == 1
                      ? NewDueToPage()
                      : NewRepetitivePage()),
        ),
      ]),
    );
  }

  Future<void> _show() async {
    final TimeOfDay? result = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, childWidget) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: childWidget!);
        });
    if (result != null) {
      setState(() {
        String string = '';
        for (int index = 10; index <= 14; index++) {
          string += to24hours(result)[index]; // result.format(context);
        }
        formattedTime = string;
      });
    }
  }

  String to24hours(TimeOfDay? tod) {
    final time = tod.toString().padLeft(2, "0");
    return "$time";
  }

  Task findTaskById(int? id) {
    Task task = Task.repetitive("hello1", RepetitiveType.Weekly,
        DateTime.now().add(Duration(minutes: 10)));
    // TODO search database for task
    return task;
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
            border: Border.all(color: MyColors.lightGray, width: 0.2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 1.0,
                spreadRadius: 0.2,
                offset: Offset(1.0, 1.0), // changes position of shadow
              ),
            ],
            color: isSelected ? MyColors.primaryNormal : MyColors.white,
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
                      isSelected ? MyColors.taintedWhite : MyColors.textNormal,
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
}
