import 'package:flutter/material.dart';
import 'package:timeless/pages/friendProfile.dart';
import 'package:timeless/pages/newPersonProfile.dart';
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
      backgroundColor: MyColors().backgroundNormal,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: EdgeInsets.all(60),
            height: 300,
            decoration: BoxDecoration(
              color: MyColors().primaryDarkest, // F89D7D
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  }, // Image tapped
                  child: CircleAvatar(
                    backgroundColor: MyColors().accentNormal,
                    radius: 50.0,
                    child: CircleAvatar(
                      radius: 48.5,
                      backgroundImage: AssetImage('assets/images/NFT.jpeg'),
                    ),
                  )
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 5.0,
                  ),
                  child: Text(
                    'Your Name Here',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MyColors().lightGray,
                      fontFamily: 'OpenSans',
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              'Home',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors().textNormal,
                fontSize: 20,
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
            color: Color(0xff4B5052).withOpacity(0.5),
          ),

          ListTile(
            title: Text(
              'Friends',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors().textNormal,
                fontSize: 20,
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
            color: Color(0xff4B5052).withOpacity(0.2),
          ),
          ListTile(
            title: Text(
              'Settings',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors().textNormal,
                fontSize: 20,
                fontFamily: 'OpenSans',
              ),
            ),
            onTap: () {
              if (pageId != 3) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              }
            },
          ),

          ListTile(
            title: Text(
              'test',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors().textNormal,
                fontSize: 20,
                fontFamily: 'OpenSans',
              ),
            ),
            onTap: () {
              if (pageId != 4) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FriendProfile()),
                );
              }
            },
          ),

        ],
      ),
    );
  }
}
