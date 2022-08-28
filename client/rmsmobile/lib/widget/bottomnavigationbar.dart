import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/pages/akun/akun.page.dart';
import 'package:rmsmobile/pages/dashboard/dashboard.dart';
import 'package:rmsmobile/pages/progres/progres.page.dart';
import 'package:rmsmobile/pages/request/request.page.dart';
import 'package:rolling_nav_bar/rolling_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rmsmobile/utils/warna.dart';

double scaledHeight(BuildContext context, double baseSize) {
  return baseSize * (MediaQuery.of(context).size.height / 800);
}

double scaledWidth(BuildContext context, double baseSize) {
  return baseSize * (MediaQuery.of(context).size.width / 375);
}

class BottomNav extends StatefulWidget {
  int numberOfpage;
  BottomNav({required this.numberOfpage});
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  DateTime? backbuttonpressedtime;
  int _currentTab = 0;
  Color logoColor = Colors.red[600]!;
  bool hasinet = false;
  ApiService _apiService = ApiService();
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "", nama = "";
  PageStorageBucket bucket = PageStorageBucket();

  var iconData = <IconData>[
    Icons.home,
    Icons.addchart_rounded,
    Icons.hourglass_bottom_rounded,
    // Icons.thermostat_auto_outlined,
    Icons.person
  ];

  List<Widget> _currentPage = <Widget>[
    Dahsboard(),
    RequestPageSearch(),
    ProgressPage(),
    AkunPage()
  ];

  var iconText = <Widget>[
    Text('Dashboard', style: TextStyle(color: darkgreen, fontSize: 12)),
    Text('Permintaan', style: TextStyle(color: darkgreen, fontSize: 12)),
    Text('Progres', style: TextStyle(color: darkgreen, fontSize: 12)),
    Text('Akun', style: TextStyle(color: darkgreen, fontSize: 12)),
  ];

  @override
  void initState() {
    super.initState();
    _currentTab = widget.numberOfpage;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[100],
        ),
        home: Builder(
          builder: (BuildContext context) {
            double largeIconHeight = MediaQuery.of(context).size.width;
            double navBarHeight = scaledHeight(context, 85);
            double topOffset = (MediaQuery.of(context).size.height -
                    largeIconHeight -
                    MediaQuery.of(context).viewInsets.top -
                    (navBarHeight * 2)) /
                2;
            return Scaffold(
              body:
                  PageStorage(bucket: bucket, child: _currentPage[_currentTab]),
              bottomNavigationBar: Container(
                height: navBarHeight,
                width: MediaQuery.of(context).size.width,
                // Option 1: Recommended
                child: RollingNavBar.iconData(
                  activeBadgeColors: <Color>[
                    Colors.white,
                  ],
                  activeIndex: _currentTab,
                  animationCurve: Curves.linear,
                  animationType: AnimationType.roll,
                  baseAnimationSpeed: 200,
                  iconData: iconData,
                  iconColors: <Color>[Colors.grey[800]!],
                  iconText: iconText,
                  indicatorColors: <Color>[darkgreen],
                  iconSize: 25,
                  indicatorRadius: scaledHeight(context, 30),
                  onTap: (value) {
                    setState(() {
                      _currentTab = value;
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    DateTime currenttime = DateTime.now();
    bool backbutton = backbuttonpressedtime == null ||
        currenttime.difference(backbuttonpressedtime!) > Duration(seconds: 3);

    if (backbutton) {
      backbuttonpressedtime = currenttime;
      Fluttertoast.showToast(
          msg: "Klik 2x untuk keluar aplikasi",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    return true;
  }
}
