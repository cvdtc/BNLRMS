import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmsmobile/model/request/request.model.dart';
import 'package:rmsmobile/pages/request/request.bottom.dart';

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
  String? defaultKategori = 'Patent';
  String? jenisKategori = 'Patent';
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
  var dataKategori = ['Patent', 'Merek', 'Desain Industri', 'Lainnya'];
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
    // if (token == null) {
    //   Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => Loginscreen()));
    // }
    fetchKomponen(token!).then((value) {
      setState(() {
        _isLoading = false;
        _requests.addAll(value);
        _requestDisplay = _requests;
        print(_requestDisplay.length);
      });
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

  // var controllers = Get.put(SelectedListController());
  // void openFilterDialog(context) async{
  //   await FilterListDialog.display<RequestModel>(
  //     context,
  //     listData: _requestDisplay,
  //     selectedListData: controllers.selectedList,
  //     headlineText: 'Pilih Kategori',
  //     closeIconColor: Colors.grey,
  //     applyButtonTextStyle: TextStyle(fontSize: 20),
  //     choiceChipLabel: (item)=> item.toString(),
  //     validateSelectedItem: (list, val)=>list!.contains(val),
  //     onItemSearch: (list, text){
  //       if (list!.any((element) => element.toString().toLowerCase().contains(text.toLowerCase()))) {
  //         return list.where((element) => element.kategori().toLowerCase().contains(text.toLowerCase())).toList();
  //       } else {
  //         return [];
  //       }
  //     },
  //     onApplyButtonClick: (list){
  //       controllers.selectedList.value =(List<RequestModel>.from(list!));
  //       Navigator.of(context).pop();
  //     });
  // }

  @override
  initState() {
    defaultKategori = dataKategori[0];
    if (defaultKategori == 'Patent') {
      defaultKategori = dataKategori[0];
    } else if (defaultKategori == 'Merek') {
      defaultKategori = dataKategori[1];
    } else if (defaultKategori == 'Desain Industri') {
      defaultKategori = dataKategori[2];
    } else if (defaultKategori == 'Lainnya') {
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
          ReusableClass().modalAddSite(
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
        label: Text(
          'Tambah Permintaan',
          style: TextStyle(color: Colors.black),
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

  // Widget _buildKomboPermintaan(String produks) {
  //   return DropdownButtonFormField(
  //     dropdownColor: Colors.white,
  //     hint: Padding(
  //         padding: EdgeInsets.only(left: 10),
  //         child: Row(
  //           children: [
  //             Icon(
  //               Icons.search,
  //             ),
  //             SizedBox(
  //               width: 7,
  //             ),
  //             Text("$defaultKategori",
  //                 textAlign: TextAlign.end,
  //                 style:
  //                     GoogleFonts.inter(color: Colors.grey[800], fontSize: 14)),
  //           ],
  //         )),
  //     value:
  //         pilihkategori == null ? null : dataKategori.join("$defaultKategori"),
  //     decoration: InputDecoration(
  //         fillColor: Colors.grey[200],
  //         filled: true,
  //         border: const OutlineInputBorder(),
  //         enabledBorder: OutlineInputBorder(
  //             borderSide:
  //                 const BorderSide(color: Colors.transparent, width: 0.0),
  //             borderRadius: BorderRadius.circular(5.0)),
  //         isDense: true,
  //         contentPadding:
  //             const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 5.0)),
  //     items: dataKategori.map((String value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: Padding(
  //           padding: const EdgeInsets.only(left: 10),
  //           child: new Text(value,
  //               style:
  //                   GoogleFonts.inter(color: Colors.grey[800], fontSize: 14)),
  //         ),
  //       );
  //     }).toList(),
  //     onChanged: (value) {
  //       setState(() {
  //         print('object value $value');
  //         defaultKategori = value.toString();
  //         if (value == null) {
  //           return null;
  //         } else if (defaultKategori == 'Patent') {
  //           cekid = '0';
  //         } else if (defaultKategori == 'Merek') {
  //           cekid = '1';
  //         } else if (defaultKategori == 'Desain Industri') {
  //           cekid = '2';
  //         } else if (defaultKategori == 'Lainnya') {
  //           cekid = '3';
  //         }
  //         print('IDNYa $cekid');
  //       });
  //     },
  //   );
  // }

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
