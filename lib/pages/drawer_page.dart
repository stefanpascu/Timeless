import 'package:flutter/material.dart';
import 'package:timeless/pages/profile.dart';
import 'package:timeless/pages/settings_page.dart';
import 'package:timeless/service/firebase_service.dart';

import '../model/user.dart';
import '../styles/styles.dart';
import 'friends_page.dart';
import 'home_page.dart';

class MainDrawer extends StatelessWidget {
  late UserData user;
  final int? pageId;
  final isDarkTheme;

  MainDrawer({
    Key? key,
    this.pageId,
    required this.isDarkTheme
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: isDarkTheme == false ? MyColors.lightThemeBackground : MyColors.darkThemeBackground,
      child: FutureBuilder<UserData?>(
          future: readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              user = snapshot.data!;
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    padding: EdgeInsets.all(60),
                    height: 300,
                    decoration: BoxDecoration(
                      color: MyColors.primaryDarkest, // F89D7D
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile(isDarkTheme: isDarkTheme,)),
                              );
                            }, // Image tapped
                            child: CircleAvatar(
                              backgroundColor: MyColors.accentNormal,
                              radius: 50.0,
                              child: CircleAvatar(
                                radius: 48.5,
                                backgroundImage:
                                    Image.network(user.profilePicture).image,
                              ),
                            )),
                        Container(
                          margin: EdgeInsets.only(
                            top: 5.0,
                          ),
                          child: Text(
                            user.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: MyColors.lightGray,
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
                      'Tasks & Goals',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                        fontSize: 20,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    onTap: () {
                      if (pageId != 1) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage()),
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
                      'Social',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                        fontSize: 20,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    onTap: () {
                      if (pageId != 2) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FriendsPage(isDarkTheme: isDarkTheme,)),
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
                      'Settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                        fontSize: 20,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    onTap: () {
                      if (pageId != 3) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Settings()),
                        );
                      }
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              print(snapshot);
              return Text('Something went wrong! $snapshot');
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Future<UserData?> readUser() async {
    final docUser = FirebaseService.firestore
        .collection('users')
        .doc(FirebaseService.getCurrentUserId);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return UserData.fromJson(snapshot.data()!);
    }
    return null;
  }

}
