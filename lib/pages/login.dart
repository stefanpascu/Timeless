import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../styles/styles.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => LoginStatefulWidgetState();
}

class LoginStatefulWidgetState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Center(
          child: Container(
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
            child:
            Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                  child: DecoratedBox(
                    decoration:
                    BoxDecoration(
                      color: MyColors.white.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(7),
                      ),
                      border: Border(
                        top: BorderSide(width: 3.0, color: MyColors.primaryNormal.withOpacity(0.7)),
                        left: BorderSide(width: 3.0, color: MyColors.primaryNormal.withOpacity(0.7)),
                        right: BorderSide(width: 3.0, color: MyColors.primaryNormal.withOpacity(0.7)),
                        bottom: BorderSide(width: 3.0, color: MyColors.primaryNormal.withOpacity(0.7)),
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                      height: 340.0,
                      width: 350.0,
                      child: Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(top: 50, left: 40, right: 40,),
                            child: TextField(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  // width: 0.0 produces a thin "hairline" border
                                  borderSide: BorderSide(color: MyColors.primaryNormal.withOpacity(0.7), width: 1.5),
                                ),
                                border: const OutlineInputBorder(),
                                labelStyle: const TextStyle(color: MyColors.primaryNormal,),
                                hintText: 'Email',
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            child: TextField(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  // width: 0.0 produces a thin "hairline" border
                                  borderSide: BorderSide(color: MyColors.primaryNormal.withOpacity(0.7), width: 1.5),
                                ),
                                border: const OutlineInputBorder(),
                                labelStyle: const TextStyle(color: MyColors.primaryNormal,),
                                hintText: 'Password',
                              ),
                            ),
                          ),

                          TextButton(
                            style: TextButton.styleFrom(
                              primary: MyColors.primaryNormal,
                            ),
                            onPressed: () {
                              print('change password');
                            },
                            child:
                            const Text('Forgot Password?', style: TextStyle(fontWeight: FontWeight.normal, decoration: TextDecoration.underline,),),
                          ),

                          SizedBox(
                            width: 150.0,
                            height: 45.0,
                            child: FloatingActionButton(

                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0)
                                ),
                              ),

                              backgroundColor: MyColors.accentNormal,

                              onPressed: () => {
                                print('login'),
                              },

                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ],
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
                          translation: const Offset(0.0, 1.0),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child:
                            CircleAvatar(
                              backgroundColor: MyColors.primaryNormal,
                              radius: 50,
                              child: CircleAvatar(
                                radius: 48.0,
                                backgroundColor: MyColors.accentNormal,
                                child: ClipRect(
                                  child: SvgPicture.asset('assets/profile_icon.svg'),
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






    );
  }
}

