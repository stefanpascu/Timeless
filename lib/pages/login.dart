import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeless/pages/register.dart';

import '../styles/styles.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => LoginStatefulWidgetState();
}

class LoginStatefulWidgetState extends State<Login> {
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
                Align(
                  alignment: Alignment.center,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: MyColors.white.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(7),
                      ),
                      border: Border(
                        top: BorderSide(
                            width: 3.0,
                            color: MyColors.primaryNormal.withOpacity(0.7)),
                        left: BorderSide(
                            width: 3.0,
                            color: MyColors.primaryNormal.withOpacity(0.7)),
                        right: BorderSide(
                            width: 3.0,
                            color: MyColors.primaryNormal.withOpacity(0.7)),
                        bottom: BorderSide(
                            width: 3.0,
                            color: MyColors.primaryNormal.withOpacity(0.7)),
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
                                top: 50,
                                left: 40,
                                right: 40,
                              ),
                              child: TextField(
                                controller: _controllerEmail,
                                onChanged: (text) => setState(() => _textEmail),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  errorText:
                                      _submitted ? _errorEmailText : null,
                                  enabledBorder: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: BorderSide(
                                        color: MyColors.primaryNormal
                                            .withOpacity(0.7),
                                        width: 1.5),
                                  ),
                                  border: OutlineInputBorder(),
                                  labelStyle: TextStyle(
                                    color: MyColors.textNormal.withOpacity(0.7),
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
                                onChanged: (text) =>
                                    setState(() => _textPassword),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  errorText:
                                      _submitted ? _errorPasswordText : null,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyColors.primaryNormal
                                            .withOpacity(0.7),
                                        width: 1.5),
                                  ),
                                  border: OutlineInputBorder(),
                                  labelStyle: TextStyle(
                                    color: MyColors.textNormal.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),

                            // TextButton(
                            //   style: TextButton.styleFrom(
                            //     primary: MyColors.primaryNormal,
                            //   ),
                            //   onPressed: () {
                            //     print('change password');
                            //   },
                            //   child:
                            //   const Text('Forgot Password?', style: TextStyle(fontWeight: FontWeight.normal, decoration: TextDecoration.underline,),),
                            // ),

                            SizedBox(
                              width: 150.0,
                              height: 45.0,
                              child: FloatingActionButton(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                                backgroundColor: MyColors.accentNormal,
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
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    primary: MyColors.primaryNormal,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Register()),
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
                              backgroundColor: MyColors.primaryNormal,
                              radius: 50,
                              child: CircleAvatar(
                                radius: 48.0,
                                backgroundColor: MyColors.accentNormal,
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
      print("Login");
    }
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
    if (text.length < 4) {
      return 'Too short';
    }

    return null;
  }
}
