import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import '../model/goal.dart';
import '../model/goal_type.dart';
import '../model/user.dart';
import '../service/firebase_service.dart';
import '../styles/styles.dart';
import 'drawer_page.dart';

class NewPersonProfile extends StatefulWidget {
  final UserData user;
  int followIndex;

  NewPersonProfile({Key? key, required this.user, required this.followIndex})
      : super(key: key);

  @override
  State<NewPersonProfile> createState() => NewPersonProfileState();
}

class NewPersonProfileState extends State<NewPersonProfile> {
  late UserData user = widget.user;
  static List<Goal> goals = [];
  List<Goal> publicGoals = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors().backgroundNormal,
        appBar: AppBar(
          leading: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: MyColors().backgroundNormal.withOpacity(0),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context), // Scaffold.of(context).openDrawer(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 30.0,
                    color: MyColors().primaryTitle,
                  )),
            ),
          ),

          backgroundColor: MyColors().backgroundNormal.withOpacity(0),
          // Colors.transparent,

          title: Center(
            child: Text(
              'New Person\'s Profile',
              style: TextStyle(
                  color: MyColors().primaryTitle,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w900),
            ),
          ),

          actions: [
            Icon(
              Icons.edit,
              color: MyColors().backgroundNormal,
              size: 50.0,
            ), // , color:  MyColors().primaryTitle, size: 40.0,
          ],

          elevation: 0,
        ),
        // drawer: MainDrawer(pageId: 0),
        body: SingleChildScrollView(
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
                    alignment: AlignmentDirectional.bottomCenter,
                    child: Stack(
                      children: [
                        FractionalTranslation(
                          translation: Offset(0.0, 0.5),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Color(0xffF89D7D),
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Color(0xffF89D7D),
                              backgroundImage:
                                  Image.network(user.profilePicture).image,
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
                    color: MyColors().textNormal,
                    fontSize: 40.0,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  user.email,
                  style: TextStyle(
                    color: MyColors().textNormal,
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
                            color: MyColors().textNormal,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          'Followers',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w400,
                            color: MyColors().textNormal,
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
                            color: MyColors().textNormal,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          'Following',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w400,
                            color: MyColors().textNormal,
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
                      ((user.city == null ? 'City' : user.city!) +
                          ", " +
                          (user.country == null ? 'Country' : user.country!)),
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
                    fontWeight: FontWeight.normal,
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
                      color: MyColors().textNormal,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              Divider(
                thickness: 5,
                indent: 50,
                endIndent: 50,
                color: MyColors().divider,
              ),
              SizedBox(
                height: 30.0,
              ),
              FutureBuilder<List<Goal>>(
                  future: readGoal(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      goals = snapshot.data!;
                      return widget.followIndex == 1
                          ? buildGoalsField(goals)
                          : Container();
                    } else if (snapshot.hasError) {
                      return Text('Something went wrong! \nerror: ' + snapshot.error.toString());
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
              SizedBox(
                height: 30.0,
              ),
              widget.followIndex == 0
                  ? buildButton('Follow')
                  : buildButton('Unfollow'),
              SizedBox(
                height: 30.0,
              )
            ],
          ),
        ));
  }

  Future<List<Goal>> readGoal() async {
    final snapshot = await FirebaseService.firestore
        .collection('users')
        .doc(user.id)
        .collection('goals').get();
    List<Goal> list = (await snapshot.docs.map((e) => Goal.fromJson(e.data())).toList());
    return list;
  }

  Widget buildGoalsField(List<Goal> goals) {
    publicGoals = goals
        .where((goal) =>
    goal.type == GoalType.Public)
        .toList();
    return Container(
        width: 330,
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
              offset: Offset(1.0, 1.0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
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
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.all(8),
                itemCount: publicGoals.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    publicGoals[index].name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.normal,
                      color: MyColors().textNormal,
                      letterSpacing: 1,
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    thickness: 1,
                    color: MyColors().divider,
                  );
                },
              ),
            ),
          ],
        ));
  }

  Widget buildButton(String label) {
    return SizedBox(
      width: 150.0,
      height: 45.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: MyColors().accentNormal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          shadowColor: Colors.grey,
          elevation: 2.5,
          side: BorderSide(
            width: 0.8,
            color: MyColors().lightGray,
          ),
        ),
        onPressed: () => {
          if (widget.followIndex == 0)
            addFollower(user.id)
          else
            removeFollower(user.id)
        },
        child: Text(
          label,
          style: TextStyle(
              fontSize: 20.0, color: MyColors().highlightedFilterText),
        ),
      ),
    );
  }

  Future<void> addFollower(String id) async {
    FirebaseService.addFollower(id);
    Navigator.pop(context);
  }

  Future<void> removeFollower(String id) async {
    FirebaseService.removeFollower(id);
    Navigator.pop(context);
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
