import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late bool isDarkTheme;
  int selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<bool> getThemeFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final startupBool = prefs.getBool('option');
    return startupBool == null ? false : startupBool;
  }

  @override
  void initState() {
    // isDarkTheme = widget.isDarkTheme == null ? false : widget.isDarkTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getThemeFromSharedPref(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool isDarkTheme = snapshot.data!;
            late List<Widget> _widgetOptions = <Widget>[
              Text(
                'DAILY TASKS',
                style: TextStyle(
                    color: isDarkTheme == false
                        ? MyColors.lightThemeTitle
                        : MyColors.darkThemeTitle,
                    fontFamily: 'OpenSans',
                    fontSize: 25.0,
                    fontWeight: FontWeight.w900),
              ),
              Text(
                'GOALS',
                style: TextStyle(
                    color: isDarkTheme == false
                        ? MyColors.lightThemeTitle
                        : MyColors.darkThemeTitle,
                    fontFamily: 'OpenSans',
                    fontSize: 25.0,
                    fontWeight: FontWeight.w900),
              ),
            ];

            return Scaffold(
              appBar: AppBar(
                leading: Builder(
                  builder: (context) => RaisedButton(
                      color: MyColors.backgroundNormal.withOpacity(0),
                      elevation: 0,
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      child: Icon(
                        Icons.widgets,
                        size: 30.0,
                        color: isDarkTheme == false
                            ? MyColors.lightThemeTitle
                            : MyColors.darkThemeTitle,
                      )),
                ),

                backgroundColor: MyColors.backgroundNormal.withOpacity(0),
                // Colors.transparent,

                title: Align(
                  alignment: Alignment.center,
                  child: _widgetOptions.elementAt(selectedIndex),
                ),

                actions: [
                  Icon(
                    Icons.widgets,
                    color: isDarkTheme == false
                        ? MyColors.lightThemeBackground
                        : MyColors.darkThemeBackground,
                    size: 50.0,
                  ),
                ],

                elevation: 0,
              ),
              drawer: MainDrawer(
                pageId: 1,
                isDarkTheme: isDarkTheme,
              ),
              body: Container(
                  child: selectedIndex == 1
                      ? GoalsPage(
                          isDarkTheme: isDarkTheme,
                        )
                      : DailyPage(
                          isDarkTheme: isDarkTheme,
                        )),
              floatingActionButton: SizedBox(
                width: 70.0,
                height: 70.0,
                child: FloatingActionButton(
                  mini: false,
                  backgroundColor: MyColors.accentNormal,
                  onPressed: () => {
                    selectedIndex == 0
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewTaskPage(
                                      isDarkTheme: isDarkTheme,
                                    )),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewGoalPage(
                                      isDarkTheme: isDarkTheme,
                                    )),
                          )
                  },
                  hoverElevation: 1.5,
                  shape: StadiumBorder(
                    side: BorderSide(
                        color: isDarkTheme == false
                            ? MyColors.lightThemeBackground
                            : MyColors.darkThemeBackground,
                        width: 7),
                  ),
                  elevation: 1.5,
                  child: Icon(
                    Icons.add,
                    size: 35.0,
                    color: isDarkTheme == false
                        ? MyColors.lightThemeBackground
                        : MyColors.darkThemeBackground,
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              backgroundColor: isDarkTheme == false
                  ? MyColors.lightThemeBackground
                  : MyColors.darkThemeBackground,
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
                      BoxShadow(
                          color: Colors.black38,
                          spreadRadius: 0,
                          blurRadius: 10),
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
          } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
          } else return Center(child: CircularProgressIndicator(),);
        });
  }

}
