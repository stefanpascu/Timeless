import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/goal.dart';
import '../model/goal_type.dart';
import '../styles/styles.dart';

class NewGoalPage extends StatefulWidget {
  final int? id;

  NewGoalPage({Key? key, this.id}) : super(key: key);

  @override
  State<NewGoalPage> createState() => NewGoalPageState();
}

class NewGoalPageState extends State<NewGoalPage> {
  late bool editMode;
  late Goal goal;
  late TextEditingController _controller = TextEditingController(text: '');
  int selectedDailyIndex = 0;

  @override
  void initState() {
    editMode = widget.id != null;
    if (editMode) {
      goal = findGoalById(widget.id);

      _controller = TextEditingController(text: goal.name);

      if (goal.type == GoalType.Public)
        selectedDailyIndex = 1;
      else if (goal.type == GoalType.Private) selectedDailyIndex = 0;

      goal.id = widget.id;
    } else if (selectedDailyIndex == 0) goal = Goal.private("", null);
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
          editMode ? 'EDIT GOAL' : 'NEW GOAL',
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
                  print('delete goal');
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
                      title: 'Private',
                      index: 0,
                      color: MyColors.privatePurple),
                  _filterWidget(
                      title: 'Public', index: 1, color: MyColors.publicYellow),
                ],
              ),
            ),
          ),
          Container(
              child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: MyColors.primaryNormal.withOpacity(0.7),
                          width: 1.5),
                    ),
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                      color: MyColors.primaryNormal,
                    ),
                  ),
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
                      goal.name = "Nameless Goal"
                    else
                      goal.name = _controller.text,
                    printGoal(goal),
                    Navigator.pop(context)
                  },
                  child: const Text(
                    'Save',
                    style:
                        TextStyle(fontSize: 20.0, color: MyColors.taintedWhite),
                  ),
                ),
              ),
            ],
          )),
        ]),
      ),
    );
  }

  void printGoal(Goal goal) {
    print("name: " + goal.name);
    print("type: " + goal.type.toString().split('.')[1]);
    print("id: " + goal.id.toString());
    print('///////////////////////////////');
  }

  Goal findGoalById(int? id) {
    // Goal goalAux = Goal.public("", 1);
    Goal goalAux = Goal.private("hello1", 1);
    // Goal goalAux = Goal.appointment("hello1", 1);
    // TODO search database for goal
    return goalAux;
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
              goal = Goal.private("", null);
            else if (selectedDailyIndex == 1) goal = Goal.public("", null);
          } else {
            String name = goal.name;
            int? id = goal.id;
            if (selectedDailyIndex == 0)
              goal = Goal.private(name, id);
            else if (selectedDailyIndex == 1) goal = Goal.public(name, id);
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
