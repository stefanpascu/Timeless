import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:timeless/pages/home_page.dart';
import 'package:timeless/pages/login.dart';
import 'package:timeless/pages/register.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey  ,
      home: StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting)
        return Center(child: CircularProgressIndicator());
      else if (snapshot.hasError)
        return Center(child: Text('Something went wrong'),);
      else if (snapshot.hasData)
        return HomePage();
      else return LoginPage();
    },
  )));

}

