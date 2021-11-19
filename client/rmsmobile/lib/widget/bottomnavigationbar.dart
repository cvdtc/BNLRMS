import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rmsmobile/pages/dashboard/dashboard.dart';
import 'package:rmsmobile/pages/request/request.search.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:rolling_nav_bar/rolling_nav_bar.dart';

double scaledHeight(BuildContext context, double baseSize) {
  return baseSize * (MediaQuery.of(context).size.height / 800);
}

double scaledWidth(BuildContext context, double baseSize) {
  return baseSize * (MediaQuery.of(context).size.width / 375);
}

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentTab = 0;
  Color logoColor = Colors.red[600]!;
  PageStorageBucket bucket = PageStorageBucket();
  var iconData = <IconData>[
    Icons.home_filled,
    Icons.document_scanner_outlined,
    Icons.hourglass_bottom_rounded,
    // Icons.thermostat_auto_outlined,
    Icons.person
  ];

  List<Widget> _currentPage = <Widget>[
    Dahsboard(),
    // RequestPage(),
    RequestPageSearch()
    // SplashScreenPage(),
  ];

  var iconText = <Widget>[
    Text('Home', style: TextStyle(color: Colors.grey, fontSize: 12)),
    Text('Request', style: TextStyle(color: Colors.grey, fontSize: 12)),
    Text('Progress', style: TextStyle(color: Colors.grey, fontSize: 12)),
    // Text('Timeline', style: TextStyle(color: Colors.grey, fontSize: 12)),
    Text('Account', style: TextStyle(color: Colors.grey, fontSize: 12)),
  ];

  // var indicatorColors = <Color>[
  //   Colors.red,
  //   Colors.orange,
  //   Colors.green,
  //   Colors.blue,
  //   Colors.purple,
  // ];

  // void incrementIndex() {
  //   setState(() {
  //     activeIndex = activeIndex < (iconData.length - 1) ? activeIndex + 1 : 0;
  //   });
  // }

  // _onAnimate(AnimationUpdate update) {
  //   setState(() {
  //     logoColor = update.color;
  //   });
  // }
  // var badges = <int>[0, 0, 0, 0, 0];

  // List<Widget?> get badgeWidgets => indexed(badges)
  //     .map((Indexed indexed) => indexed.value > 0
  //         ? Text(indexed.value.toString(),
  //             style: TextStyle(
  //               color: indexed.index == activeIndex
  //                   ? indicatorColors[indexed.index]
  //                   : Colors.white,
  //             ))
  //         : null)
  //     .toList();

  // void _incrementBadge() {
  //   setState(() {
  //     badges[activeIndex] += 1;
  //   });
  // }

  // List<Widget> get builderChildren => const <Widget>[
  //       Text('1', style: TextStyle(color: Colors.grey)),
  //       Text('2', style: TextStyle(color: Colors.grey)),
  //       Text('3', style: TextStyle(color: Colors.grey)),
  //     ];

  // _onTap(int index) {
  //   activeIndex = index;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            body: PageStorage(bucket: bucket, child: _currentPage[_currentTab]),
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
                indicatorColors: <Color>[thirdcolor],
                iconSize: 25,
                indicatorRadius: scaledHeight(context, 30),
                onTap: (value){
                  setState(() {
                    _currentTab = value;
                  });
                },
                // badges: badgeWidgets,
                // indicatorColors: indicatorColors,
                // onAnimate: _onAnimate,
                // onTap: _onTap,
              ),
            ),
          );
        },
      ),
    );
  }
}
