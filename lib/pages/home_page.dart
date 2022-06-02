import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeless/pages/daily_page.dart';
import 'package:timeless/pages/goals_page.dart';
import 'package:timeless/pages/profile.dart';
import 'package:timeless/pages/register.dart';
import 'package:timeless/pages/settings.dart';

import '../styles/styles.dart';
import 'friends_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  set selectedIndex(int value) {
    _selectedIndex = value;
  }

  int _selectedNewIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'DAILY TASKS',
      style: TextStyle(
          color:  MyColors.primaryDarkest,
          fontSize: 25.0,
          fontWeight: FontWeight.w900),
    ),
    Text(
      'NEW TASK',
      style: TextStyle(
          color:  MyColors.primaryDarkest,
          fontSize: 25.0,
          fontWeight: FontWeight.w900),
    ),
    Text(
      'GOALS',
      style: TextStyle(
          color:  MyColors.primaryDarkest,
          fontSize: 25.0,
          fontWeight: FontWeight.w900),
    ),
  ];

  int getSelectedIndex() {
    return _selectedIndex;
  }

  int getSelectedNewIndex() {
    return _selectedNewIndex;
  }

  void _onNewItemTapped(int index) {
    setState(() {
      _selectedNewIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
          _widgetOptions.elementAt(_selectedIndex),

        actions: const [
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
              ),
              onTap: () {
                Navigator.pop(context);
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
          ////////////////////////////////////////////////GOALS FRAGMENT//////////////////////////////////////////////////
          getSelectedIndex() == 2 ?
          Column(children: [
            if (getSelectedNewIndex() == 0) ...[
              Wrap(
                children: <Widget>[
                  Container(
                    width: 103,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: FloatingActionButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      backgroundColor: MyColors.primaryNormal,
                      onPressed: () => {
                        _onNewItemTapped(0),
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/filter_icon_blue.svg'),
                          const Text(
                            'Repetitive',
                            style: TextStyle(
                              color: Color(0xffEEF0F0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 76,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: FloatingActionButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      backgroundColor: const Color(0xffEEF0F0),
                      onPressed: () => {
                        _onNewItemTapped(1),
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/filter_icon_red.svg'),
                          const Text(
                            'Due to',
                            style: TextStyle(
                              color: MyColors.primaryNormal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 123,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: FloatingActionButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      backgroundColor:  MyColors.taintedWhite,
                      onPressed: () => {
                        _onNewItemTapped(2),
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/filter_icon_green.svg'),
                          const Text(
                            'Appointment',
                            style: TextStyle(
                              color:  MyColors.textNormal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const Icon(Icons.wysiwyg), // TODO continut
            ] else if (getSelectedNewIndex() == 1) ...[
              Wrap(
                children: <Widget>[
                  Container(
                    width: 103,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: FloatingActionButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      backgroundColor: const Color(0xffEEF0F0),
                      onPressed: () => {
                        _onNewItemTapped(0),
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/filter_icon_blue.svg'),
                          const Text(
                            'Repetitive',
                            style: TextStyle(
                              color: MyColors.primaryNormal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 76,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: FloatingActionButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      backgroundColor: MyColors.primaryNormal,
                      onPressed: () => {
                        _onNewItemTapped(1),
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/filter_icon_red.svg'),
                          const Text(
                            'Due to',
                            style: TextStyle(
                              color:  MyColors.taintedWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 123,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: FloatingActionButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      backgroundColor:  MyColors.taintedWhite,
                      onPressed: () => {
                        _onNewItemTapped(2),
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/filter_icon_green.svg'),
                          const Text(
                            'Appointment',
                            style: TextStyle(
                              color: MyColors.primaryNormal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const Icon(Icons.account_balance), // TODO continut
            ] else if (getSelectedNewIndex() == 2) ...[
              Wrap(
                children: <Widget>[
                  Container(
                    width: 103,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: FloatingActionButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      backgroundColor:  MyColors.taintedWhite,
                      onPressed: () => {
                        _onNewItemTapped(0),
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/filter_icon_blue.svg'),
                          const Text(
                            'Repetitive',
                            style: TextStyle(
                              color:  MyColors.textNormal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 76,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: FloatingActionButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      backgroundColor:  MyColors.taintedWhite,
                      onPressed: () => {
                        _onNewItemTapped(1),
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/filter_icon_red.svg'),
                          const Text(
                            'Due to',
                            style: TextStyle(
                              color:  MyColors.textNormal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 123,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: FloatingActionButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      backgroundColor: MyColors.primaryNormal,
                      onPressed: () => {
                        _onNewItemTapped(2),
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/filter_icon_green.svg'),
                          const Text(
                            'Appointment',
                            style: TextStyle(
                              color:  MyColors.taintedWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const Icon(Icons.star), // TODO continut
            ]
          ]) :
          ////////////////////////////////////////////////NEW TASK//////////////////////////////////////////////////
          getSelectedIndex() == 1 ?
            // TODO open new page
          GoalsPage() :
            ////////////////////////////////////////////////DAILY TASKS//////////////////////////////////////////////////
            DailyPage()
      ),
      floatingActionButton: SizedBox(
        width: 70.0,
        height: 70.0,
        child: FloatingActionButton(
          mini: false,
          backgroundColor:  MyColors.accentNormal,
          onPressed: () => {
            _onItemTapped(1),
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
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt), label: 'DAILY'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance), label: 'GOALS'),
              ],
              backgroundColor: MyColors.primaryNormal.withOpacity(0),
              currentIndex: _selectedIndex,
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
