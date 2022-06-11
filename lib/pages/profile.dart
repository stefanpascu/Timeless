import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:timeless/service/firebase_service.dart';

import '../model/user.dart';
import '../styles/styles.dart';
import 'drawer_page.dart';
import 'edit_profile_page.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => ProfileStatefulWidgetState();
}

class ProfileStatefulWidgetState extends State<Profile> {
  late UserData user;

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
              'Profile',
              style: TextStyle(
                  color: MyColors().primaryTitle,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w900),
            ),
          ),

          actions: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: MyColors().primaryTitle,
                size: 40.0,
              ),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                            userData: user,
                          )),
                )
              },
            ), // , color:  MyColors().primaryTitle, size: 40.0,
          ],

          elevation: 0,
        ),
        drawer: MainDrawer(pageId: 0),
        body: FutureBuilder<UserData?>(
            future: readUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                user = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          AspectRatio(
                            aspectRatio: 2,
                            child: Image.asset(
                              'assets/images/Ragnar_Wallpaper.jpg',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.bottomCenter,
                            child: SizedBox(
                              height: 120,
                              width: 100,
                              child: Stack(
                                children: const [
                                  FractionalTranslation(
                                    translation: Offset(0.0, 0.5),
                                    child: SizedBox(
                                      height: 150,
                                      width: 100,
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Color(0xffF89D7D),
                                        child: CircleAvatar(
                                          radius: 48,
                                          backgroundColor: Color(0xffF89D7D),
                                          backgroundImage: AssetImage(
                                              'assets/images/NFT.jpeg'),
                                        ),
                                      ),
                                      // Image.asset(
                                      //   'assets/images/Tux.png',),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60.0,
                      ),
                      Column(children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            color: MyColors().textNormal,
                            fontSize: 40.0,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          user.email,
                          style: TextStyle(
                            color: MyColors().textNormal,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ]),
                      Container(
                        margin: EdgeInsets.only(
                          top: 60.0,
                        ),
                        child: Column(
                          children: [
                            Text(
                              (EnumToString.convertToString(user.gender) +
                                  " | Age " +
                                  userAge(user.birthDate)),
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400,
                                color: MyColors().textNormal,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Text(
                              (EnumToString.convertToString(user.gender) +
                                  ", " +
                                  userAge(user.birthDate)),
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400,
                                color: MyColors().textNormal,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                            )
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 4,
                        indent: 150,
                        endIndent: 150,
                        color: MyColors().divider,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: Text(
                          'About Me',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w300,
                            color: MyColors().textNormal,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 4,
                        indent: 50,
                        endIndent: 50,
                        color: MyColors().divider,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 5.0,
                        ),
                        child: Text(
                          'Your description will be here...',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w300,
                            color: MyColors().textNormal,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 5,
                        indent: 50,
                        endIndent: 50,
                        color: MyColors().divider,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 20.0),
                        child: Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 40.0),
                            decoration: BoxDecoration(
                              color: MyColors().overBackground,
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 1.0,
                                  spreadRadius: 0.2,
                                  offset: Offset(
                                      1.0, 1.0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    'Goals',
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w500,
                                      color: MyColors().textNormal,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 5,
                                  color: MyColors().divider,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    'Public Goal 1',
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w300,
                                      color: MyColors().textNormal,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 20.0),
                        child: Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 40.0),
                            decoration: BoxDecoration(
                              color: MyColors().overBackground,
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 1.0,
                                  spreadRadius: 0.2,
                                  offset: Offset(
                                      1.0, 1.0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    'Private Goals',
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w500,
                                      color: MyColors().textNormal,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 5,
                                  color: MyColors().divider,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    'Private Goal 1',
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w300,
                                      color: MyColors().textNormal,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                print(snapshot);
                return Text('Something went wrong! $snapshot');
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            }));
  }

  String userAge(DateTime dateOfBirth) {
    DateTime now = DateTime.now();
    int birthYear =
        int.parse(dateOfBirth.toString().split(' ')[0].split('-')[0]);
    int birthMonth =
        int.parse(dateOfBirth.toString().split(' ')[0].split('-')[1]);
    int birthDay =
        int.parse(dateOfBirth.toString().split(' ')[0].split('-')[2]);
    int nowYear = int.parse(now.toString().split(' ')[0].split('-')[0]);
    int nowMonth = int.parse(now.toString().split(' ')[0].split('-')[1]);
    int nowDay = int.parse(now.toString().split(' ')[0].split('-')[2]);

    if (nowMonth >= birthMonth && nowDay >= birthDay)
      return (nowYear - birthYear).toString();
    return (nowYear - birthYear - 1).toString();
  }

  Widget buildUser(NewUser user) => ListTile(
        leading: CircleAvatar(child: Text('${user.gender}')),
        title: Text(user.name),
        subtitle: Text(user.email),
      );

  Stream<List<NewUser>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => NewUser.fromJson(doc.data())).toList());

  Future<UserData?> readUser() async {
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseService.getCurrentUserId);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return UserData.fromJson(snapshot.data()!);
    }
    return null;
  }
}
