import 'package:flutter/material.dart';

import '../model/goal.dart';
import '../model/goal_type.dart';
import '../service/firebase_service.dart';
import '../styles/styles.dart';

class NewGoalPage extends StatefulWidget {
  final Goal? goal;

  NewGoalPage({Key? key, this.goal}) : super(key: key);

  @override
  State<NewGoalPage> createState() => NewGoalPageState();
}

class NewGoalPageState extends State<NewGoalPage> {
  bool _submitted = false;
  late bool editMode;
  late Goal goal;
  TextEditingController _controller = TextEditingController();
  var _textName = '';
  int selectedDailyIndex = 0;

  @override
  void initState() {
    editMode = widget.goal != null;
    goal = widget.goal == null ? Goal.private("", null) : widget.goal!;
    initWidgets(widget.goal);
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
            editMode ? 'EDIT GOAL' : 'NEW GOAL',
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
                  size: 50.0,
                ),
                onPressed: () {
                  print('delete goal');
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
                      title: 'Private',
                      index: 0,
                      color: MyColors().privatePurple),
                  _filterWidget(
                      title: 'Public',
                      index: 1,
                      color: MyColors().publicYellow),
                ],
              ),
            ),
          ),
          Container(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                child: TextField(
                  controller: _controller,
                  cursorColor: MyColors().textNormal,
                  style: TextStyle(color: MyColors().textNormal),
                  onChanged: (text) => setState(() => _textName),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    errorText: _submitted ? _errorNameText : null,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: MyColors().primaryNormal.withOpacity(0.7),
                          width: 1.5),
                    ),
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                      color: MyColors().primaryNormal,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
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
                    if (_controller.value.text.isNotEmpty) {_submit()}
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: MyColors().highlightedFilterText),
                  ),
                ),
              ),
            ],
          )),
        ]),
      ),
    );
  }

  void _submit() {
    // if there is no error text
    if (_errorNameText == null) {
      goal.name = _controller.text;
      if (editMode == false)
        FirebaseService.createNewGoal(goal);
      else {
        FirebaseService.editExistingGoal(goal);
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

  void printGoal(Goal goal) {
    print("name: " + goal.name);
    print("type: " + goal.type.toString().split('.')[1]);
    print("id: " + goal.id.toString());
    print('///////////////////////////////');
  }

  Goal findGoalById(int? id) {
    // Goal goalAux = Goal.public("", 1);
    Goal goalAux = Goal.private("hello1", '1');
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
            String? id = goal.id;
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
            border: Border.all(color: MyColors().lightGray, width: 0.2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 1.0,
                spreadRadius: 0.2,
                offset: Offset(1.0, 1.0), // changes position of shadow
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

  void initWidgets(Goal? task) {
    if (editMode) {
      _controller = TextEditingController(text: goal.name);

      if (goal.type == GoalType.Public)
        selectedDailyIndex = 1;
      else if (goal.type == GoalType.Private) selectedDailyIndex = 0;
    }
  }
}
