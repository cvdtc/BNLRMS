import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmsmobile/model/perpanjangan/perpanjangan.model.dart';
import 'package:rmsmobile/pages/login/login.dart';
import 'package:rmsmobile/pages/perpanjangan/perpanjangan.network.dart';
import 'package:rmsmobile/pages/perpanjangan/perpanjangan.tile.dart';
import 'package:rmsmobile/utils/ReusableClasses.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerpanjanganPageSearch extends StatefulWidget {
  @override
  PerpanjanganPageSearchState createState() => PerpanjanganPageSearchState();
}

class PerpanjanganPageSearchState extends State<PerpanjanganPageSearch> {
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
  List<PerpanjanganModel> _perpanjangan = <PerpanjanganModel>[];
  List<PerpanjanganModel> _perpanjanganDisplay = <PerpanjanganModel>[];

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString('access_token')!;
    });
    await fetchPerpanjangan(token).then((value) {
      setState(() {
        _isLoading = false;
        _perpanjangan.clear();
        _perpanjangan.addAll(value);
        _perpanjanganDisplay = _perpanjangan;
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
    _perpanjanganDisplay.clear();
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
          'Daftar Perpanjangan',
          style: GoogleFonts.lato(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: thirdcolor,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => BottomNav(
          //               numberOfpage: 2,
          //             )));
      //     RequestModalBottom().modalAddRequest(
      //         context, 'tambah', token, "", "", "", "", "", "", "");
      //   },
      //   backgroundColor: thirdcolor,
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // ),
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
                          return PerpanjanganTile(
                            perpanjangan: this._perpanjanganDisplay[index - 1],
                            token: token,
                          );
                        });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
              itemCount: _perpanjanganDisplay.length + 1,
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
            _perpanjanganDisplay = _perpanjangan.where((u) {
              var fNama = u.nama.toLowerCase();
              var fproduk = u.produk.toLowerCase();
              return fNama.contains(searchText) ||
                  fNama.contains(searchText) ||
                  fproduk.contains(searchText);
            }).toList();
          });
        },
        controller: _textSearch,
        decoration: InputDecoration(
          fillColor: thirdcolor,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          hintText: 'Cari Perpanjangan',
        ),
      ),
    );
  }
}
