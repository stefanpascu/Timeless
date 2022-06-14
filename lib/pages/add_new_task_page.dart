import 'package:flutter/material.dart';
import 'package:timeless/service/firebase_service.dart';

import '../model/repetitive_type.dart';
import '../model/task.dart';
import '../model/task_type.dart';
import '../model/user.dart';
import '../service/notification_service.dart';
import '../styles/styles.dart';

class NewTaskPage extends StatefulWidget {
  final Task? task;
  final String? restorationId;

  NewTaskPage({Key? key, this.task, this.restorationId}) : super(key: key);

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
  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  TextEditingController _controller = TextEditingController();
  var _textName = '';
  bool _submitted = false;
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
    editMode = widget.task != null;
    task = widget.task == null
        ? Task.repetitive("", RepetitiveType.Daily, DateTime.now(), null, 0)
        : widget.task!;
    initWidgets(widget.task);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors().backgroundNormal,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: MyColors().primaryTitle,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: MyColors().backgroundNormal.withOpacity(0),
          title: Align(
            alignment: Alignment.center,
            child: Text(
              editMode ? 'EDIT TASK' : 'NEW TASK',
              style: TextStyle(
                color: MyColors().primaryTitle,
                fontSize: 25.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          actions: [
            if (editMode == true) ...[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: MyColors().primaryTitle,
                    size: 40.0,
                  ),
                  onPressed: () async {
                    FirebaseService.deleteTask(task.id!);
                    await NotificationService()
                        .cancelNotification(task.notificationId);
                    Navigator.pop(context);
                  },
                ),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Icon(
                  Icons.delete,
                  color: MyColors().backgroundNormal,
                  size: 50.0,
                ),
              ),
            ]
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
                        color: MyColors().repetitiveBlue),
                    _filterWidget(
                        title: 'Due to', index: 1, color: MyColors().dueToRed),
                    _filterWidget(
                        title: 'Appointment',
                        index: 2,
                        color: MyColors().appointmentGreen),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Container(
                child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: TextField(
                  controller: _controller,
                  cursorColor: MyColors().textNormal,
                  style: TextStyle(color: MyColors().textNormal),
                  onChanged: (text) => setState(() => _textName),
                  decoration: InputDecoration(
                    errorText: _submitted ? _errorNameText : null,
                    labelText: 'Name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: MyColors().primaryNormal.withOpacity(0.7),
                        width: 1.5,
                      ),
                    ),
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                      color: MyColors().primaryNormal,
                    ),
                  ),
                ),
              ),
              selectedDailyIndex == 0
                  ? Column(
                      children: [
                        SizedBox(
                          height: 40.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Row(
                            children: [
                              Text(
                                'Pick a Time:',
                                style: TextStyle(
                                  color: MyColors().textNormal,
                                  fontSize: 20.0,
                                ),
                              ),
                              Spacer(),
                              StatefulBuilder(builder: (BuildContext context,
                                  StateSetter timePickState) {
                                return OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    primary: MyColors().overBackground,
                                    side: BorderSide(
                                        color: MyColors().primaryNormal,
                                        width: 1.2),
                                  ),
                                  onPressed: () async {
                                    await _show();
                                    timePickState(() {});
                                  },
                                  child: Text(
                                    formattedTime,
                                    style: TextStyle(
                                        color: MyColors().textNormal,
                                        fontSize: 20.0),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter NewTaskPageState) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: DropdownButton<String>(
                                  value: repetitiveDropdownValue,
                                  dropdownColor: MyColors().overBackground,
                                  icon: Icon(Icons.arrow_downward),
                                  elevation: 0,
                                  style: TextStyle(
                                      color: MyColors()
                                          .textNormal
                                          .withOpacity(1.0),
                                      fontSize: 20.0),
                                  underline: Container(
                                    height: 2,
                                    color: MyColors()
                                        .primaryNormal
                                        .withOpacity(0.7),
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
                                  items: <String>['Daily', 'Weekly']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 8.0,
                        )
                      ],
                    )
                  : selectedDailyIndex == 1
                      ? Column(
                          children: [
                            SizedBox(height: 40.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Pick a Time:',
                                    style: TextStyle(
                                      color: MyColors().textNormal,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  Spacer(),
                                  StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter timePickState) {
                                    return OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        primary: MyColors().overBackground,
                                        side: BorderSide(
                                            color: MyColors().primaryNormal,
                                            width: 1.2),
                                      ),
                                      onPressed: () async {
                                        await _show();
                                        timePickState(() {});
                                      },
                                      child: Text(
                                        formattedTime,
                                        style: TextStyle(
                                            color: MyColors().textNormal,
                                            fontSize: 20.0),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Pick a Date:',
                                    style: TextStyle(
                                      color: MyColors().textNormal,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  Spacer(),
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
                                        side: BorderSide(
                                            color: MyColors().primaryNormal,
                                            width: 1.0),
                                      ),
                                      child: Text(
                                        formattedDate,
                                        style: TextStyle(
                                            color: MyColors().textNormal,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(height: 40.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Pick a Time:',
                                    style: TextStyle(
                                      color: MyColors().textNormal,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  Spacer(),
                                  StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter timePickState) {
                                    return OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        primary: MyColors().overBackground,
                                        side: BorderSide(
                                            color: MyColors().primaryNormal,
                                            width: 1.2),
                                      ),
                                      onPressed: () async {
                                        await _show();
                                        timePickState(() {});
                                      },
                                      child: Text(
                                        formattedTime,
                                        style: TextStyle(
                                            color: MyColors().textNormal,
                                            fontSize: 20.0),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Pick a Date:',
                                    style: TextStyle(
                                      color: MyColors().textNormal,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  Spacer(),
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
                                        side: BorderSide(
                                            color: MyColors().primaryNormal,
                                            width: 1.0),
                                      ),
                                      child: Text(
                                        formattedDate,
                                        style: TextStyle(
                                            color: MyColors().textNormal,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                          ],
                        )
            ])),
            SizedBox(height: 30.0),
            SizedBox(
              width: 150.0,
              height: 45.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: MyColors().accentNormal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  shadowColor: Colors.grey,
                  elevation: 2.5,
                  side: BorderSide(
                    width: 0.8,
                    color: MyColors().lightGray,
                  ),
                ),
                onPressed: () => {
                  setState(() {
                    _submitted = true;
                  }),
                  if (selectedDailyIndex != 0)
                    {
                      if (_controller.value.text
                          .isNotEmpty) //&& compareDates(task.time, DateTime.now()))
                        {_submit()}
                      else if (!compareDates(task.time, DateTime.now()))
                        {timeError = true}
                    }
                  else if (_controller.value.text.isNotEmpty)
                    {_submit()}
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                      fontSize: 20.0, color: MyColors().highlightedFilterText),
                ),
              ),
            ),
          ]),
        ));
  }

  Future<void> _submit() async {
    if (_errorNameText == null) {
      task.name = _controller.text;
      if (editMode == false) {
        final notificationIndex = UserData.fromJson((await FirebaseService
                    .firestore
                    .collection('users')
                    .doc(FirebaseService.getCurrentUserId)
                    .get())
                .data()!)
            .notificationIndex;
        task.notificationId = notificationIndex;
        FirebaseService.createNewTask(task);
        await NotificationService().showNotification(
            notificationIndex,
            task.name,
            task.type == TaskType.Repetitive
                ? 'Your repetitive task is here!'
                : task.type == TaskType.DueTo
                    ? 'Your task is due to now!'
                    : 'Attention please, you have an appointment!',
            task.type == TaskType.Repetitive
                ? (compareDates(task.time, DateTime.now())
                    ? task.time
                    : (task.repetitiveType == RepetitiveType.Daily
                        ? task.time.add(Duration(days: 1))
                        : task.time.add(Duration(days: 7))))
                : task.time);
        await FirebaseService.firestore
            .collection('users')
            .doc(FirebaseService.getCurrentUserId)
            .update({
          'notification_index': notificationIndex + 1,
        });
      } else {
        FirebaseService.editExistingTask(task);
        await NotificationService().cancelNotification(task.notificationId);
        await NotificationService().showNotification(task.notificationId,
            task.name, 'Your task notification body', task.time);
      }
      Navigator.pop(context);
    }
  }

  String? get _errorNameText {
    final text = _controller.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    return null;
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
          string += to24hours(result)[index];
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

  void initWidgets(Task? task) {
    if (task != null) {
      _controller = TextEditingController(text: task.name);

      if (task.type == TaskType.Repetitive)
        selectedDailyIndex = 0;
      else if (task.type == TaskType.DueTo)
        selectedDailyIndex = 1;
      else if (task.type == TaskType.Appointment) selectedDailyIndex = 2;

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
    }
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
              task = Task.repetitive("", null, DateTime.now(), null, 0);
            else if (selectedDailyIndex == 1)
              task = Task.dueTo("", DateTime.now(), null, 0);
            else if (selectedDailyIndex == 2)
              task = Task.appointment("", DateTime.now(), null, 0);
          } else {
            String name = task.name;
            DateTime dateTime = task.time;
            String? id = task.id;
            int notifId = task.notificationId;
            if (selectedDailyIndex == 0) if (isSwitched == false)
              task = Task.repetitive(name, null, dateTime, id, notifId);
            else
              task =
                  Task.repetitive(name, repetitiveType, dateTime, id, notifId);
            else if (selectedDailyIndex == 1)
              task = Task.dueTo(name, dateTime, id, notifId);
            else if (selectedDailyIndex == 2)
              task = Task.appointment(name, dateTime, id, notifId);
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
            border: Border.all(color: MyColors().lightGray, width: 0.2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 1.0,
                spreadRadius: 0.2,
                offset: Offset(1.0, 1.0),
              ),
            ],
            color: isSelected
                ? MyColors().primaryNormal
                : MyColors().overBackground,
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
                  color: isSelected
                      ? MyColors().highlightedFilterText
                      : MyColors().textNormal,
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
