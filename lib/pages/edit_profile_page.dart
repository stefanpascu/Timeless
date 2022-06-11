import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeless/model/user.dart';
import 'package:timeless/service/firebase_service.dart';

import '../model/goal.dart';
import '../styles/styles.dart';

class EditProfilePage extends StatefulWidget {
  final UserData userData;

  EditProfilePage({Key? key, required this.userData}) : super(key: key);

  @override
  State<EditProfilePage> createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  bool _submitted = false;
  late Goal goal;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerCity = TextEditingController();
  TextEditingController _controllerCountry = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();
  var _textName = '';
  var _textCity = '';
  var _textCountry = '';
  var _textDescription = '';
  int selectedDailyIndex = 0;
  @override
  void initState() {
    _controllerDescription.text = widget.userData.description == null ? '' : widget.userData.description!;
    _controllerCity.text = widget.userData.city == null ? '' : widget.userData.city!;
    _controllerCountry.text = widget.userData.country == null ? '' : widget.userData.country!;
    _controllerName.text = widget.userData.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().backgroundNormal,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: MyColors().primaryTitle,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: MyColors().backgroundNormal.withOpacity(0),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'EDIT',
            style: TextStyle(
              color: MyColors().primaryTitle,
              fontSize: 25.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(
              Icons.delete,
              color: MyColors().backgroundNormal,
              size: 50.0,
            ),
          ),
        ],
        elevation: 0,
      ),
      body: FutureBuilder<UserData?>(
        future: readUser(),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(children: [
              Container(
                  child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    child: TextField(
                      controller: _controllerName,
                      cursorColor: MyColors().textNormal,
                      style: TextStyle(color: MyColors().textNormal),
                      onChanged: (text) => setState(() => _textName),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        errorText: _submitted ? _errorNameText : null,
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    child: TextField(
                      controller: _controllerCity,
                      cursorColor: MyColors().textNormal,
                      style: TextStyle(color: MyColors().textNormal),
                      onChanged: (text) => setState(() => _textCity),
                      decoration: InputDecoration(
                        labelText: 'City',
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    child: TextField(
                      controller: _controllerCountry,
                      cursorColor: MyColors().textNormal,
                      style: TextStyle(color: MyColors().textNormal),
                      onChanged: (text) => setState(() => _textCountry),
                      decoration: InputDecoration(
                        labelText: 'Country',
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    child: TextField(
                      controller: _controllerDescription,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      cursorColor: MyColors().textNormal,
                      style: TextStyle(color: MyColors().textNormal),
                      onChanged: (text) => setState(() => _textDescription),
                      decoration: InputDecoration(
                        labelText: 'Description',
                        errorText: _errorDescriptionText,
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
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
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
                        if (_controllerName.value.text.isNotEmpty) {_submit()}
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: MyColors().highlightedFilterText),
                      ),
                    ),
                  ),
                ],
              )),
            ]),
          );
        },
      ),
    );
  }

  Future<void> _submit() async {
    // if there is no error text
    widget.userData.description = _controllerDescription.text == '' ? null : _controllerDescription.text;
    widget.userData.city = _controllerCity.text == '' ? null : _controllerCity.text;
    widget.userData.country = _controllerCountry.text == '' ? null : _controllerCountry.text;
    widget.userData.name = _controllerName.text;

    if (_errorNameText == null && _errorDescriptionText == null) {
      FirebaseService.editProfileData(widget.userData);
      Navigator.pop(context);
    }
  }

  String? get _errorNameText {
    final text = _controllerName.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    return null;
  }

  String? get _errorDescriptionText {
    final text = _controllerDescription.value.text;
    if (text.length > 200) return 'Text too long (max. 200 characters)';
    return null;
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
}
