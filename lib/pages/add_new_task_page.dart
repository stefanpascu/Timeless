import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/repetitive_type.dart';
import '../model/task.dart';
import '../model/task_type.dart';
import '../styles/styles.dart';

class NewTaskPage extends StatefulWidget {
  final int? id;
  final String? restorationId;

  NewTaskPage({Key? key, this.id, this.restorationId}) : super(key: key);

  @override
  State<NewTaskPage> createState() => NewTaskPageState();
}

class NewTaskPageState extends State<NewTaskPage> with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  late bool editMode;
  late Task task;
  late bool isSwitched = false;
  late RepetitiveType? repetitiveType = null;
  late String formattedTime = task.time.toString().split(" ")[1].split(":")[0] +
      ":" +
      task.time.toString().split(" ")[1].split(":")[1];
  late String formattedDate = task.time.toString().split(" ")[0];
  late TextEditingController _controller = TextEditingController(text: '');
  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  int selectedDailyIndex = 0;
  String repetitiveDropdownValue = 'Daily';
  bool timeError = false;

  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @override
  void initState() {
    editMode = widget.id != null;
    if (editMode) {
      task = findTaskById(widget.id);

      _controller = TextEditingController(text: task.name);

      if (task.type == TaskType.Repetitive)
        selectedDailyIndex = 0;
      else if (task.type == TaskType.DueTo)
        selectedDailyIndex = 1;
      else if (task.type == TaskType.Appointment) selectedDailyIndex = 2;

      task.id = widget.id;

      formattedTime = task.time.toString().split(" ")[1].split(":")[0] +
          ":" +
          task.time.toString().split(" ")[1].split(":")[1];

      if (selectedDailyIndex == 0) {
        repetitiveType = task.repetitiveType;

        if (task.type == TaskType.Repetitive) {
          if (task.repetitiveType == null)
            isSwitched = false;
          else
            isSwitched = true;

          if (repetitiveType != null) {
            repetitiveDropdownValue =
                task.repetitiveType.toString().split('.')[1];
          }
        }
      } else if (selectedDailyIndex == 1 || selectedDailyIndex == 2) {
        formattedDate = task.time.toString().split(" ")[0];
      }
    } else if (selectedDailyIndex == 0)
      task = Task.repetitive("", null, DateTime.now(), null);
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
        actions: [
          if (editMode == true)
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: MyColors.primaryDarkest,
                  size: 35.0,
                ),
                onPressed: () {
                  print('delete task');
                },
              ),
            ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 60.0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _filterWidget(
                      title: 'Repetitive',
                      index: 0,
                      color: MyColors.repetitiveBlue),
                  _filterWidget(
                      title: 'Due to', index: 1, color: MyColors.dueToRed),
                  _filterWidget(
                      title: 'Appointment',
                      index: 2,
                      color: MyColors.appointmentGreen),
                ],
              ),
            ),
          ),
          Container(
              child: selectedDailyIndex == 0
                  ? Column(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                              child: TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyColors.primaryNormal
                                            .withOpacity(0.7),
                                        width: 1.5),
                                  ),
                                  border: OutlineInputBorder(),
                                  labelStyle: TextStyle(
                                    color: MyColors.primaryNormal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Pick a Time',
                              style: TextStyle(
                                  color: MyColors.textNormal, fontSize: 20),
                            ),
                            StatefulBuilder(builder: (BuildContext context,
                                StateSetter timePickState) {
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  primary: MyColors.white,
                                  side: const BorderSide(
                                      color: MyColors.primaryNormal,
                                      width: 1.0),
                                ),
                                onPressed: () async {
                                  await _show();
                                  timePickState(() {});
                                },
                                child: Text(
                                  formattedTime,
                                  style: TextStyle(color: MyColors.textNormal),
                                ),
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
                                  if (isSwitched == false)
                                    task.repetitiveType = null;
                                  else
                                    task.repetitiveType = repetitiveType != null
                                        ? repetitiveType
                                        : RepetitiveType.Daily;
                                });
                              },
                            ),
                          ],
                        ),
                        Visibility(
                          visible: isSwitched,
                          child: StatefulBuilder(
                            builder: (BuildContext context,
                                StateSetter NewTaskPageState) {
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
                                  NewTaskPageState(() {
                                    repetitiveDropdownValue =
                                        newRepetitiveValue!;
                                    if (repetitiveDropdownValue == 'Daily') {
                                      repetitiveType = RepetitiveType.Daily;
                                      task.repetitiveType =
                                          RepetitiveType.Daily;
                                    } else if (repetitiveDropdownValue ==
                                        'Weekly') {
                                      repetitiveType = RepetitiveType.Weekly;
                                      task.repetitiveType =
                                          RepetitiveType.Weekly;
                                    }
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
                        SizedBox(
                          width: 150.0,
                          height: 45.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: MyColors.accentNormal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              shadowColor: Colors.grey,
                              elevation: 2.5,
                              side: BorderSide(
                                width: 0.8,
                                color: MyColors.lightGray,
                              ),
                            ),
                            onPressed: () => {
                              print('Save'),
                              if (_controller.text == "")
                                task.name = "Nameless Task"
                              else
                                task.name = _controller.text,
                              printTask(task),
                              Navigator.pop(context)
                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                  fontSize: 20.0, color: MyColors.taintedWhite),
                            ),
                          ),
                        ),
                      ],
                    )
                  : selectedDailyIndex == 1
                      ? Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                              child: TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyColors.primaryNormal
                                            .withOpacity(0.7),
                                        width: 1.5),
                                  ),
                                  border: OutlineInputBorder(),
                                  labelStyle: TextStyle(
                                    color: MyColors.primaryNormal,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Pick a Time'),
                                StatefulBuilder(builder: (BuildContext context,
                                    StateSetter timePickState) {
                                  return OutlinedButton(
                                    onPressed: () async {
                                      await _show();
                                      timePickState(() {});
                                    },
                                    child: Text(formattedTime),
                                  );
                                }),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Pick a Date '),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                  ),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      _restorableDatePickerRouteFuture
                                          .present();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: MyColors.primaryNormal,
                                          width: 1.0),
                                    ),
                                    child: Text(
                                      formattedDate,
                                      style: TextStyle(
                                        color: MyColors.textNormal
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: timeError,
                              child: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter NewTaskPageState) {
                                  return Text(
                                    'Selected Date and Time combination is invalid',
                                    style: TextStyle(color: Colors.red),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 150.0,
                              height: 45.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: MyColors.accentNormal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  shadowColor: Colors.grey,
                                  elevation: 2.5,
                                  side: BorderSide(
                                    width: 0.8,
                                    color: MyColors.lightGray,
                                  ),
                                ),
                                onPressed: () => {
                                  print('Save'),
                                  if (_controller.text == "")
                                    task.name = "Nameless Task"
                                  else
                                    task.name = _controller.text,
                                  if (compareDates(task.time, DateTime.now()))
                                    {printTask(task), Navigator.pop(context)}
                                  else
                                    {timeError = true},
                                  setState(() {})
                                },
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: MyColors.taintedWhite),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                              child: TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyColors.primaryNormal
                                            .withOpacity(0.7),
                                        width: 1.5),
                                  ),
                                  border: OutlineInputBorder(),
                                  labelStyle: TextStyle(
                                    color: MyColors.primaryNormal,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Pick a Time'),
                                StatefulBuilder(builder: (BuildContext context,
                                    StateSetter timePickState) {
                                  return OutlinedButton(
                                    onPressed: () async {
                                      await _show();
                                      timePickState(() {});
                                    },
                                    child: Text(formattedTime),
                                  );
                                }),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Pick a Date'),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                  ),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      _restorableDatePickerRouteFuture
                                          .present();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: MyColors.primaryNormal,
                                          width: 1.0),
                                    ),
                                    child: Text(
                                      formattedDate,
                                      style: TextStyle(
                                        color: MyColors.textNormal
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: timeError,
                              child: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter NewTaskPageState) {
                                  return Text(
                                    'Selected Date and Time combination is invalid',
                                    style: TextStyle(color: Colors.red),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 150.0,
                              height: 45.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: MyColors.accentNormal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  shadowColor: Colors.grey,
                                  elevation: 2.5,
                                  side: BorderSide(
                                    width: 0.8,
                                    color: MyColors.lightGray,
                                  ),
                                ),
                                onPressed: () => {
                                  print('Save'),
                                  if (_controller.text == "")
                                    task.name = "Nameless Task"
                                  else
                                    task.name = _controller.text,
                                  if (compareDates(task.time, DateTime.now()))
                                    {printTask(task), Navigator.pop(context)}
                                  else
                                    {timeError = true},
                                  setState(() {})
                                },
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: MyColors.taintedWhite),
                                ),
                              ),
                            ),
                          ],
                        )),
        ]),
      ),
    );
  }

  bool compareDates(DateTime a, DateTime b) {
    if (int.parse(a.toString().split(" ")[0].split("-")[0]) >
        int.parse(b.toString().split(" ")[0].split("-")[0]))
      return true;
    else if (int.parse(a.toString().split(" ")[0].split("-")[0]) ==
        int.parse(b.toString().split(" ")[0].split("-")[0])) if (int.parse(
            a.toString().split(" ")[0].split("-")[1]) >
        int.parse(b.toString().split(" ")[0].split("-")[1]))
      return true;
    else if (int.parse(a.toString().split(" ")[0].split("-")[1]) ==
        int.parse(b.toString().split(" ")[0].split("-")[1])) if (int.parse(
            a.toString().split(" ")[0].split("-")[2]) >
        int.parse(b.toString().split(" ")[0].split("-")[2]))
      return true;
    else if (int.parse(a.toString().split(" ")[0].split("-")[2]) ==
        int.parse(b.toString().split(" ")[0].split("-")[2])) if (int.parse(
            a.toString().split(" ")[1].split(":")[0]) >
        int.parse(b.toString().split(" ")[1].split(":")[0]))
      return true;
    else if (int.parse(a.toString().split(" ")[1].split(":")[0]) ==
        int.parse(b.toString().split(" ")[1].split(":")[0])) if (int.parse(
            a.toString().split(" ")[1].split(":")[1]) >
        int.parse(b.toString().split(" ")[1].split(":")[1])) return true;
    return false;
  }

  void printTask(Task task) {
    print("name: " + task.name);
    print("type: " + task.type.toString().split('.')[1]);
    print("repetitive type: " + task.repetitiveType.toString());
    print("time: " + task.time.toString());
    print("id: " + task.id.toString());
    print('///////////////////////////////');
  }

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime.now(),
          lastDate: DateTime(2200),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        if (_selectedDate.value.month >= 10) if (_selectedDate.value.day >= 10)
          formattedDate =
              '${_selectedDate.value.year}-${_selectedDate.value.month}-${_selectedDate.value.day}';
        else
          formattedDate =
              '${_selectedDate.value.year}-${_selectedDate.value.month}-0${_selectedDate.value.day}';
        else if (_selectedDate.value.day >= 10)
          formattedDate =
              '${_selectedDate.value.year}-0${_selectedDate.value.month}-${_selectedDate.value.day}';
        else
          formattedDate =
              '${_selectedDate.value.year}-0${_selectedDate.value.month}-0${_selectedDate.value.day}';

        task.time = DateTime.parse(
            formattedDate + " " + task.time.toString().split(" ")[1]);

        timeError = false;
      });
    }
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
        DateTime time = task.time;
        task.time =
            DateTime.parse(time.toString().split(" ")[0] + " " + formattedTime);
      });
    }
  }

  String to24hours(TimeOfDay? tod) {
    final time = tod.toString().padLeft(2, "0");
    return "$time";
  }

  Task findTaskById(int? id) {
    // Task taskAux = Task.repetitive("", null,
    //     DateTime.now(), id);
    Task taskAux = Task.dueTo("hello1", DateTime.now(), id);
    // Task taskAux = Task.appointment("hello1",
    //     DateTime.now(), id);
    // TODO search database for task
    return taskAux;
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
          if (editMode == false) {
            if (selectedDailyIndex == 0)
              task = Task.repetitive("", null, DateTime.now(), null);
            else if (selectedDailyIndex == 1)
              task = Task.dueTo("", DateTime.now(), null);
            else if (selectedDailyIndex == 2)
              task = Task.appointment("", DateTime.now(), null);
          } else {
            String name = task.name;
            DateTime dateTime = task.time;
            int? id = task.id;
            if (selectedDailyIndex == 0) if (isSwitched == false)
              task = Task.repetitive(name, null, dateTime, id);
            else
              task = Task.repetitive(name, repetitiveType, dateTime, id);
            else if (selectedDailyIndex == 1)
              task = Task.dueTo(name, dateTime, id);
            else if (selectedDailyIndex == 2)
              task = Task.appointment(name, dateTime, id);
          }
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
