import 'package:flutter/material.dart';

import '../styles/styles.dart';
import 'add_new_follower_page.dart';
import 'drawer_page.dart';
import 'follow_page.dart';

class FriendsPage extends StatefulWidget {
  final isDarkTheme;
  const FriendsPage({Key? key, required this.isDarkTheme}) : super(key: key);

  @override
  State<FriendsPage> createState() => FriendsStatefulWidgetState();
}

class FriendsStatefulWidgetState extends State<FriendsPage> {
  late bool isDarkTheme;
  int selectedFriendsIndex = 0;

  static TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  late List<Widget> widgetFriendsOptions = <Widget>[
    Text(
      'FOLLOWING',
      style: TextStyle(
          color: isDarkTheme == false ? MyColors.lightThemeTitle : MyColors.darkThemeTitle,
          fontSize: 25.0,
          fontWeight: FontWeight.w900),
    ),
    Text(
      'FOLLOWERS',
      style: TextStyle(
          color: isDarkTheme == false ? MyColors.lightThemeTitle : MyColors.darkThemeTitle,
          fontSize: 25.0,
          fontWeight: FontWeight.w900),
    ),
    Text(
      'FOLLOW PEOPLE',
      style: TextStyle(
          color: isDarkTheme == false ? MyColors.lightThemeTitle : MyColors.darkThemeTitle,
          fontSize: 25.0,
          fontWeight: FontWeight.w900),
    ),
  ];

  void _onFriendsItemTapped(int index) {
    setState(() {
      selectedFriendsIndex = index;
    });
  }

  @override
  void initState() {
    isDarkTheme = widget.isDarkTheme == null ? false : widget.isDarkTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme == false ? MyColors.lightThemeBackground : MyColors.darkThemeBackground,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => Center(
            child: RaisedButton(
                color: MyColors.backgroundNormal.withOpacity(0),
                elevation: 0,
                onPressed: () => Scaffold.of(context).openDrawer(),
                child: Icon(
                  Icons.widgets,
                  size: 30.0,
                  color: isDarkTheme == false ? MyColors.lightThemeTitle : MyColors.darkThemeTitle,
                )),
          ),
        ),

        backgroundColor: MyColors.backgroundNormal.withOpacity(0),
        // Colors.transparent,

        title: Center(
          child: widgetFriendsOptions.elementAt(selectedFriendsIndex),
        ),

        actions: [
          Icon(
            Icons.widgets,
            color: isDarkTheme == false ? MyColors.lightThemeBackground : MyColors.darkThemeBackground,
            size: 50.0,
          ),
        ],

        elevation: 0,
      ),

      drawer: MainDrawer(pageId: 2, isDarkTheme: isDarkTheme,),

      body: (selectedFriendsIndex == 0 || selectedFriendsIndex == 1) ? FollowPage(selectedFriendsIndex: selectedFriendsIndex, isDarkTheme: isDarkTheme,) : NewFollowPage(isDarkTheme: isDarkTheme,),


      bottomNavigationBar: Container(
          margin: EdgeInsets.only(
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
                Radius.circular(15.0),),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0)
            ),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.group), label: 'FOLLOWING'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.group_outlined), label: 'FOLLOWERS'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.group_add), label: 'FOLLOW PEOPLE'),
              ],
              backgroundColor: MyColors.primaryNormal.withOpacity(0),
              currentIndex: selectedFriendsIndex,
              selectedItemColor: Color(0xffffffff),
              // 0xffEEF0F0
              unselectedItemColor: Color(0xffC2C6D5),
              onTap: _onFriendsItemTapped,
              elevation: 0,
            ),
          )),
    );
  }
}


