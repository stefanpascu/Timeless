import 'package:flutter/material.dart';
import 'package:timeless/pages/profile.dart';

import '../styles/styles.dart';
import 'drawer_page.dart';
import 'friends_page.dart';
import 'home_page.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => SettingsStatefulWidgetState();
}

class SettingsStatefulWidgetState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading:
        Builder(
          builder: (context) =>
              Center(
                child: RaisedButton(
                    color:  MyColors.taintedWhite.withOpacity(0),
                    elevation: 0,
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    child: const Icon(
                      Icons.widgets,
                      size: 30.0,
                      color: MyColors.primaryDarkest,
                    )
                ),
              ),
        ),

        backgroundColor:  MyColors.taintedWhite.withOpacity(0), // Colors.transparent,

        title: const Center(
          child: Text(
            'Settings',
            style: TextStyle(
                color: MyColors.primaryDarkest,
                fontSize: 25.0,
                fontWeight: FontWeight.w900),
          ),
        ),

        actions: const [
          Icon(Icons.widgets, color:  MyColors.taintedWhite, size: 50.0,),
        ],

        elevation: 0,
      ),

      drawer: MainDrawer(pageId: 3),

    );
  }
}