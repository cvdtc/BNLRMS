// @dart=2.9
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmsmobile/pages/splashscreen/splashscreen.dart';
import 'package:rmsmobile/utils/warna.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  HttpOverrides.global = new MyHttpOverrides();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: thirdcolor, // status bar color
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'RMS BNL',
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: backgroundcolor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: textcolor),
          canvasColor: Colors.transparent),
      debugShowCheckedModeBanner: false,
      home: SplashScreenPage(),
    );
  }
}
