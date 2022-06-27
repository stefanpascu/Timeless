import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:timeless/pages/home_page.dart';
import 'package:timeless/pages/login.dart';
import 'package:timeless/pages/register.dart';
import 'package:timeless/service/notification_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp();

  Future<bool> getThemeFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final startupBool = prefs.getBool('option');
    return startupBool == null ? false : startupBool;
  }

  runApp(FutureBuilder<bool>(
      future: getThemeFromSharedPref(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              scaffoldMessengerKey: Utils.messengerKey,
              navigatorKey: navigatorKey,
              home: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.hasError)
                    return Center(
                      child: Text('Something went wrong'),
                    );
                  else if (snapshot.hasData)
                    return HomePage();
                  else
                    return LoginPage();
                },
              ));
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Center(child: Text(snapshot.error.toString()));
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      }));
}
