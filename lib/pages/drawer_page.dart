import 'package:flutter/material.dart';
import 'package:timeless/pages/profile.dart';
import 'package:timeless/pages/register.dart';
import 'package:timeless/pages/settings.dart';

import '../styles/styles.dart';
import 'friends_page.dart';
import 'home_page.dart';

class MainDrawer extends StatelessWidget {
  final int? pageId;

  MainDrawer({
    Key? key,
    this.pageId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: MyColors.taintedWhite,
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
                    if(pageId != 0) {
                      Navigator.pop(context),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Profile()),
                      ),
                    }
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
              if (pageId != 1) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }
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
              if (pageId != 2) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FriendsPage()),
                );
              }
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
              if(pageId != 3) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              }
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
    );
  }
}
