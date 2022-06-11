import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeless/main.dart';
import 'package:timeless/pages/login.dart';

import '../styles/styles.dart';
import 'drawer_page.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => SettingsStatefulWidgetState();
}

class SettingsStatefulWidgetState extends State<Settings> {
  bool isDarkTheme = false;

  // @override
  // void initState() {
  //   _incrementStartup();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().backgroundNormal,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => Center(
            child: RaisedButton(
                color: MyColors().backgroundNormal.withOpacity(0),
                elevation: 0,
                onPressed: () => Scaffold.of(context).openDrawer(),
                child: Icon(
                  Icons.widgets,
                  size: 30.0,
                  color: MyColors().primaryTitle,
                )),
          ),
        ),

        backgroundColor: MyColors().backgroundNormal.withOpacity(0),
        // Colors.transparent,

        title: Center(
          child: Text(
            'Settings',
            style: TextStyle(
                color: MyColors().primaryTitle,
                fontSize: 25.0,
                fontWeight: FontWeight.w900),
          ),
        ),

        actions: [
          Icon(
            Icons.widgets,
            color: MyColors().backgroundNormal,
            size: 50.0,
          ),
        ],

        elevation: 0,
      ),
      drawer: MainDrawer(pageId: 3),
      body: Column(
        children: [
          SizedBox(height: 40.0),
          Container(
            decoration: BoxDecoration(
              color: MyColors().overBackground,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dark Theme',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: MyColors().textNormal,
                            letterSpacing: 1,
                          ),
                        ),
                        Switch(
                            value: isDarkTheme,
                            onChanged: (value) {
                              setState(() {
                                if (isDarkTheme == false)
                                  isDarkTheme = true;
                                else if (isDarkTheme == true)
                                  isDarkTheme = false;
                                MyColors().setDarkTheme(isDarkTheme);
                                print(isDarkTheme);
                              });
                            }),
                        // FutureBuilder(
                        //   future: setThemeStyles(),
                        //     builder: (context, AsyncSnapshot snapshot) {
                        //
                        //   if (!snapshot.hasData && isDarkTheme != null)
                        //     return Switch(
                        //       value: isDarkTheme!,
                        //       onChanged: (value) {
                        //         setState(() {
                        //           if (isDarkTheme == false)
                        //             isDarkTheme = true;
                        //           else if (isDarkTheme == true)
                        //             isDarkTheme = false;
                        //           setThemeStyles();
                        //         });
                        //       },
                        //     );
                        //   else if (snapshot.hasError) {
                        //     return Center(child: Text('Something went wrong'));
                        //   }
                        //   return CircularProgressIndicator();
                        // }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.0),
          GestureDetector(
            onTap: _about,
            child: Container(
              decoration: BoxDecoration(
                color: MyColors().overBackground,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'About',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: MyColors().textNormal,
                              letterSpacing: 1,
                            ),
                          ),
                          Icon(
                            Icons.info_outline,
                            color: MyColors().textNormal,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 3.0),
          GestureDetector(
            onTap: _help,
            child: Container(
              decoration: BoxDecoration(
                color: MyColors().overBackground,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Help',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: MyColors().textNormal,
                              letterSpacing: 1,
                            ),
                          ),
                          Icon(
                            Icons.help_outline,
                            color: MyColors().textNormal,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 3.0),
          GestureDetector(
            onTap: _logout,
            child: Container(
              decoration: BoxDecoration(
                color: MyColors().overBackground,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: MyColors().textNormal,
                              letterSpacing: 1,
                            ),
                          ),
                          Icon(
                            Icons.logout,
                            color: MyColors().textNormal,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> _incrementStartup() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final startupBool = prefs.getBool('option');
  //   if (startupBool == null) {
  //     await prefs.setBool('option', false);
  //   }
  //   MyColors().darkThemeStyles = false;
  //   print("lastStartupBool: " + isDarkTheme.toString());
  //   isDarkTheme = startupBool != null ? startupBool : false;
  // }
  //
  // Future<void> setThemeStyles() async {
  //   print("isDarkTheme: " + isDarkTheme.toString());
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('option', isDarkTheme!);
  //   MyColors().setDarkTheme(true);
  //   print("darkThemeStyles: " + MyColors().darkThemeStyles.toString());
  // }
  //
  // Future<bool> getThemeFromSharedPref() async{
  //   final prefs = await SharedPreferences.getInstance();
  //   final startupBool = prefs.getBool('option');
  //   if (startupBool == null) {
  //     return false;
  //   }
  //   return startupBool;
  // }

  void _logout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
    FirebaseAuth.instance.signOut();
  }

  void _help() {
    print('help');
  }

  void _about() {
    print('about');
  }
}
