import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeless/pages/newPersonProfile.dart';
import 'package:timeless/pages/profile.dart';
import 'package:timeless/pages/register.dart';

import '../model/user.dart';
import '../service/firebase_service.dart';
import '../styles/styles.dart';
import 'drawer_page.dart';

class NewFollowPage extends StatefulWidget {
  const NewFollowPage({Key? key}) : super(key: key);

  @override
  State<NewFollowPage> createState() => NewFollowPageState();
}

class NewFollowPageState extends State<NewFollowPage> {
  TextEditingController _controller = TextEditingController();
  var textEmail = '';
  int selectedDailyIndex = 0;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().backgroundNormal,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              child: TextField(
                controller: _controller,
                cursorColor: MyColors().textNormal,
                style: TextStyle(color: MyColors().textNormal),
                onChanged: (text) => setState(() => textEmail),
                decoration: InputDecoration(
                  labelText: 'Search By Email',
                  errorText: _submitted ? _errorText : null,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: MyColors().primaryNormal.withOpacity(0.7),
                        width: 1.5),
                  ),
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    color: MyColors().primaryNormal,
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: readUser(),
              builder: (context, snapshot) {
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
                      setState(() {
                        _submitted = true;
                      }),
                      if (_controller.value.text.isNotEmpty) {_submit()}
                    },
                    child: Text(
                      'Search',
                      style: TextStyle(
                          fontSize: 20.0, color: MyColors().highlightedFilterText),
                    ),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> readUser() async {
    final docUser = FirebaseService.firestore
        .collection('users')
        .doc(FirebaseService.getCurrentUserId);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return UserData.fromJson(snapshot.data()!).email;
    }
    return null;
  }

  Future<void> _submit() async {
    // if there is no error text
    if (_errorText == null) {
      final user = await FirebaseService.getUserByEmail(_controller.text);
      if (user == null) {
        Utils.showSnackBar('User with the specified email address not found');
      } else {
        final isFollowing = await FirebaseService.isFollowedBy(user.id);
        final auxEmail = await FirebaseService.getCurrentUserEmail();
        if (_controller.text == auxEmail) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Profile();
          }));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NewPersonProfile(
              user: user,
              followIndex: isFollowing == true ? 1 : 0,
            );
          } //_controller.text)),
              ));
        }
      }
    }
  }

  String? get _errorText {
    final text = _controller.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (!emailValidator(text)) {
      return 'Invalid email';
    }
    return null;
  }

  bool emailValidator(String text) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(text);
  }
}
