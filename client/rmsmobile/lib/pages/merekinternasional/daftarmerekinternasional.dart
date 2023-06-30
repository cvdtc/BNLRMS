import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmsmobile/model/merekinternasional/merekinternasional.dart';
import 'package:rmsmobile/pages/merekinternasional/daftarmerekinternasional.tile.dart';
import 'package:rmsmobile/pages/merekinternasional/networkmerekinternasional.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/warna.dart';

class DaftarMerekInternasional extends StatefulWidget {
  const DaftarMerekInternasional({Key? key}) : super(key: key);

  @override
  State<DaftarMerekInternasional> createState() =>
      _DaftarMerekInternasionalState();
}

class _DaftarMerekInternasionalState extends State<DaftarMerekInternasional> {
  late SharedPreferences sp;
  TextEditingController _textSearch = TextEditingController(text: "");
  var token = "";
  List<MerekInternasionalModel> _dataList = <MerekInternasionalModel>[];
  List<MerekInternasionalModel> _dataListDisplay = <MerekInternasionalModel>[];

  DateTime? tanggal_awal;
  DateTime? tanggal_akhir;

  /// for set value listview to this variable
  var valuelistview;

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString('access_token')!;
    });
    await fetchMerekInternasional(token).then((value) {
      setState(() {
        _isLoading = false;
        _dataList.clear();
        valuelistview = value;
        _dataList.addAll(valuelistview);
        _dataListDisplay = _dataList;
      });
    }).onError((error, stackTrace) {
      print(error.toString() + ' -- ' + stackTrace.toString());
    });
  }

  Future refreshPage() async {
    _dataListDisplay.clear();
    setState(() {
      cekToken();
    });
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
        title: Text(
          'Daftar Permintaan',
          style: GoogleFonts.lato(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: backgroundcolor,
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
                          return MerekInternasionalTile(
                            merekInternasional:
                                this._dataListDisplay[index - 1],
                            token: token,
                          );
                        });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
              itemCount: _dataListDisplay.length + 1,
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
            // _dataListDisplay = _dataList.where((u) {
            // var fNama = u.data.toLowerCase();
            // var fKeterangan = u.keterangan.toLowerCase();
            // var fkategori = u.kategori.toLowerCase();
            // return fNama.contains(searchText) ||
            //     fKeterangan.contains(searchText) ||
            //     fkategori.contains(searchText);
            // }).toList();
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
