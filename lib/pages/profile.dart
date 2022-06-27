import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:timeless/service/firebase_service.dart';

import '../model/goal.dart';
import '../model/goal_type.dart';
import '../model/user.dart';
import '../styles/styles.dart';
import 'drawer_page.dart';
import 'edit_profile_page.dart';

class Profile extends StatefulWidget {
  final isDarkTheme;
  Profile({Key? key, required this.isDarkTheme}) : super(key: key);

  @override
  State<Profile> createState() => ProfileStatefulWidgetState();
}

class ProfileStatefulWidgetState extends State<Profile> {
  late bool isDarkTheme;
  late UserData user;
  static List<Goal> goals = [];
  List<Goal> privateGoals = [];
  List<Goal> publicGoals = [];

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
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: MyColors.backgroundNormal.withOpacity(0),
                    elevation: 0,
                  ),
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
            child: Text(
              'Profile',
              style: TextStyle(
                  color: isDarkTheme == false ? MyColors.lightThemeTitle : MyColors.darkThemeTitle,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w900),
            ),
          ),

          actions: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: isDarkTheme == false ? MyColors.lightThemeTitle : MyColors.darkThemeTitle,
                size: 40.0,
              ),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                            userData: user,
                            isDarkTheme: isDarkTheme,
                          )),
                )
              },
            ), 
          ],

          elevation: 0,
        ),
        drawer: MainDrawer(pageId: 0, isDarkTheme: isDarkTheme,),
        body: StreamBuilder(
            stream: FirebaseService.firestore.collection('users').snapshots(),
            builder: (BuildContext context, AsyncSnapshot streamSnapshot) {
              if (streamSnapshot.hasData) {
                return FutureBuilder<UserData?>(
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
                                    child: Image.network(
                                      user.cover,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Align(
                                    alignment:
                                        AlignmentDirectional.bottomCenter,
                                    child: Stack(
                                      children: [
                                        FractionalTranslation(
                                          translation: Offset(0.0, 0.5),
                                          child: CircleAvatar(
                                            radius: 60,
                                            backgroundColor: Color(0xffF89D7D),
                                            child: CircleAvatar(
                                              radius: 55,
                                              backgroundColor:
                                                  Color(0xffF89D7D),
                                              backgroundImage: Image.network(
                                                      user.profilePicture)
                                                  .image,
                                            ),
                                          ),
                                        ),
                                      ],
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
                                    color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ]),

                              Container(
                                margin: EdgeInsets.only(
                                  top: 40.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          user.followers.length.toString(),
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w400,
                                            color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        Text(
                                          'Followers',
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w400,
                                            color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 100.0,),
                                    Column(
                                      children: [
                                        Text(
                                          user.following.length.toString(),
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w400,
                                            color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        Text(
                                          'Following',
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w400,
                                            color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(
                                  top: 80.0,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      (EnumToString.convertToString(
                                              user.gender) +
                                          " | Age " +
                                          userAge(user.birthDate)),
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w400,
                                        color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7.0,
                                    ),
                                    Text(
                                      ((user.city == null
                                              ? 'City'
                                              : user.city!) +
                                          ", " +
                                          (user.country == null
                                              ? 'Country'
                                              : user.country!)),
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w400,
                                        color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
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
                                color: isDarkTheme == false ? MyColors.lightThemeDivider : MyColors.darkThemeDivider,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 10.0,
                                ),
                                child: Text(
                                  'About Me',
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.normal,
                                    color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 4,
                                indent: 50,
                                endIndent: 50,
                                color: isDarkTheme == false ? MyColors.lightThemeDivider : MyColors.darkThemeDivider,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 5.0,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40.0, vertical: 10.0),
                                  child: Text(
                                    user.description == null
                                        ? 'Your Description Here...'
                                        : user.description!,
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.normal,
                                      color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 5,
                                indent: 50,
                                endIndent: 50,
                                color: isDarkTheme == false ? MyColors.lightThemeDivider : MyColors.darkThemeDivider,
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseService.getCurrentUserId)
                                      .collection('goals')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError)
                                      return Text('Something went wrong...');
                                    else if (snapshot.hasData) {
                                      goals = snapshot.data!.docs
                                          .map((DocumentSnapshot e) =>
                                              Goal.fromJson2(e))
                                          .toList();
                                      privateGoals = goals
                                          .where((goal) =>
                                              goal.type == GoalType.Private)
                                          .toList();
                                      publicGoals = goals
                                          .where((goal) =>
                                              goal.type == GoalType.Public)
                                          .toList();
                                      return Column(
                                        children: [
                                          Container(
                                            width: 330,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40.0),
                                            decoration: BoxDecoration(
                                              color: isDarkTheme == false ? MyColors.lightThemeOverBackground : MyColors.darkThemeOverBackground,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(7),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 1.0,
                                                  spreadRadius: 0.2,
                                                  offset: Offset(1.0,
                                                      1.0), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10.0),
                                                  child: Text(
                                                    'Goals',
                                                    style: TextStyle(
                                                      fontSize: 30.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: 5,
                                                  color: isDarkTheme == false ? MyColors.lightThemeDivider : MyColors.darkThemeDivider,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                                  child: ListView.separated(
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.all(8),
                                                    itemCount:
                                                        publicGoals.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Text(
                                                        publicGoals[index].name,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 25.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: isDarkTheme == false ? MyColors
                                                              .lightThemeText : MyColors.darkThemeText,
                                                          letterSpacing: 1,
                                                        ),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Divider(
                                                        thickness: 1,
                                                        color:
                                                            isDarkTheme == false ? MyColors.lightThemeDivider : MyColors.darkThemeDivider,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Container(
                                            width: 330,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40.0),
                                            decoration: BoxDecoration(
                                              color: isDarkTheme == false ? MyColors.lightThemeOverBackground : MyColors.darkThemeOverBackground,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(7),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 1.0,
                                                  spreadRadius: 0.2,
                                                  offset: Offset(1.0,
                                                      1.0), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10.0),
                                                  child: Text(
                                                    'Private Goals',
                                                    style: TextStyle(
                                                      fontSize: 30.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: 5,
                                                  color: isDarkTheme == false ? MyColors.lightThemeDivider : MyColors.darkThemeDivider,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                                  child: ListView.separated(
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.all(8),
                                                    itemCount:
                                                        privateGoals.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Text(
                                                        privateGoals[index]
                                                            .name,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 25.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: isDarkTheme == false ? MyColors
                                                              .lightThemeText : MyColors.darkThemeText,
                                                          letterSpacing: 1,
                                                        ),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Divider(
                                                        thickness: 1,
                                                        color:
                                                            isDarkTheme == false ? MyColors.lightThemeDivider : MyColors.darkThemeDivider,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      );
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Something went wrong! $snapshot');
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    });
              } else if (streamSnapshot.hasError) {
                Text('Something went wrong');
              }
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

  Widget buildUser(UserData user) => ListTile(
        leading: CircleAvatar(child: Text('${user.gender}')),
        title: Text(user.name),
        subtitle: Text(user.email),
      );

  Stream<List<UserData>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserData.fromJson(doc.data())).toList());

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
