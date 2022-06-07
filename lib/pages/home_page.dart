import 'package:flutter/material.dart';
import 'package:timeless/pages/daily_page.dart';
import 'package:timeless/pages/drawer_page.dart';
import 'package:timeless/pages/goals_page.dart';

import '../styles/styles.dart';
import 'add_new_goal_page.dart';
import 'add_new_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'DAILY TASKS',
      style: TextStyle(
          color:  MyColors.primaryDarkest,
          fontFamily: 'OpenSans',
          fontSize: 25.0,
          fontWeight: FontWeight.w900),
    ),
    Text(
      'GOALS',
      style: TextStyle(
          color:  MyColors.primaryDarkest,
          fontFamily: 'OpenSans',
          fontSize: 25.0,
          fontWeight: FontWeight.w900),
    ),
  ];

  _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => RaisedButton(
              color:  MyColors.taintedWhite.withOpacity(0),
              elevation: 0,
              onPressed: () => Scaffold.of(context).openDrawer(),
              child: const Icon(
                Icons.widgets,
                size: 30.0,
                color:  MyColors.primaryDarkest,
              )),
        ),

        backgroundColor:  MyColors.taintedWhite.withOpacity(0),
        // Colors.transparent,

        title:
            Align(
              alignment: Alignment.center,
              child: _widgetOptions.elementAt(selectedIndex),
            ),


        actions: [
          Icon(
            Icons.widgets,
            color:  MyColors.taintedWhite,
            size: 60.0,
          ),
        ],

        elevation: 0,
      ),
      drawer: MainDrawer(pageId: 1),
      body: Container(
        child:
          selectedIndex == 1 ? GoalsPage() : DailyPage()
      ),
      floatingActionButton: SizedBox(
        width: 70.0,
        height: 70.0,
        child: FloatingActionButton(
          mini: false,
          backgroundColor:  MyColors.accentNormal,
          onPressed: () => {
            selectedIndex == 0 ? Navigator.push(context, MaterialPageRoute(builder: (context) => NewTaskPage()),) : Navigator.push(context, MaterialPageRoute(builder: (context) => NewGoalPage()),)
          },
          hoverElevation: 1.5,
          shape: const StadiumBorder(
            side: BorderSide(color:  MyColors.taintedWhite, width: 7),
          ),
          elevation: 1.5,
          child: const Icon(
            Icons.add,
            size: 35.0,
            color:  MyColors.taintedWhite,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor:  MyColors.taintedWhite,
      bottomNavigationBar: Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                MyColors.primaryDarker,
                MyColors.primaryNormal,
              ],
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(15.0),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt), label: 'DAILY'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance), label: 'GOALS'),
              ],
              backgroundColor: MyColors.primaryNormal.withOpacity(0),
              currentIndex: selectedIndex,
              selectedItemColor: const Color(0xffffffff),
              // 0xffEEF0F0
              unselectedItemColor: const Color(0xffC2C6D5),
              onTap: _onItemTapped,
              elevation: 0,
            ),
          )),
    );
  }
}
