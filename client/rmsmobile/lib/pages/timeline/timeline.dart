import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/timeline/timeline.model.dart';
import 'package:rmsmobile/pages/timeline/timeline.bottom.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';

// ignore: must_be_immutable
class TimelinePage extends StatefulWidget {
  String idpermintaan;
  TimelinePage({required this.idpermintaan});
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
// ! Declare Variable HERE!
  ApiService _apiService = new ApiService();
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "", idpermintaan = "";
  TextEditingController tecNama = TextEditingController(text: "");
  TextEditingController tecKeterangan = TextEditingController(text: "");

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
      username = sp.getString("username");
      jabatan = sp.getString("jabatan");
    });
  }

  @override
  initState() {
    idpermintaan = widget.idpermintaan;
    super.initState();
    cekToken();
  }

  @override
  dispose() {
    super.dispose();
    _apiService.client.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timeline '),
        centerTitle: true,
        backgroundColor: backgroundcolor,
      ),
      body: FutureBuilder(
          future: _apiService.getListTimeline(token!, idpermintaan.toString()),
          builder: (context, AsyncSnapshot<List<TimelineModel>?> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                        'maaf, terjadi masalah ${snapshot.error}. buka halaman ini kembali.')
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 15,
                    ),
                    Text('Sebentar ya, sedang antri...')
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<TimelineModel>? dataKomponen = snapshot.data;
                return _listKomponen(dataKomponen);
              } else {
                return Center(
                  child: Text('Data Masih kosong nih!'),
                );
              }
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                        'maaf, terjadi masalah ${snapshot.error}. buka halaman ini kembali.')
                  ],
                ),
              );
            }
          }),
    );
  }

  // ++ DESIGN LIST COMPONENT
  Widget _listKomponen(List<TimelineModel>? dataIndex) {
    return ListView.builder(
        itemCount: dataIndex!.length,
        itemBuilder: (context, index) {
          TimelineModel? dataTimeline = dataIndex[index];
          return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                  child: TimelineTile(
                      alignment: TimelineAlign.manual,
                      indicatorStyle: const IndicatorStyle(
                        width: 18,
                        color: thirdcolor,
                        indicatorXY: 0.2,
                        padding: EdgeInsets.all(3),
                      ),
                      lineXY: 0.05,
                      endChild: _designItem(
                          dataTimeline.tipe,
                          dataTimeline.keterangan,
                          dataTimeline.kategori,
                          dataTimeline.due_date,
                          dataTimeline.created,
                          dataTimeline.edited != null
                              ? dataTimeline.edited
                              : '-',
                          dataTimeline.flag_selesai,
                          dataTimeline.keterangan_selesai,
                          dataTimeline.idpengguna_close_permintaan != null
                              ? dataTimeline.idpengguna_close_permintaan
                              : 'Tidak Selesai',
                          dataTimeline.prg_keterangan,
                          dataTimeline.prg_created,
                          dataTimeline.prg_edited != null
                              ? dataTimeline.prg_edited
                              : 'Tidak Selesai',
                          dataTimeline.prg_flag_selesai,
                          dataTimeline.nama_request,
                          dataTimeline.nama_progress,
                          dataTimeline.nama_close_permintaan,
                          dataTimeline.date_selesai,
                          dataTimeline.url_permintaan,
                          dataTimeline.url_progress != null
                              ? dataTimeline.url_progress
                              : ''))));
        });
  }

  Widget _designItem(
      int tipe,
      String keterangan,
      String kategori,
      String due_date,
      String created,
      String edited,
      String flag_selesai,
      String keterangan_selesai,
      String idpengguna_close_permintaan,
      String prg_keterangan,
      String prg_created,
      String prg_edited,
      String prg_flag_selesai,
      String nama_request,
      String nama_progress,
      String nama_close_permintaan,
      String date_selesai,
      String url_permintaan,
      String url_progress) {
    double c_width = MediaQuery.of(context).size.width * 0.8;
    if (tipe == 1) {
      // * url null handler
      if (url_permintaan == null || url_permintaan == "") {
        url_permintaan = "";
      }
      // * show data masalah
      return InkWell(
        onDoubleTap: () {
          TimelineBottomModal().actionTimeline(context, url_permintaan);
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.orange[200],
          elevation: 3.0,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      color: Colors.orange,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Permintaan',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  created,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    url_permintaan != ""
                        ? Container(
                            color: Colors.amber,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.attach_file,
                                    size: 16.0,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(url_permintaan,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(kategori),
                            Text(nama_request),
                          ],
                        ),
                        Text(
                          keterangan,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        flag_selesai == 1
                            ? Text(keterangan_selesai)
                            : Container(),
                        Divider(
                          thickness: 1,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('JT: $due_date'),
                            edited != null
                                ? Text('Updated: $edited')
                                : Text('Updated: -')
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else if (tipe == 2) {
      if (url_progress == null || url_progress == "") {
        url_progress = '';
      }
      // * show data progress
      return InkWell(
        onDoubleTap: () {
          TimelineBottomModal().actionTimeline(context, url_progress);
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.green[200],
          elevation: 3.0,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      color: Colors.green,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progres',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              prg_created,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    url_progress != ""
                        ? Container(
                            color: Colors.amber,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.attach_file,
                                    size: 16.0,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      url_progress,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12.0, bottom: 12.0, top: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(nama_progress),
                          ],
                        ),
                        Text(
                          "Deskripsi: " + prg_keterangan,
                          style: TextStyle(fontSize: 16),
                        ),
                        Divider(thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            prg_edited != null && prg_flag_selesai != 1
                                ? Text('Updated : ' + prg_edited.toString())
                                : Text('Updated : Belum diselesaikan'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (tipe == 3) {
      // * show data penyelesaian
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Colors.blue[200],
        elevation: 3.0,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Penyelesaian',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              prg_created,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, bottom: 12.0, top: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Status : Selesai'),
                              Text(nama_close_permintaan),
                            ],
                          ),
                          Text('Keterangan: ' + keterangan_selesai),
                          Divider(thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Tgl. Selesai : ' + date_selesai.toString())
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
