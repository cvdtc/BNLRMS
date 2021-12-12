import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/dashboard/dashboard.model.dart';
import 'package:rmsmobile/pages/dashboard/dashboard.item.page/permintaan.dart';
import 'package:rmsmobile/pages/dashboard/dashboard.item.page/progres.dart';
import 'package:rmsmobile/pages/login/login.dart';
import 'package:rmsmobile/utils/ReusableClasses.dart';

import 'package:rmsmobile/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dahsboard extends StatefulWidget {
  const Dahsboard({Key? key}) : super(key: key);

  @override
  _DahsboardState createState() => _DahsboardState();
}

Text subheading(String title) {
  return Text(
    title,
    style: TextStyle(
        color: Color(0xFF0D253F),
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2),
  );
}

CircleAvatar calendarIcon() {
  return CircleAvatar(
    radius: 25.0,
    backgroundColor: Color(0xFF309397),
    child: Icon(
      Icons.calendar_today,
      size: 20.0,
      color: Colors.white,
    ),
  );
}

class _DahsboardState extends State<Dahsboard> {
  // ! INITIALIZE VARIABLE
  ApiService _apiService = ApiService();
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "", nama = "";
  bool? notifpermintaan = true, notifprogress = true;
  var jml_masalah = "", jml_selesai = 0, belum_selesai = 0;
  List<DashboardModel> _dashboard = <DashboardModel>[];
  late FirebaseMessaging messaging;

  // * ceking token and getting dashboard value from api
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
      nama = sp.getString('nama');
      jabatan = sp.getString("jabatan");
      notifpermintaan = sp.getBool("notif_permintaan");
      notifprogress = sp.getBool("notif_progress");
    });
    _apiService.getDashboard(token!).then((value) {
      setState(() {
        _dashboard.addAll(value!);
      });
    }).onError((error, stackTrace) {
      if (error == 401) {
        ReusableClasses().clearSharedPreferences();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Loginscreen(
                      tipe: 'sesiberakhir',
                    )));
      }
    });
  }

  @override
  initState() {
    super.initState();
    cekToken();
    print(notifprogress);
    messaging = FirebaseMessaging.instance;
    if (notifprogress == true) {
      messaging.subscribeToTopic('RMSPERMINTAAN');
    } else {
      messaging.unsubscribeFromTopic('RMSPERMINTAAN');
    }
    if (notifpermintaan == true) {
      messaging.subscribeToTopic('RMSPROGRESS');
    } else {
      messaging.unsubscribeFromTopic('RMSPROGRESS');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _apiService.client.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: thirdcolor,
            centerTitle: true,
            title: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/bnllogodashboard.png'))),
            )),
        body: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        color: thirdcolor,
                        padding: EdgeInsets.all(10),
                        constraints: BoxConstraints.expand(
                            height: MediaQuery.of(context).size.height / 6),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0.15),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20.0,
                                    backgroundImage: AssetImage(
                                      'assets/images/bnllogo.png',
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Row(children: [
                                    Text(
                                      "Halo, ",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    Text(
                                      nama.toString(),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 50, right: 50),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 70, left: 20, right: 20),
                        height: 100,
                        width: MediaQuery.of(context).size.width * 2.0,
                        child: Center(
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      _dashboard.length > 0
                                          ? _dashboard[0]
                                              .belum_selesai
                                              .toString()
                                          : "",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    Text(
                                      "Permintaan",
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                VerticalDivider(
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      _dashboard.length > 0
                                          ? _dashboard[0].selesai.toString()
                                          : "",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    Text(
                                      "     Selesai     ",
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.blue[800],
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            subheading('Permintaan'),
                            // GestureDetector(
                            //   onTap: (){},
                            //   child: Text('Selengkapnya >>>'),
                            // )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        PermintaanList()
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            subheading('Progres'),
                            // GestureDetector(
                            //   onTap: (){},
                            //   child: Text('Selengkapnya >>>'),
                            // )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ProgresList()
                      ],
                    ),
                  )
                ],
              ),
            ))
            // Expanded(
            //   child: SingleChildScrollView(
            //     child: Column(
            //       children: <Widget>[
            //         Container(
            //           color: Colors.transparent,
            //           padding: EdgeInsets.symmetric(
            //               horizontal: 20.0, vertical: 10.0),
            //           child: Column(
            //             children: <Widget>[
            //               Row(
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: <Widget>[
            //                   subheading('TugasKu'),
            //                   GestureDetector(
            //                     onTap: () {
            //                       // Navigator.push(
            //                       //   context,
            //                       //   MaterialPageRoute(
            //                       //       builder: (context) => CalendarPage()),
            //                       // );
            //                     },
            //                     child: calendarIcon(),
            //                   ),
            //                 ],
            //               ),
            //               SizedBox(height: 15.0),
            //               TaskColumn(
            //                 icon: Icons.alarm,
            //                 iconBackgroundColor: Colors.red,
            //                 title: 'Sedang Dikerjakan',
            //                 subtitle: '5 tugas sekarang. 1 dimulai',
            //               ),
            //               SizedBox(
            //                 height: 15.0,
            //               ),
            //               TaskColumn(
            //                 icon: Icons.blur_circular,
            //                 iconBackgroundColor: Colors.blue,
            //                 title: 'Sedang Berlangsung',
            //                 subtitle: '1 tugas sekarang. 1 dimulai',
            //               ),
            //               SizedBox(height: 15.0),
            //               TaskColumn(
            //                 icon: Icons.check_circle_outline,
            //                 iconBackgroundColor: Colors.greenAccent,
            //                 title: 'Selesai',
            //                 subtitle: '18 tugas sekarang. 13 dimulai',
            //               ),
            //             ],
            //           ),
            //         ),
            //         SizedBox(height: 10,),
            //         Container(
            //           color: Colors.transparent,
            //           padding: EdgeInsets.symmetric(
            //               horizontal: 20.0, vertical: 10.0),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: <Widget>[
            //               subheading('Projek Aktif'),
            //               SizedBox(height: 10.0),
            //               Row(
            //                 children: <Widget>[
            //                   ActiveProjectsCard(
            //                     cardColor: kGreen,
            //                     loadingPercent: 0.25,
            //                     title: 'Patent Avengers',
            //                     subtitle: '9 days progress',
            //                   ),
            //                   SizedBox(width: 20.0),
            //                   ActiveProjectsCard(
            //                     cardColor: kRed,
            //                     loadingPercent: 0.6,
            //                     title: 'Merk Aqua Project',
            //                     subtitle: '20 days progress',
            //                   ),
            //                 ],
            //               ),
            //               Row(
            //                 children: <Widget>[
            //                   ActiveProjectsCard(
            //                     cardColor: kDarkYellow,
            //                     loadingPercent: 0.45,
            //                     title: 'Sandal Swallow Patent',
            //                     subtitle: '5 days progress',
            //                   ),
            //                   SizedBox(width: 20.0),
            //                   ActiveProjectsCard(
            //                     cardColor: kBlue,
            //                     loadingPercent: 0.9,
            //                     title: 'Tokopedia Work',
            //                     subtitle: '23 days progress',
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ));
  }
}
