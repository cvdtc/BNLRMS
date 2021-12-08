import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/timeline/timeline.model.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';

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
  TextEditingController _tecNama = TextEditingController(text: "");
  TextEditingController _tecKeterangan = TextEditingController(text: "");

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
    // TODO: implement dispose
    super.dispose();
    _apiService.client.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timeline '),
        centerTitle: true,
        backgroundColor: thirdcolor,
      ),
      body: FutureBuilder(
          future: _apiService.getListTimeline(token!, idpermintaan.toString()),
          builder: (context, AsyncSnapshot<List<TimelineModel>?> snapshot) {
            print('SNAPSHOT? ' + snapshot.toString());
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
                    lineXY: 0.05,
                    endChild: _designItem(
                        dataTimeline.tipe,
                        dataTimeline.keterangan,
                        dataTimeline.kategori,
                        dataTimeline.due_date,
                        dataTimeline.created,
                        dataTimeline.edited,
                        dataTimeline.flag_selesai,
                        dataTimeline.keterangan_selesai,
                        dataTimeline.idpengguna_close_permintaan,
                        dataTimeline.prg_keterangan,
                        dataTimeline.prg_created,
                        dataTimeline.prg_edited,
                        dataTimeline.prg_flag_selesai,
                        dataTimeline.nama_request,
                        dataTimeline.nama_progress
                        )),
              ));
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
      String nama_progress
      ) {
    double c_width = MediaQuery.of(context).size.width * 0.8;
    if (tipe == 1) {
      // * show data masalah
      return Container(
        color: Colors.orange[300],
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Request',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Divider(
                  thickness: 2,
                  height: 8,
                ),
                Text('Keterangan : $keterangan'),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('kategori : '),
                      Text(kategori),
                    ],
                  ),
                ),
                Text('Tanggal Tenggat: $due_date')
              ],
            )),
      );
    } else if (tipe == 2) {
      // * show data progress
      return Container(
        width: c_width,
        color: Colors.green[300],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progress',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Divider(
                thickness: 2,
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Created : '), Text(prg_created)],
              ),
              Flexible(
                child: Text('Keterangan : ' + prg_keterangan),
              ),
              Flexible(
                child: Text('Edited : ' + edited),
              ),
              Flexible(
                child: Text('User Prog : ' + nama_progress),
              ),
            ],
          ),
        ),
      );
    } else if (tipe == 3) {
      // * show data penyelesaian
      return Container(
        color: Colors.blue[300],
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Penyelesaian',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Divider(
                  thickness: 2,
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tanggal : '),
                    Text(due_date),
                  ],
                ),
                Flexible(
                  child: Text('Keterangan : ' + keterangan_selesai),
                )
              ],
            )),
      );
    } else {
      return Container();
    }
  }
}
