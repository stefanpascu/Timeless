import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/goal.dart';
import '../model/goal_type.dart';
import '../styles/styles.dart';

class EditProfilePage extends StatefulWidget {
  final int? id;

  EditProfilePage({Key? key, this.id}) : super(key: key);

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
      body: SingleChildScrollView(
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
                padding:
                EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                child: TextField(
                  controller: _controllerDescription,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  cursorColor: MyColors().textNormal,
                  style: TextStyle(
                      color: MyColors().textNormal
                  ),
                  onChanged: (text) => setState(() => _textDescription),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    errorText: _submitted ? _errorDescriptionText : null,
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
      ),
    );
  }

  void _submit() {
    // if there is no error text
    if (_errorNameText == null && _errorDescriptionText == null) {

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
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length > 60)
      return 'Text too long (max. 60 characters)';
    return null;
  }

}
