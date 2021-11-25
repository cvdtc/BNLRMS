import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/pengguna/pengguna.model.dart';
import 'package:rmsmobile/model/progress/progress.model.dart';
import 'package:rmsmobile/pages/progres/pengguna.combo.network.dart';
import 'package:http/http.dart' as client;

class ProgressTile extends StatefulWidget {
  late final ProgressModel progress;
  final String token;
  ProgressTile({required this.progress, required this.token});

  @override
  State<ProgressTile> createState() => _ProgressTileState();
}

class _ProgressTileState extends State<ProgressTile> {
  ApiService _apiService = new ApiService();
  String? token, keterangan, kategori, duedate;
  String  valpengguna = "Paten";
  TextEditingController _tecKeterangan = TextEditingController(text: "");
  TextEditingController _controlleridpengguna = TextEditingController();

  List<PenggunaModel> _penggunaDisplay = <PenggunaModel>[];
  void getcomboPengguna() async {
    var url = Uri.parse(_apiService.baseUrl + 'pengguna');
    var response =
        await client.get(url, headers: {"Authorization": "BEARER ${token}"});
    // var listdata = json.decode(response.body);
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> data = map['data'];
    print('here we go ${data[0]['nama']} + ${data[0]}');
    setState(() {
      data = _penggunaDisplay;
      print('dataz $data');
    });
  }

  @override
  void initState() {
    print('penggunadisplay $_penggunaDisplay');
    _penggunaDisplay;
    getcomboPengguna();
    // cekPengguna();
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
                showModalBottomSheet(
                    context: context,
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
                              Row(
                                children: [
                                  Text('Pilih Kategori '),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  DropdownButton(
                                    dropdownColor: Colors.white,
                                    value: valpengguna,
                                    icon: Icon(Icons.arrow_drop_down),
                                    onChanged: (String? value) {
                                      // setState(() {
                                      valpengguna = value!;
                                      print("Value Dropdown? " + value);
                                      // });
                                    },
                                    items: _penggunaDisplay.map((e){
                                      return DropdownMenuItem(
                                        child: Text("${e.nama}"),
                                        value: e.idpengguna.toString(),
                                        );
                                    }).toList()
                                  )
                                ],
                              ),
                              // _buildKomboPengguna(valpengguna.toString()),
                              SizedBox(
                                height: 15.0,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    // Navigator.of(context).pop();
                                    // modalAddSite(context, 'progres', token, keterangan, '',
                                    //     '', '0', idpermintaan.toString(), '', 'data');
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
    _controlleridpengguna = TextEditingController(text: pengguna1);
    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      hint: Text('Pilih next user'),
      value: valpengguna,
      // icon: Icon(Icons.arrow_drop_down),
      onChanged: (String? value) {
        setState(() {
          valpengguna = value!;
        });
      },
      items: _penggunaDisplay.map((item) {
        return DropdownMenuItem(
          child: Text("${['nama']}"),
          value: item.idpengguna.toString(),
        );
      }).toList(),
    );
    // return DropdownButtonFormField(
    //   dropdownColor: Colors.white,
    //   hint: Text("Pilih Next Progres"),
    //   value: valpengguna,
    //   items: _penggunaDisplay.map((item) {
    //     return DropdownMenuItem(
    //       child: Text("${item.nama}"),
    //       value: item.idpengguna.toString(),
    //     );
    //   }).toList(),
    //   onChanged: (String? newvalue) {
    //     setState(() {
    //       valpengguna = newvalue.toString();
    //     });
    //   },
    // );
  }
}
