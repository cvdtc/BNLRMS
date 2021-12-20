import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rmsmobile/pages/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AkunBottomModal {
  void exit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    late FirebaseMessaging messaging;
    // * adding firebase configuration setup
    messaging = FirebaseMessaging.instance;
    messaging.unsubscribeFromTopic('RMSPERMINTAAN');
    messaging.unsubscribeFromTopic('RMSPROGRESS');
    // print('preference $preferences');
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Loginscreen(
                  tipe: 'keluar',
                )));
  }
}
