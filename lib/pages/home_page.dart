import 'package:flutter/material.dart';
import 'package:timeless/pages/daily_page.dart';
import 'package:timeless/pages/goals_page.dart';
import 'package:timeless/pages/profile.dart';
import 'package:timeless/pages/register.dart';
import 'package:timeless/pages/settings.dart';

import '../styles/styles.dart';
import 'add_new_task_page.dart';
import 'friends_page.dart';

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
          _widgetOptions.elementAt(selectedIndex),

        actions: [
          Icon(
            Icons.widgets,
            color:  MyColors.taintedWhite,
            size: 50.0,
          ),
        ],

        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor:  MyColors.taintedWhite,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.all(60),
              height: 220,
              decoration: const BoxDecoration(
                color: Color(0xffCCCED0), // F89D7D
              ),
              child: Column(
                children: [
                  FloatingActionButton(
                    onPressed: () => {
                      Navigator.pop(context),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()),
                      ),
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 5.0,
                    ),
                    child: const Text(
                      'Your Name Here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text(
                'Home',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                ),
              ),
              onTap: () {
                // Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()),);
              },
            ),
            Divider(
              thickness: 1,
              indent: 40,
              endIndent: 40,
              color: const Color(0xff4B5052).withOpacity(0.5),
            ),
            ListTile(
              title: const Text(
                'Friends',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FriendsPage()),
                );
              },
            ),
            Divider(
              thickness: 2,
              indent: 40,
              endIndent: 40,
              color: const Color(0xff4B5052).withOpacity(0.2),
            ),
            ListTile(
              title: const Text(
                'Settings',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
            ),
            Divider(
              thickness: 1,
              indent: 40,
              endIndent: 40,
              color: const Color(0xff4B5052).withOpacity(0.5),
            ),
            ListTile(
              title: const Text(
                'Logout',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                ),
              ),
              onTap: () {
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Register()),
                );
              },
            ),
          ],
        ),
      ),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewTaskPage()),),
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
