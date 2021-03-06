import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeless/model/gender_type.dart';
import 'package:timeless/model/user.dart';
import 'package:timeless/service/firebase_service.dart';

import '../main.dart';
import '../styles/styles.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key, this.restorationId}) : super(key: key);

  final String? restorationId;

  @override
  State<Register> createState() => RegisterStatefulWidgetState();
}

class RegisterStatefulWidgetState extends State<Register>
    with RestorationMixin {
  bool isDarkTheme = false;
  UserData? userData;
  String nullDateTime = '1800-01-01 00:00';
  bool _selectedBirthDate = false;
  bool _submitted = false;
  Color dateBorderColor = MyColors.primaryNormal.withOpacity(0.7);
  final _controllerName = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  var _textName = '';
  var _textEmail = '';
  var _textPassword = '';
  late String formattedDate = "Select Birth Date";
  late DateTime _controllerBirthDate = DateTime.parse(nullDateTime);
  String dropdownValue = GenderType.Male.name;

  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime(
      int.parse(DateTime.now().toString().split(" ")[0].split("-")[0]),
      int.parse(DateTime.now().toString().split(" ")[0].split("-")[1]),
      int.parse(DateTime.now().toString().split(" ")[0].split("-")[2])));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              MyColors.primaryNormal.withOpacity(0.2),
              MyColors.primaryNormal.withOpacity(0.5),
              MyColors.accentNormal.withOpacity(0.5),
              MyColors.accentNormal.withOpacity(0.2),
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: isDarkTheme == false ? MyColors.lightThemeBackground.withOpacity(0.5) : MyColors.darkThemeBackground.withOpacity(0.5),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(7),
                            ),
                            border: Border(
                              top: BorderSide(
                                  width: 3.0,
                                  color: MyColors
                                      .primaryNormal
                                      .withOpacity(0.7)),
                              left: BorderSide(
                                  width: 3.0,
                                  color: MyColors
                                      .primaryNormal
                                      .withOpacity(0.7)),
                              right: BorderSide(
                                  width: 3.0,
                                  color: MyColors
                                      .primaryNormal
                                      .withOpacity(0.7)),
                              bottom: BorderSide(
                                  width: 3.0,
                                  color: MyColors
                                      .primaryNormal
                                      .withOpacity(0.7)),
                            ),
                          ),
                          child: Container(
                            margin:
                                const EdgeInsets.only(top: 0.0, bottom: 0.0),
                            width: 350.0,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 80,
                                    left: 40,
                                    right: 40,
                                  ),
                                  child: TextField(
                                    controller: _controllerName,
                                    cursorColor: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                                    style:
                                        TextStyle(color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText),
                                    onChanged: (text) =>
                                        setState(() => _textName),
                                    decoration: InputDecoration(
                                      labelText: 'Full Name',
                                      errorText:
                                          _submitted ? _errorNameText : null,
                                      enabledBorder: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderSide: BorderSide(
                                            color: MyColors
                                                .primaryNormal
                                                .withOpacity(0.7),
                                            width: 1.5),
                                      ),
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(
                                        color:
                                        isDarkTheme == false ? MyColors.primaryNormal : MyColors.darkThemeText.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16,
                                    left: 40,
                                    right: 40,
                                  ),
                                  child: TextField(
                                    controller: _controllerEmail,
                                    cursorColor: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                                    onChanged: (text) =>
                                        setState(() => _textEmail),
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      errorText:
                                          _submitted ? _errorEmailText : null,
                                      enabledBorder: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderSide: BorderSide(
                                            color: MyColors
                                                .primaryNormal
                                                .withOpacity(0.7),
                                            width: 1.5),
                                      ),
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(
                                        color:
                                        isDarkTheme == false ? MyColors.primaryNormal : MyColors.darkThemeText.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 16),
                                  child: TextField(
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    controller: _controllerPassword,
                                    cursorColor: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                                    onChanged: (text) =>
                                        setState(() => _textPassword),
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      errorText: _submitted
                                          ? _errorPasswordText
                                          : null,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: MyColors
                                                .primaryNormal
                                                .withOpacity(0.7),
                                            width: 1.5),
                                      ),
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(
                                        color:
                                        isDarkTheme == false ? MyColors.primaryNormal : MyColors.darkThemeText.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    _restorableDatePickerRouteFuture.present();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    primary: isDarkTheme == false ? MyColors.lightThemeOverBackground : MyColors.darkThemeOverBackground,
                                    side: BorderSide(
                                        color: dateBorderColor, width: 1.5),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 42.0, vertical: 20.0),
                                    child: Text(
                                      formattedDate,
                                      style: TextStyle(
                                        color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Visibility(
                                    visible: _selectedBirthDate,
                                    child: StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter dropDownState) {
                                        return Text(
                                          'Must be selected',
                                          style: TextStyle(color: Colors.red),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: DropdownButton<String>(
                                    value: dropdownValue,
                                    dropdownColor: isDarkTheme == false ? MyColors.lightThemeOverBackground : MyColors.darkThemeOverBackground,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 0,
                                    style: TextStyle(
                                        color: MyColors
                                            .primaryNormal),
                                    underline: Container(
                                      height: 2,
                                      color: MyColors
                                          .primaryNormal
                                          .withOpacity(0.7),
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      GenderType.Male.name,
                                      GenderType.Female.name,
                                      GenderType.NonBinary.name,
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: SizedBox(
                                    width: 150.0,
                                    height: 45.0,
                                    child: FloatingActionButton(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                      ),
                                      backgroundColor: MyColors.accentNormal,
                                      onPressed: () => {
                                        setState(() {
                                          _submitted = true;
                                          if (formattedDate ==
                                              "Select Birth Date") {
                                            _selectedBirthDate = true;
                                            dateBorderColor = Colors.red;
                                          }
                                        }),
                                        if (_controllerName
                                                .value.text.isNotEmpty &&
                                            _controllerEmail
                                                .value.text.isNotEmpty &&
                                            _controllerPassword
                                                .value.text.isNotEmpty &&
                                            _controllerBirthDate !=
                                                DateTime.parse(nullDateTime))
                                          {_submit()}
                                      },
                                      child: const Text(
                                        'Register',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account?',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: isDarkTheme == false ? MyColors.lightThemeText : MyColors.darkThemeText,
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: MyColors.primaryNormal,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()),
                                        );
                                      },
                                      child: const Text(
                                        'Click here',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Stack(
                      children: [
                        FractionalTranslation(
                          translation: const Offset(0.0, -0.45),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: CircleAvatar(
                              backgroundColor: MyColors.primaryNormal,
                              radius: 50,
                              child: CircleAvatar(
                                radius: 48.0,
                                backgroundColor: MyColors.primaryNormal,
                                child: ClipRect(
                                  child: SvgPicture.asset(
                                      'assets/profile_icon.svg'),
                                ),
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
          ),
        ),
      ),
    );
  }

  void _submit() {
    // if there is no error text
    if (_errorNameText == null &&
        _errorEmailText == null &&
        _errorPasswordText == null) {
      // _controllerName.text, _controllerEmail.text, _controllerPassword.text, _controllerBirthDate, gender
      signUp();
    }
  }

  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            Center(
              child: CircularProgressIndicator(),
            ));

    try {
      final data = await FirebaseService.auth.createUserWithEmailAndPassword(
          email: _controllerEmail.text.trim(),
          password: _controllerPassword.text.trim());

      final docUser =
      FirebaseService.firestore.collection('users').doc(data.user!.uid);

      final user = UserData(
        id: docUser.id,
        name: _controllerName.text,
        birthDate: _controllerBirthDate,
        gender: EnumToString.fromString(GenderType.values, dropdownValue)!,
        email: _controllerEmail.text,
      );

      final json = user.toJson();
      await docUser.set(json);

      GenderType gender;
      if (dropdownValue == GenderType.Male.name)
        gender = GenderType.Male;
      else if (dropdownValue == GenderType.Female.name)
        gender = GenderType.Female;
      else
        gender = GenderType.NonBinary;
      userData = UserData(id: docUser.id,
          name: _controllerName.text,
          email: _controllerEmail.text,
          birthDate: DateTime.parse(formattedDate),
          gender: gender);

      final docUserEmails = FirebaseService.firestore.collection('emails').doc(
          data.user!.email);
      await docUserEmails.set({'id': data.user!.uid});

      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
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

  String? get _errorEmailText {
    final text = _controllerEmail.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (!emailValidator(text)) {
      return 'Invalid email';
    }

    return null;
  }

  String? get _errorPasswordText {
    final text = _controllerPassword.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 6) {
      return 'Too short';
    }

    return null;
  }

  bool emailValidator(String text) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(text);
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        if (_selectedDate.value.month >= 10) if (_selectedDate.value.day >= 10)
          formattedDate =
              '${_selectedDate.value.year}-${_selectedDate.value.month}-${_selectedDate.value.day}';
        else
          formattedDate =
              '${_selectedDate.value.year}-${_selectedDate.value.month}-0${_selectedDate.value.day}';
        else if (_selectedDate.value.day >= 10)
          formattedDate =
              '${_selectedDate.value.year}-0${_selectedDate.value.month}-${_selectedDate.value.day}';
        else
          formattedDate =
              '${_selectedDate.value.year}-0${_selectedDate.value.month}-0${_selectedDate.value.day}';
        _controllerBirthDate = DateTime.parse(formattedDate + " 00:00");
        _selectedBirthDate = false;
        dateBorderColor = MyColors.primaryNormal.withOpacity(0.7);
      });
    }
  }
}

class Utils {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
