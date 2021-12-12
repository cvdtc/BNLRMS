import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/request/request.model.dart';
import 'package:rmsmobile/pages/login/login.dart';
import 'package:rmsmobile/pages/request/request.bottom.dart';

import 'package:rmsmobile/pages/request/request.network.dart';
import 'package:rmsmobile/pages/request/request.tile.dart';
import 'package:rmsmobile/utils/ReusableClasses.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestPageSearch extends StatefulWidget {
  @override
  _RequestPageSearchState createState() => _RequestPageSearchState();
}

class _RequestPageSearchState extends State<RequestPageSearch> {
  late SharedPreferences sp;
  String? defaultKategori = 'Merek';
  String? jenisKategori = 'Merek';
  String? tipe = "";
  String? keterangan = "";
  String? kategori = "";
  String? duedate = "";
  String? flag_selesai = "";
  String? idpermintaan = "";
  String? keterangan_selesai = "";
  String? tipeupdate = "";
  // dynamic cekid;
  int? pilihkategori;
  var dataKategori = ['Merek', 'Paten', 'Desain Industri', 'Lainnya'];
  String? token = "", username = "", jabatan = "", flagcari = '0';
  List<RequestModel> _requests = <RequestModel>[];
  List<RequestModel> _requestDisplay = <RequestModel>[];

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
      username = sp.getString("username");
      jabatan = sp.getString("jabatan");
    });
    fetchKomponen(token!).then((value) {
      setState(() {
        _isLoading = false;
        _requests.addAll(value);
        _requestDisplay = _requests;
        print(_requestDisplay.length);
      });
    }).onError((error, stackTrace) {
      print("REQUEST STATUS CODE?" + error.toString());
      ReusableClasses().clearSharedPreferences();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Loginscreen(
                    tipe: 'sesiberakhir',
                  )));
    });
  }

  Future refreshPage() async {
    await Future.delayed(Duration(seconds: 2));
    Fluttertoast.showToast(
        msg: "Data Berhasil diperbarui",
        backgroundColor: Colors.black,
        textColor: Colors.white);
    setState(() {
      cekToken();
    });
  }

  @override
  initState() {
    defaultKategori = dataKategori[0];
    if (defaultKategori == 'Merek') {
      defaultKategori = dataKategori[0];
    } else if (defaultKategori == 'Paten') {
      defaultKategori = dataKategori[1];
    } else if (defaultKategori == 'Desain Industri') {
      defaultKategori = dataKategori[2];
    } else if (defaultKategori == 'Hak Cipta') {
      defaultKategori = dataKategori[3];
    }
    cekToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                // openFilterDialog(context);
              },
              icon: Icon(
                Icons.filter_list_outlined,
                color: Colors.black87,
              ))
        ],
        title: Text(
          'Daftar Permintaan',
          style: GoogleFonts.lato(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: thirdcolor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          RequestModalBottom().modalAddSite(
              context,
              'tambah',
              token!,
              keterangan!,
              kategori!,
              duedate!,
              flag_selesai!,
              idpermintaan!,
              keterangan_selesai!,
              tipeupdate!);
        },
        backgroundColor: thirdcolor,
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: Text(
          'Tambah Permintaan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshPage,
        child: SafeArea(
          child: Container(
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (!_isLoading) {
                  return index == 0
                      ? _searchBar()
                      : StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                          return RequestTile(
                            request: this._requestDisplay[index - 1],
                            token: token!,
                          );
                        });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
              itemCount: _requestDisplay.length + 1,
            ),
          ),
        ),
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: TextField(
        autofocus: false,
        onChanged: (searchText) {
          searchText = searchText.toLowerCase();
          setState(() {
            _requestDisplay = _requests.where((u) {
              var fNama = u.nama_request.toLowerCase();
              var fKeterangan = u.keterangan.toLowerCase();
              var fkategori = u.kategori.toLowerCase();
              return fNama.contains(searchText) ||
                  fKeterangan.contains(searchText) ||
                  fkategori.contains(searchText);
            }).toList();
          });
        },
        // controller: _textController,
        decoration: InputDecoration(
          fillColor: thirdcolor,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          hintText: 'Cari Permintaan',
        ),
      ),
    );
  }
}
