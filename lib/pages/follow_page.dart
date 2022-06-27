import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeless/model/user.dart';
import 'package:timeless/pages/newPersonProfile.dart';
import 'package:timeless/service/firebase_service.dart';

import '../styles/styles.dart';

class FollowPage extends StatefulWidget {
  final isDarkTheme;
  FollowPage({Key? key, required this.selectedFriendsIndex, required this.isDarkTheme}) : super(key: key);

  int selectedFriendsIndex;

  @override
  State<FollowPage> createState() => FollowPageState();
}

class FollowPageState extends State<FollowPage> {
  late bool isDarkTheme;
  UserData? user;
  String searchString = "";
  Future<List<UserData>>? followersList;
  Future<List<UserData>>? followingList;

  @override
  void initState() {
    isDarkTheme = widget.isDarkTheme == null ? false : widget.isDarkTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme == false ? MyColors.lightThemeBackground : MyColors.darkThemeBackground,
      body: FutureBuilder<UserData?>(
          future: readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              user = snapshot.data!;
              followersList = fetchFollowers();
              followingList = fetchFollowing();
              return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchString = value.toLowerCase();
                          });
                        },
                        cursorColor: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                        style: TextStyle(color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText),
                        decoration: InputDecoration(
                          labelText: 'Search',
                          labelStyle: TextStyle(
                            color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    MyColors.primaryNormal.withOpacity(0.7),
                                width: 1.5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: FutureBuilder(
                        future: widget.selectedFriendsIndex == 0
                            ? followingList
                            : followersList,
                        builder:
                            (context, AsyncSnapshot<List<UserData>> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.separated(
                              padding: EdgeInsets.all(8),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return snapshot.data![index].email
                                        .toLowerCase()
                                        .contains(searchString)
                                    ? OutlinedButton(
                                      onPressed: () async {
                                        final isFollowing = await FirebaseService.isFollowedBy(snapshot.data![index].id);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NewPersonProfile(user: snapshot.data![index], followIndex: widget.selectedFriendsIndex == 0 ? 1 : isFollowing == true ? 1 : 0, isDarkTheme: isDarkTheme,)),
                                        );
                                      },
                                      child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: snapshot.data != null
                                                ? Image.network(
                                                    snapshot.data![index].profilePicture)
                                                    .image
                                                : Image.network(
                                                        'https://firebasestorage.googleapis.com/v0/b/timeless-35302.appspot.com/o/Portrait_Placeholder%5B1%5D.png?alt=media&token=34332fa9-9bfc-4a5b-9f0f-77ba0ec387f2')
                                                    .image,
                                          ),
                                          title: Text(
                                            '${snapshot.data?[index].email}',
                                            style: TextStyle(
                                                color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                                                fontSize: 17.0,
                                                fontFamily: 'OpenSans'),
                                          ),
                                        ),
                                    )
                                    : Container();
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return snapshot.data![index].email
                                        .toLowerCase()
                                        .contains(searchString)
                                    ? Divider()
                                    : Container();
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Something went wrong!\n error: ' +
                                    snapshot.error.toString()));
                          }
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                  ]);
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
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseService.getCurrentUserId);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return UserData.fromJson(snapshot.data()!);
    }
    return null;
  }

  Future<List<UserData>> fetchFollowing() async {
    if (user == null) return [];
    List<String> auxListString = user!.following;
    return await FirebaseService.followList(auxListString);
  }

  Future<List<UserData>> fetchFollowers() async {
    if (user == null) return [];
    List<String> auxListString = user!.followers;
    return await FirebaseService.followList(auxListString);
  }
}
