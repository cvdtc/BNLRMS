import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

class ReusableClasses {
  // ! MODAL BOTTOM SHEET FOR WARNING ERROR
  modalbottomWarning(context, String title, String message, String kode,
      String imagelocation) {
    // dynamic navigation;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "[ " + kode.toUpperCase() + " ]",
                      style: TextStyle(fontSize: 11.0),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Image.asset(
                  imagelocation,
                  height: 150,
                  width: 250,
                ),
                SizedBox(height: 10.0),
                Text(
                  message.toString(),
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          );
        });
  }

  clearSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    late FirebaseMessaging messaging;
    // * adding firebase configuration setup
    messaging = FirebaseMessaging.instance;
    messaging.unsubscribeFromTopic('RMSPERMINTAAN');
    messaging.unsubscribeFromTopic('RMSPROGRESS');
  }

  setFirebaseConfiguration(String topicname, String spname, bool value) async {
    // * configuration sp for notification
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool(spname, value);
    // * adding firebase configuration setup
    late FirebaseMessaging messaging;
    messaging = FirebaseMessaging.instance;
    value
        ? messaging.subscribeToTopic(topicname)
        : messaging.unsubscribeFromTopic(topicname);

    print(topicname + spname + value.toString());
  }
}

class GetSharedPreference {
  late SharedPreferences sp;
  var tokens = "";
  getsharedpreferences() async {
    sp = await SharedPreferences.getInstance();
  }

  set setToken(String token) {
    this.tokens = token;
  }

  Future<String> get getToken async {
    return tokens;
  }
}
