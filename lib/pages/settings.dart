import 'package:flutter/material.dart';
import 'package:timeless/pages/profile.dart';

import '../styles/styles.dart';
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

      drawer: Drawer(
        backgroundColor:  MyColors.taintedWhite,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.all(60),
              height: 220,
              decoration: const BoxDecoration(
                color: MyColors.taintedWhite, // F89D7D
              ),
              child: Column(
                children: [
                  FloatingActionButton(onPressed: () => {
                    Navigator.pop(context),
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()),),
                  },),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0,),
                    child: const Text('Your Name Here', textAlign: TextAlign.center, style: TextStyle(
                      fontSize: 20.0,
                    ),),
                  ),
                ],
              ),
            ),

            ListTile(
              title: const Text('Home', textAlign: TextAlign.center,),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()),);
              },
            ),
            ListTile(
              title: const Text('Friends', textAlign: TextAlign.center,),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FriendsPage()),);
              },
            ),
            ListTile(
              title: const Text('Settings', textAlign: TextAlign.center,),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()),);
              },
            ),
            ListTile(
              title: const Text('Logout', textAlign: TextAlign.center,),
              onTap: () {
                // Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()),);
              },
            ),
          ],
        ),
      ),


    );
  }
}