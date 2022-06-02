import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../styles/styles.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key, this.restorationId}) : super(key: key);

  final String? restorationId;

  @override
  State<Register> createState() => RegisterStatefulWidgetState();
}

class RegisterStatefulWidgetState extends State<Register> with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
  RestorableDateTime(DateTime(2021, 12, 12));
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
          lastDate: DateTime(2022),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  String dropdownValue = 'Male';

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
                    color: MyColors.taintedWhite.withOpacity(0.5),
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
                    height: 550.0,
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
                              hintText: 'Full Name',
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 16, left: 40, right: 40,),
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

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                          child: TextField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderSide: BorderSide(color: MyColors.primaryNormal.withOpacity(0.7), width: 1.5),
                              ),
                              border: const OutlineInputBorder(),
                              labelStyle: const TextStyle(color: MyColors.primaryNormal,),
                              hintText: 'Confirm Password',
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 8,),
                          child:
                              OutlinedButton(
                                onPressed: () {
                                  _restorableDatePickerRouteFuture.present();
                                },
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: MyColors.primaryNormal, width: 1.0),
                                ),
                                child: Text('Select Your Date of Birth', style: TextStyle(color:  MyColors.textNormal.withOpacity(0.7),),),
                              ),
                        ),

                        DropdownButton<String> (
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 0,
                          style: TextStyle(color:  MyColors.textNormal.withOpacity(1.0)),
                          underline: Container(
                            height: 2,
                            color: MyColors.primaryNormal.withOpacity(0.7),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: <String>['Male', 'Female', 'Non-binary',]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),),

                        TextButton(
                          style: TextButton.styleFrom(
                            primary: MyColors.primaryNormal,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()),);
                          },
                          child:
                          const Text('Already have an account?', style: TextStyle(fontWeight: FontWeight.normal, decoration: TextDecoration.underline,),),
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
                              print('Register'),
                            },

                            child: const Text(
                              'Register',
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
                        translation: const Offset(0.0, 0.05),
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child:
                          CircleAvatar(
                            backgroundColor: MyColors.primaryNormal,
                            radius: 50,
                            child: CircleAvatar(
                              radius: 48.0,
                              backgroundColor: MyColors.primaryNormal,
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

