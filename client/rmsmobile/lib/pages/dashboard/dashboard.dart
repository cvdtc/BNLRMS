import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/dashboard/dashboard.model.dart';
import 'package:rmsmobile/pages/dashboard/dashboard.item.page/permintaan.dart';
import 'package:rmsmobile/pages/dashboard/dashboard.item.page/perpanjangan.dart';
import 'package:rmsmobile/pages/dashboard/dashboard.item.page/progres.dart';
import 'package:rmsmobile/pages/login/login.dart';
import 'package:rmsmobile/pages/perpanjangan/perpanjangan.page.dart';
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
        body: SingleChildScrollView(
          child: Column(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    child: Column(
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
                                          "Belum Selesai",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                  InkWell(
                                    child: Column(
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
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue[800],
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                
                // DASHBOARD BAGIAN PROGRESS DITUTUP SEMENTARA DIGANTI PERPANJANGAN, REQ: PAK JIAN 15/01/21
                // child: Column(
                //   children: [
                //     Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         subheading('Progres'),
                //       ],
                //     ),
                //     SizedBox(
                //       height: 10,
                //     ),
                    // ProgresList()
                //   ],
                // ),

                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        subheading('Perpanjangan'),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>PerpanjanganPageSearch()));
                          },
                          child: Text('Selengkapnya...'))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PerpanjanganList()
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        subheading('Permintaan'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Tidak Selesai'),
                        PermintaanList(
                          tipelist: 2,
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Belum Selesai'),
                        PermintaanList(
                          tipelist: 0,
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Sudah Selesai'),
                        PermintaanList(
                          tipelist: 1,
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
