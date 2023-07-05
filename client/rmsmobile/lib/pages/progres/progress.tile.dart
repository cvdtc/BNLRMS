import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/pengguna/pengguna.model.dart';
import 'package:rmsmobile/model/progress/progress.model.dart';
import 'package:http/http.dart' as client;
import 'package:rmsmobile/pages/progres/progress.bottom.dart';
import 'package:rmsmobile/pages/timeline/timeline.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pengguna {
  final String idpengguna;
  final String namapengguna;

  Pengguna({required this.idpengguna, required this.namapengguna});

  factory Pengguna.fromJson(Map<String, dynamic> json) {
    return Pengguna(
      idpengguna: json['idpengguna'],
      namapengguna: json['nama'],
    );
  }
}

class ProgressTile extends StatefulWidget {
  late final ProgressModel progress;
  final String token;
  ProgressTile({required this.progress, required this.token});

  @override
  State<ProgressTile> createState() => _ProgressTileState();
}

class _ProgressTileState extends State<ProgressTile> {
  ApiService _apiService = new ApiService();
  late SharedPreferences sp;
  String? token = "",
      keterangan,
      kategori,
      duedate,
      next_idpengguna,
      flag_selesai,
      idprogress = "",
      username = "",
      jabatan = "",
      idpermintaan = "",
      tipeinsert = "selesai",
      tipe = "selesai";
  String valpengguna = "Paten";
  TextEditingController _tecKeterangan = TextEditingController(text: "");
  TextEditingController _tecKeteranganNext = TextEditingController(text: "");
  TextEditingController _tecUrlProgress = TextEditingController(text: "");
  bool nextuser = false;
  List<PenggunaModel> _penggunaDisplay = <PenggunaModel>[];

  List? pnggunaList;
  String? _mypengguna;
  Future<String?> _pngguna() async {
    var url = Uri.parse(_apiService.baseUrl + 'pengguna');
    final response =
        await client.get(url, headers: {"Authorization": "BEARER ${token}"});
    // .then((value) => print("Pengguna?" + value.toString()))
    // .onError((error, stackTrace) {
    //   ReusableClasses().modalbottomWarning(context, "Pengguna ",
    //       'Pengguna tidak ke load', 'f404', 'assets/images/sorry');
    // });
    var dataz = json.decode(response.body);
    setState(() {
      pnggunaList = dataz['data'];
    });
  }

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
      username = sp.getString("username");
      jabatan = sp.getString("jabatan");
    });
    _pngguna();
    _mypengguna;
    _penggunaDisplay;
  }

  @override
  void initState() {
    super.initState();
    idprogress = widget.progress.idprogress.toString();
    idpermintaan = widget.progress.idpermintaan.toString();
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
            elevation: 0.0,
            child: InkWell(
              onTap: () {
                _actionItemOnPages(
                    context,
                    tipe!,
                    widget.token,
                    widget.progress.keterangan,
                    widget.progress.idpermintaan.toString(),
                    tipeinsert.toString(),
                    widget.progress.idprogress.toString(),
                    widget.progress.flag_selesai.toString(),
                    widget.progress.idnextuser.toString(),
                    widget.progress.url_progress,
                    widget.progress.permintaan,
                    widget.progress.kategori,
                    widget.progress.due_date);
              },
              child: Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(widget.progress.kategori),
                        Text(widget.progress.nama),
                      ],
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Text(
                        'Permintaan : ' + widget.progress.permintaan.toString(),
                        style: TextStyle(fontSize: 16.0)),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'tgl. akhir : ' + widget.progress.due_date.toString(),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Text('Progress Awal : ' + widget.progress.keterangan,
                        style: TextStyle(fontSize: 14.0)),
                    Text('Tanggal : ' + widget.progress.created,
                        style: TextStyle(fontSize: 14.0)),
                  ],
                ),
              ),
            )));
  }

  Widget _buildKomboPengguna(String pengguna1) {
    // _controlleridpengguna = TextEditingController(text: pengguna1);
    return StatefulBuilder(builder:
        (BuildContext context, void Function(void Function()) setState) {
      return DropdownButtonHideUnderline(
        child: ButtonTheme(
            minWidth: 30,
            alignedDropdown: true,
            child: DropdownButton<String>(
              dropdownColor: Colors.white,
              value: _mypengguna,
              iconSize: 30,
              icon: Icon(Icons.arrow_drop_down),
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
              hint: Text('Pilih User'),
              onChanged: (String? value) {
                setState(() {
                  _mypengguna = value;
                });
              },
              items: pnggunaList?.map((item) {
                return new DropdownMenuItem(
                  child: Text(
                    '${item['nama']}',
                    style: TextStyle(color: Colors.black),
                  ),
                  value: item['idpengguna'].toString(),
                );
              }).toList(),
            )),
      );
    });
  }

  _actionItemOnPages(
      context,
      String tipe,
      String token,
      String keterangan,
      String idpermintaan,
      String tipeinsert,
      String idprogress,
      String flag_selesai,
      String next_idpengguna,
      String url_progress,
      String permintaan,
      String kategori,
      String duedate) {
    _tecKeterangan.value = TextEditingValue(
        text: keterangan,
        selection: TextSelection.fromPosition(
            TextPosition(offset: _tecKeterangan.text.length)));
    if (url_progress != null) {
      _tecUrlProgress.value = TextEditingValue(
          text: url_progress,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecUrlProgress.text.length)));
    }

    // ! ???? WTF code

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "UPDATE PROGRESS",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Kategori: ' + kategori,
                          style: TextStyle(fontSize: 14)),
                      Text('Due Date: ' + duedate,
                          style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Permintaan : ' + permintaan,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 5,
                  ),
                  TextFormField(
                      controller: _tecKeterangan,
                      decoration: InputDecoration(
                          icon: Icon(Icons.description_rounded),
                          labelText: 'Deskripsi Progres',
                          hintText: 'Masukkan Deskripsi',
                          suffixIcon:
                              Icon(Icons.check_circle_outline_outlined))),
                  TextFormField(
                      controller: _tecUrlProgress,
                      decoration: InputDecoration(
                          icon: Icon(Icons.link_rounded),
                          labelText: 'Sematkan URL',
                          hintText: 'Masukkan URL')),
                  SizedBox(
                    height: 15.0,
                  ),
                  StatefulBuilder(builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    return Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Next User ? '),
                              Switch(
                                onChanged: (bool value) {
                                  // value == true ? 'selesai' : 'data';
                                  setState(() {
                                    nextuser = value;
                                    if (nextuser) {
                                      tipe =
                                          'ubah'; // * sebagai flag untuk trigger kondisi execute url
                                      tipeinsert =
                                          'nextuser'; // * sebagai flag untuk dikirim ke api
                                    } else {
                                      tipe =
                                          'selesai'; // * sebagai flag untuk trigger kondisi execute url
                                      tipeinsert =
                                          'selesai'; // * sebagai flag untuk dikirim ke api
                                    }
                                  });
                                },
                                activeTrackColor: thirdcolor,
                                activeColor: Colors.green,
                                value: nextuser,
                              ),
                              nextuser == true
                                  ? Container(
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildKomboPengguna(
                                              _mypengguna.toString())
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      height: 0,
                                    ),
                            ],
                          ),
                          nextuser == true
                              ? TextFormField(
                                  controller: _tecKeteranganNext,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.note_add_rounded),
                                      labelText: 'Keterangan Next Progress',
                                      hintText: 'Masukkan Deskripsi',
                                      suffixIcon: Icon(
                                          Icons.check_circle_outline_outlined)))
                              : SizedBox(
                                  height: 0,
                                ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ProgressModalBottom().modalKonfirmasi(
                            context,
                            tipe,
                            token,
                            _tecKeterangan.text.toString(),
                            idpermintaan,
                            tipeinsert,
                            idprogress,
                            "1",
                            _mypengguna == null ? "0" : _mypengguna.toString(),
                            _tecKeteranganNext.text.toString(),
                            _tecUrlProgress.text.toString());

                        _tecKeterangan.clear();
                        _tecUrlProgress.clear();
                        _tecKeteranganNext.clear();
                      },
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(width: 2, color: Colors.blue),
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          primary: Colors.white),
                      child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0)),
                          child: Container(
                            width: 325,
                            height: 45,
                            alignment: Alignment.center,
                            child: Text('SELESAIKAN PROGRES',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimelinePage(
                                      idpermintaan: idpermintaan.toString(),
                                    )));
                      },
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(width: 2, color: Colors.orange),
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          primary: Colors.white),
                      child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0)),
                          child: Container(
                            width: 325,
                            height: 45,
                            alignment: Alignment.center,
                            child: Text('LIHAT TIMELINE',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ))),
                ],
              ),
            ),
          );
        });
    // ! END WTF CODE
  }
}
