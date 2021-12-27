import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmsmobile/model/request/request.model.dart';
import 'package:rmsmobile/pages/login/login.dart';
import 'package:rmsmobile/pages/request/request.bottom.dart';

import 'package:rmsmobile/pages/request/request.network.dart';
import 'package:rmsmobile/pages/request/request.tile.dart';
import 'package:rmsmobile/utils/ReusableClasses.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:rmsmobile/widget/bottomnavigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestPageSearch extends StatefulWidget {
  @override
  RequestPageSearchState createState() => RequestPageSearchState();
}

class RequestPageSearchState extends State<RequestPageSearch> {
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
  TextEditingController _textSearch = TextEditingController(text: "");
  // dynamic cekid;
  int? pilihkategori;
  var dataKategori = ['Merek', 'Paten', 'Desain Industri', 'Lainnya'];
  var token = "", flagcari = '0';
  List<RequestModel> _requests = <RequestModel>[];
  List<RequestModel> _requestDisplay = <RequestModel>[];

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString('access_token')!;
    });
    await fetchPermintaan(token).then((value) {
      setState(() {
        _isLoading = false;
        _requests.clear();
        _requests.addAll(value);
        _requestDisplay = _requests;
      });
    }).onError((error, stackTrace) {
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
    _requestDisplay.clear();
    _textSearch.clear();
    setState(() {
      cekToken();
    });
    // await Future.delayed(Duration(seconds: 2));
    Fluttertoast.showToast(
        msg: "Data Berhasil diperbarui",
        backgroundColor: Colors.black,
        textColor: Colors.white);
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
                refreshPage();
                // openFilterDialog(context);
              },
              icon: Icon(
                Icons.refresh_outlined,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => BottomNav(
          //               numberOfpage: 2,
          //             )));
          RequestModalBottom().modalAddRequest(
              context, 'tambah', token, "", "", "", "", "", "", "");
        },
        backgroundColor: thirdcolor,
        child: Icon(
          Icons.add,
          color: Colors.white,
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
                            token: token,
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
        controller: _textSearch,
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
