import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

import '../model/goal.dart';
import '../model/goal_type.dart';
import '../service/firebase_service.dart';
import '../styles/styles.dart';
import 'add_new_goal_page.dart';

class GoalsPage extends StatefulWidget {
  final isDarkTheme;
  const GoalsPage({Key? key, required this.isDarkTheme}) : super(key: key);

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  late bool isDarkTheme;
  int selectedGoalsIndex = 0;

  static List<Goal> goals = [];
  List<Goal> filteredGoals = goals;

  @override
  void initState() {
    isDarkTheme = widget.isDarkTheme == null ? false : widget.isDarkTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseService.getCurrentUserId)
          .collection('goals')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Text('Something went wrong...');
        else if (snapshot.hasData) {
          goals = snapshot.data!.docs
              .map((DocumentSnapshot e) => Goal.fromJson2(e))
              .toList();
          filteredGoals = goals;
          _filterGoals();
          return Column(children: [
            SizedBox(
              height: 60.0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _filterWidget(title: 'All', index: 0, hasCircle: false),
                    _filterWidget(
                        title: 'Private', index: 2, color: MyColors.privatePurple),
                    _filterWidget(
                        title: 'Public', index: 1, color: MyColors.publicYellow),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: GroupedListView<Goal, String>(
                    elements: filteredGoals,
                    groupBy: (element) => _buildGroupByString(element),
                    groupSeparatorBuilder: (String groupByValue) => Padding(
                      padding: EdgeInsets.only(top: 30.0, bottom: 5.0),
                      child: Text(
                        groupByValue,
                        style: TextStyle(
                            color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                            fontSize: 15.0,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    itemBuilder: (context, Goal goal) => _goalWidget(goal),
                    shrinkWrap: true,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,)
          ]);
        }
        return Center(child: CircularProgressIndicator());
      }
    );
  }

  String _buildGroupByString(Goal element) {
    if (element.type == GoalType.Public) return 'Public';
    return 'Private';
  }

  Widget _goalWidget(Goal goal) {
    return GestureDetector(
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewGoalPage(goal: goal, isDarkTheme: isDarkTheme,)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: MyColors.lightGray, width: 0.2),
              color: isDarkTheme == false ? MyColors.lightThemeOverBackground : MyColors.darkThemeOverBackground,
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
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: goal.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 20.0),
                    child: Container(
                      alignment: FractionalOffset(0.43, 0.0),
                      child: Text(
                        goal.name,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
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
    bool isSelected = index == selectedGoalsIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGoalsIndex = index;
          _filterGoals();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(minWidth: 35),
          height: 35,
          padding: EdgeInsets.symmetric(horizontal: 10),
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
            color: isSelected ? MyColors.primaryNormal : isDarkTheme == false ? MyColors.lightThemeOverBackground : MyColors.darkThemeOverBackground,
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
                      isSelected ? MyColors.highlightedFilterText : isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
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

  void _filterGoals() {
    if (selectedGoalsIndex == 0) {
      filteredGoals = goals;
    } else if (selectedGoalsIndex == 1) {
      filteredGoals =
          goals.where((goal) => goal.type == GoalType.Public).toList();
    } else if (selectedGoalsIndex == 2) {
      filteredGoals =
          goals.where((goal) => goal.type == GoalType.Private).toList();
    }
  }
}
