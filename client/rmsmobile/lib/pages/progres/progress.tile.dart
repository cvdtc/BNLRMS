import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/pengguna/pengguna.model.dart';
import 'package:rmsmobile/model/progress/progress.edit.selesai.model.dart';
import 'package:rmsmobile/model/progress/progress.model.dart';
import 'package:http/http.dart' as client;
import 'package:rmsmobile/utils/warna.dart';

class Country {
  final String countryCode;
  final String countryName;

  Country({required this.countryCode, required this.countryName});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      countryCode: json['idpengguna'],
      countryName: json['nama'],
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
  String? token,
      keterangan,
      kategori,
      duedate,
      next_idpengguna,
      flag_selesai,
      idprogress;
  String valpengguna = "Paten";
  TextEditingController _tecKeterangan = TextEditingController(text: "");
  TextEditingController _controlleridpengguna = TextEditingController();

  List<PenggunaModel> _penggunaDisplay = <PenggunaModel>[];

  List? pnggunaList;
  String? _mypengguna;
  Future<String?> _pngguna() async {
    var url = Uri.parse(_apiService.baseUrl + 'pengguna');
    final response =
        await client.get(url, headers: {"Authorization": "BEARER ${token}"});
    var dataz = json.decode(response.body);
    setState(() {
      pnggunaList = dataz['data'];
    });
  }

  @override
  void initState() {
    _mypengguna;
    _pngguna();
    _penggunaDisplay;
    super.initState();
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
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Deskripsi : ' + widget.progress.keterangan,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text('Kategori: ' + widget.progress.kategori,
                                    style: TextStyle(fontSize: 16)),
                                Text('Due Date: ' + widget.progress.due_date,
                                    style: TextStyle(fontSize: 16)),
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
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 5),
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildKomboPengguna(
                                          _mypengguna.toString())
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      print('heyyuuu $_mypengguna');
                                      if (keterangan == "" ||
                                          _mypengguna == null) {
                                        _modalbottomSite(
                                            context,
                                            "Tidak Valid!",
                                            "Pastikan semua kolom terisi dengan benar",
                                            'f405',
                                            'assets/images/sorry.png');
                                      }
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
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                                              FontWeight.bold),
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
                                                                      BorderRadius
                                                                          .circular(
                                                                              18)),
                                                              child: Container(
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
                                                              ProgressModelEdit
                                                                  modeledit =
                                                                  ProgressModelEdit(
                                                                      keterangan:
                                                                          keterangan,
                                                                      next_idpengguna:
                                                                          _mypengguna,
                                                                      flag_selesai:
                                                                          '1');
                                                              print(
                                                                  'dataselesai $modeledit');
                                                              _apiService
                                                                  .ubahProgresJadiSelesai(
                                                                      token
                                                                          .toString(),
                                                                      idprogress
                                                                          .toString(),
                                                                      modeledit)
                                                                  .then(
                                                                      (isSuccess) {
                                                                if (isSuccess) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  // _tecNama.clear();
                                                                  // _tecKeterangan.clear();
                                                                  _modalbottomSite(
                                                                      context,
                                                                      "Berhasil!",
                                                                      "${_apiService.responseCode.messageApi}",
                                                                      "f200",
                                                                      "assets/images/congratulations.png");
                                                                } else {
                                                                  _modalbottomSite(
                                                                      context,
                                                                      "Gagal!",
                                                                      "${_apiService.responseCode.messageApi}",
                                                                      "f400",
                                                                      "assets/images/sorry.png");
                                                                }
                                                                return;
                                                              });
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              elevation: 0.0,
                                                              primary:
                                                                  Colors.white,
                                                            ),
                                                            child: Ink(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18)),
                                                              child: Container(
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
                              ],
                            ),
                          ),
                        );
                      });
                });

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
                      children: [
                        Text('Permintaan : ', style: TextStyle(fontSize: 18.0)),
                        Text(widget.progress.permintaan,
                            style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text('Kategori : ' + widget.progress.kategori,
                            style: TextStyle(fontSize: 18.0)),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Keterangan : ' + widget.progress.keterangan,
                        style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              ),
            )));
  }

  Widget _buildKomboPengguna(String pengguna1) {
    // _controlleridpengguna = TextEditingController(text: pengguna1);
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: _mypengguna,
            iconSize: 30,
            icon: Icon(Icons.arrow_drop_down),
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
            hint: Text('Pilih Pengguna Selanjutnya'),
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
