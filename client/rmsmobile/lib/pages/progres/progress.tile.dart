import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/pengguna/pengguna.model.dart';
import 'package:rmsmobile/model/progress/progress.edit.selesai.model.dart';
import 'package:rmsmobile/model/progress/progress.model.add.dart';
import 'package:rmsmobile/model/progress/progress.model.dart';
import 'package:http/http.dart' as client;
import 'package:rmsmobile/pages/request/request.bottom.dart';
import 'package:rmsmobile/pages/timeline/timeline.dart';
import 'package:rmsmobile/utils/ReusableClasses.dart';
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
      idpermintaan = "";
  String valpengguna = "Paten";
  TextEditingController _tecKeterangan = TextEditingController(text: "");
  TextEditingController _tecKeteranganNext = TextEditingController(text: "");
  bool isSelesai = false;
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
    print(dataz.toString());
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
                setState(() {
                  // ! ???? WTF code
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
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
                                Text('DETAIL PROGRES',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Deskripsi : ' + widget.progress.keterangan,
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text('Kategori: ' + widget.progress.kategori,
                                    style: TextStyle(fontSize: 14)),
                                Text('Due Date: ' + widget.progress.due_date,
                                    style: TextStyle(fontSize: 14)),
                                SizedBox(
                                  height: 10,
                                ),
                                Divider(
                                  height: 5,
                                ),
                                TextFormField(
                                    controller: _tecKeterangan,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.cabin_rounded),
                                        labelText: 'Keterangan Progres',
                                        hintText: 'Masukkan Deskripsi',
                                        suffixIcon: Icon(Icons
                                            .check_circle_outline_outlined))),
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
                                                  isSelesai = value;
                                                });
                                                print(
                                                    'telah diswitch $value + $isSelesai');
                                              },
                                              activeTrackColor: thirdcolor,
                                              activeColor: Colors.green,
                                              value: isSelesai,
                                            ),
                                            isSelesai == true
                                                ? Container(
                                                    // padding: EdgeInsets.only(
                                                    //     left: 15,
                                                    //     right: 15,
                                                    //     top: 5),
                                                    color: Colors.white,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        _buildKomboPengguna(
                                                            _mypengguna
                                                                .toString())
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height: 0,
                                                  ),
                                          ],
                                        ),
                                        isSelesai == true
                                            ? TextFormField(
                                                controller: _tecKeteranganNext,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .characters,
                                                decoration: InputDecoration(
                                                    icon: Icon(
                                                        Icons.cabin_rounded),
                                                    labelText:
                                                        'Keterangan Next Progress',
                                                    hintText:
                                                        'Masukkan Deskripsi',
                                                    suffixIcon: Icon(Icons
                                                        .check_circle_outline_outlined)))
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
                                      print(
                                          'heyyuuu $_mypengguna $keterangan ${_tecKeterangan.text}');
                                      if (_tecKeterangan.text.toString() ==
                                          "") {
                                        _modalbottomSite(
                                            context,
                                            "Tidak Valid!",
                                            "Pastikan semua kolom terisi dengan benar",
                                            'f405',
                                            'assets/images/sorry.png');
                                      } else {
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15.0),
                                                    topRight:
                                                        Radius.circular(15.0))),
                                            builder: (BuildContext context) {
                                              return Padding(
                                                padding: MediaQuery.of(context)
                                                    .viewInsets,
                                                child: Container(
                                                  padding: EdgeInsets.all(15.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        'Konfirmasi Selesai',
                                                        style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                          'Apakah anda yakin akan menyelesaikan tugas ini ? ',
                                                          style: TextStyle(
                                                              fontSize: 16)),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                elevation: 0.0,
                                                                primary:
                                                                    Colors.red,
                                                              ),
                                                              child: Ink(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18)),
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    "Batal",
                                                                  ),
                                                                ),
                                                              )),
                                                          SizedBox(
                                                            width: 55,
                                                          ),
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                print(
                                                                    'keterangannya ${_tecKeterangan.text} $token');
                                                                ProgressModelEdit modeledit = ProgressModelEdit(
                                                                    keterangan:
                                                                        _tecKeterangan
                                                                            .text
                                                                            .toString(),
                                                                    flag_selesai:
                                                                        '1',
                                                                    next_idpengguna:
                                                                        _mypengguna);

                                                                ProgressModelAdd modelAdd = ProgressModelAdd(
                                                                    keterangan: _tecKeteranganNext
                                                                        .text
                                                                        .toString(),
                                                                    idpermintaan: widget
                                                                        .progress
                                                                        .idpermintaan,
                                                                    idnextuser:
                                                                        _mypengguna,
                                                                    tipe:
                                                                        'nextuser');
                                                                print(
                                                                    'dataselesai $modeledit idprogress $idprogress modeladd $modelAdd');
                                                                _apiService
                                                                    .ubahProgresJadiSelesai(
                                                                        token
                                                                            .toString(),
                                                                        idprogress
                                                                            .toString(),
                                                                        modeledit)
                                                                    .then(
                                                                        (isSuccess) {
                                                                  print(
                                                                      'disini sukses nggak ?');
                                                                  if (isSuccess) {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "Berhasil ubah data progres selesai",
                                                                        backgroundColor:
                                                                            Colors
                                                                                .black,
                                                                        textColor:
                                                                            Colors.white);
                                                                    _tecKeterangan
                                                                        .clear();
                                                                    _apiService
                                                                        .addProgres(
                                                                            token
                                                                                .toString(),
                                                                            modelAdd)
                                                                        .then(
                                                                            (value) {
                                                                      print(
                                                                          'tes progres piye ? $modeledit $modelAdd');
                                                                      print(
                                                                          'disini sukses nggak1 ?');
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      Fluttertoast.showToast(
                                                                          msg:
                                                                              "Berhasil ubah data progres ke next user",
                                                                          backgroundColor: Colors
                                                                              .black,
                                                                          textColor:
                                                                              Colors.white);
                                                                    });
                                                                  } else {
                                                                    _modalbottomSite(
                                                                        context,
                                                                        "Gagal!",
                                                                        "${_apiService.responseCode.messageApi}",
                                                                        "f400",
                                                                        "assets/images/sorry.png");
                                                                  }
                                                                  return;
                                                                }).onError((error,
                                                                        stackTrace) {
                                                                  print("ERROR PROGRESS" +
                                                                      error
                                                                          .toString());
                                                                });
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                elevation: 0.0,
                                                                primary: Colors
                                                                    .white,
                                                              ),
                                                              child: Ink(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18)),
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    "Submit",
                                                                    style: TextStyle(
                                                                        color:
                                                                            primarycolor),
                                                                  ),
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            width: 2, color: Colors.blue),
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        primary: Colors.white),
                                    child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.0)),
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
                                              builder: (context) =>
                                                  TimelinePage(
                                                    idpermintaan:
                                                        idpermintaan.toString(),
                                                  )));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            width: 2, color: Colors.orange),
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        primary: Colors.white),
                                    child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.0)),
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
                });
                // ! END WTF CODE
                // ReusableClassProgress().modalActionItem(
                //     context,
                //     widget.token,
                //     widget.progress.keterangan,
                //     widget.progress.due_date,
                //     widget.progress.kategori,
                //     widget.progress.idpermintaan.toString());
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
                        'Permintaan : ' +
                            widget.progress.permintaan.toString().toUpperCase(),
                        style: TextStyle(fontSize: 16.0)),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'tgl. akhir : ' +
                          widget.progress.due_date.toString().toUpperCase(),
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
                  print('penggunanya $_mypengguna');
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

  _modalbottomSite(context, String title, String message, String kode,
      String imagelocation) {
    print('Yash im show');
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
}
