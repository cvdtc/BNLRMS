import 'package:flutter/material.dart';
import 'package:rmsmobile/utils/ReusableClasses.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingNotifikasi extends StatefulWidget {
  @override
  _SettingNotifikasiState createState() => _SettingNotifikasiState();
}

class _SettingNotifikasiState extends State<SettingNotifikasi> {
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "";
  bool notifpermintaan = true, notifprogress = true;

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
      username = sp.getString("username");
      jabatan = sp.getString("jabatan");
      notifpermintaan = sp.getBool('notif_permintaan')!;
      notifprogress = sp.getBool('notif_progress')!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Setting Notifikasi',
          // style: TextStyle(),
        ),
        centerTitle: true,
        backgroundColor: thirdcolor,
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notifikasi Permintaan'),
                Switch(
                  onChanged: (bool values) {
                    setState(() {
                      notifpermintaan = values;
                      ReusableClasses().setFirebaseConfiguration(
                          'RMSPERMINTAAN', 'notif_permintaan', values);
                    });
                  },
                  value: notifpermintaan,
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notifikasi Progress'),
                Switch(
                  onChanged: (bool values) {
                    setState(() {
                      notifprogress = values;
                      ReusableClasses().setFirebaseConfiguration(
                          'RMSPROGRESS', 'notif_progress', values);
                    });
                  },
                  value: notifprogress,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
