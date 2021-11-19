import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmsmobile/model/request/request.model.dart';
import 'package:rmsmobile/pages/request/bottom.dart';
import 'package:rmsmobile/pages/request/request.network.dart';
import 'package:rmsmobile/pages/request/request.tile.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestPageSearch extends StatefulWidget {
  @override
  _RequestPageSearchState createState() => _RequestPageSearchState();
}

class _RequestPageSearchState extends State<RequestPageSearch> {
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "";
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
    });
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
          IconButton(onPressed: () {}, icon: Icon(Icons.workspaces_outlined))
        ],
        title: Text(
          'Daftar Permintaan',
          style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: thirdcolor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ReusableClass().modalAddSite(context, 'ubah', token!, "", "", "", "");
          // RequestBottom()
          //     .modalAddRequest(context, "tambah", token!, "", "", "", "0");
        },
        backgroundColor: thirdcolor,
        label: Text(
          'Tambah Permintaan',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (!_isLoading) {
                return index == 0
                    ? _searchBar()
                    : RequestTile(
                        request: this._requestDisplay[index - 1],
                        token: token!,
                      );
                // : SiteTile(site: this._sitesDisplay[index - 1]);
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
          hintText: 'Cari Komponen',
        ),
      ),
    );
  }
}
