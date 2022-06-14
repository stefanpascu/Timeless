import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timeless/pages/home_page.dart';
import 'package:timeless/pages/login.dart';
import 'package:timeless/pages/register.dart';
import 'package:timeless/service/notification_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp();

  runApp(MaterialApp(
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
      )));
}
