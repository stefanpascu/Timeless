import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeless/pages/register.dart';

import '../styles/styles.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final _controllerEmail = TextEditingController();
  bool _submitted = false;
  var _textEmail = '';

  @override
  void dispose() {
    _controllerEmail.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: MyColors().primaryNormal,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: MyColors().backgroundNormal.withOpacity(0),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(
              Icons.delete,
              color: MyColors().backgroundNormal.withOpacity(0.0),
              size: 50.0,
            ),
          ),
        ],
        elevation: 0,
      ),
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
                              padding: EdgeInsets.only(
                                  top: 50.0,
                                  left: 40.0,
                                  right: 40.0,
                                  bottom: 16.0),
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
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: SizedBox(
                                width: 200.0,
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
                                    if (_controllerEmail.value.text.isNotEmpty)
                                      {_submit()}
                                  },
                                  child: const Text(
                                    'Reset Password',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
    if (_errorEmailText == null) {
      resetPassword();
    }
  }

  Future resetPassword() async {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator(),
        ));

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _controllerEmail.text);

      Utils.showSnackBar('Password Reset Email Sent');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
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
}
