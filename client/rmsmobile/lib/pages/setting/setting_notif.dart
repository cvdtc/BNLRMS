import 'package:flutter/material.dart';
import 'package:rmsmobile/utils/warna.dart';

class SettingNotifikasi extends StatefulWidget {
  @override
  _SettingNotifikasiState createState() => _SettingNotifikasiState();
}

class _SettingNotifikasiState extends State<SettingNotifikasi> {
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
                Switch(value: true, onChanged: (bool values) {})
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notifikasi Progress'),
                Switch(value: true, onChanged: (bool values) {})
              ],
            )
          ],
        ),
      ),
    );
  }
}
