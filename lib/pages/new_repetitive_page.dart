import 'package:flutter/cupertino.dart';

class NewRepetitivePage extends StatefulWidget {
  const NewRepetitivePage({Key? key}) : super(key: key);

  @override
  State<NewRepetitivePage> createState() => NewRepetitivePageState();
}

class NewRepetitivePageState extends State<NewRepetitivePage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('hello1'),
        Text('hello2'),
        Text('hello3'),
      ],
    );
  }
}