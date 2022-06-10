import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeless/pages/register.dart';

import '../main.dart';
import '../styles/styles.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _submitted = false;
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  var _textEmail = '';
  var _textPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              MyColors().primaryNormal.withOpacity(0.2),
              MyColors().primaryNormal.withOpacity(0.5),
              MyColors().accentNormal.withOpacity(0.5),
              MyColors().accentNormal.withOpacity(0.2),
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: MyColors().overBackground.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(7),
                      ),
                      border: Border(
                        top: BorderSide(
                            width: 3.0,
                            color: MyColors().primaryNormal.withOpacity(0.7)),
                        left: BorderSide(
                            width: 3.0,
                            color: MyColors().primaryNormal.withOpacity(0.7)),
                        right: BorderSide(
                            width: 3.0,
                            color: MyColors().primaryNormal.withOpacity(0.7)),
                        bottom: BorderSide(
                            width: 3.0,
                            color: MyColors().primaryNormal.withOpacity(0.7)),
                      ),
                    ),
                    child: Expanded(
                      child: Container(
                        width: 350,
                        margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 50.0,
                                left: 40.0,
                                right: 40.0,
                                bottom: 16.0
                              ),
                              child: TextField(
                                controller: _controllerEmail,
                                style: TextStyle(color: MyColors().textNormal),
                                cursorColor: MyColors().textNormal,
                                onChanged: (text) => setState(() => _textEmail),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  errorText:
                                      _submitted ? _errorEmailText : null,
                                  enabledBorder: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: BorderSide(
                                        color: MyColors()
                                            .primaryNormal
                                            .withOpacity(0.7),
                                        width: 1.5),
                                  ),
                                  border: OutlineInputBorder(),
                                  labelStyle: TextStyle(
                                    color:
                                        MyColors().textNormal.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40),
                              child: TextField(
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: _controllerPassword,
                                style: TextStyle(color: MyColors().textNormal),
                                cursorColor: MyColors().textNormal,
                                onChanged: (text) =>
                                    setState(() => _textPassword),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  errorText:
                                      _submitted ? _errorPasswordText : null,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyColors()
                                            .primaryNormal
                                            .withOpacity(0.7),
                                        width: 1.5),
                                  ),
                                  border: OutlineInputBorder(),
                                  labelStyle: TextStyle(
                                    color:
                                        MyColors().textNormal.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  primary: MyColors().primaryNormal,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        ForgotPasswordPage()),
                                  );
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              width: 150.0,
                              height: 45.0,
                              child: FloatingActionButton(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                                backgroundColor: MyColors().accentNormal,
                                onPressed: () => {
                                  setState(() {
                                    _submitted = true;
                                  }),
                                  if (_controllerEmail.value.text.isNotEmpty &&
                                      _controllerPassword.value.text.isNotEmpty)
                                    {_submit()}
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: MyColors().textNormal,
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    primary: MyColors().primaryNormal,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Register()),
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
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Stack(
                      children: [
                        FractionalTranslation(
                          translation: const Offset(0.0, -0.7),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: CircleAvatar(
                              backgroundColor: MyColors().primaryNormal,
                              radius: 50,
                              child: CircleAvatar(
                                radius: 48.0,
                                backgroundColor: MyColors().accentNormal,
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
    if (_errorEmailText == null && _errorPasswordText == null) {
      signIn();
    }
  }

  Future signIn() async {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator(),
        ));
    
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _controllerEmail.text.trim(),
          password: _controllerPassword.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);

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

  bool emailValidator(String text) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(text);
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
}
