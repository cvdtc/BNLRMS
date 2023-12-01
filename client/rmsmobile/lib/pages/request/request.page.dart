import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rmsmobile/model/request/filterrequest.model.dart';
import 'package:rmsmobile/model/request/request.model.dart';
import 'package:rmsmobile/pages/request/request.bottom.dart';
import 'package:http/http.dart' as client;
import 'package:rmsmobile/pages/request/request.network.dart';
import 'package:rmsmobile/pages/request/request.tile.dart';
import 'package:rmsmobile/utils/warna.dart';
// import 'package:rmsmobile/widget/bottomnavigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiService/apiService.dart';
import '../webview/inappwebviewpage.dart';

class RequestPageSearch extends StatefulWidget {
  @override
  RequestPageSearchState createState() => RequestPageSearchState();
}

class RequestPageSearchState extends State<RequestPageSearch> {
  late SharedPreferences sp;
  String? defaultKategori = 'Merek';
  String? tipe = "";
  String? keterangan = "";
  String? kategori = "";
  String? duedate = "";
  String? flag_selesai = "";
  String? idpermintaan = "";
  String? keterangan_selesai = "";
  String? tipeupdate = "";
  String idpengguna = "";
  TextEditingController _textSearch = TextEditingController(text: "");
  TextEditingController _tecTanggalAwal = TextEditingController(text: "");
  TextEditingController _tecTanggalAkhir = TextEditingController(text: "");
  TextEditingController _tecKeyword = TextEditingController(text: "");
  TextEditingController _tecKeterangan = TextEditingController(text: "");
  TextEditingController _tecDueDate = TextEditingController(text: "");
  TextEditingController _tecKeteranganSelesai = TextEditingController(text: "");
  TextEditingController _tecUrlPermintaan = TextEditingController(text: "");

  TextEditingController _tecKeteranganNext = TextEditingController(text: "");
  DateTime selectedDate = DateTime.now();
  // dynamic cekid;
  int? pilihkategori;
  bool nextuser = false;
  var dataKategori = ['Merek', 'Paten', 'Desain Industri', 'Lainnya'];
  var token = "",
      flagcari = '0',
      tanggal = '',
      _dropdownValue = "Merek",
      _dropdownValueFilter = "";
  List<RequestModel> _requests = <RequestModel>[];
  List<RequestModel> _requestDisplay = <RequestModel>[];

  DateTime? tanggal_awal;
  DateTime? tanggal_akhir;

  /// for set value listview to this variable
  var valuelistview;

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    // setState(() {
    token = sp.getString('access_token')!;
    idpengguna = sp.getString('idpengguna')!;
    // });
    FilterRequest data = FilterRequest(
        tanggal_awal: _tecTanggalAwal.text.toString(),
        tanggal_akhir: _tecTanggalAkhir.text.toString(),
        keyword: _tecKeyword.text.toString(),
        kategori: _dropdownValueFilter.toString());
    print(data.toString());
    await fetchPermintaan(token, data).then((value) {
      setState(() {
        _isLoading = false;
        _requests.clear();
        valuelistview = value;
        _requests.addAll(valuelistview);
        _requestDisplay = _requests;
      });
      _pngguna(token);
    }).onError((error, stackTrace) {
      print(error.toString() + ' -- ' + stackTrace.toString());
      // ReusableClasses().clearSharedPreferences();
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => Loginscreen(
      //               tipe: 'sesiberakhir',
      //             )));
    });
  }

  var kategoriItems = [
    '',
    'Merek',
    'Merek - QC',
    'Merek - Permohonan',
    'Merek - Oposisi',
    'Merek - KO',
    'Merek - Sanggahan',
    'Merek - KBM',
    'Merek - Perpanjangan',
    'Merek - Lain Lain',
    'Merek - Upaya Lain2',
    'Paten',
    'Desain Industri',
    'Hak Cipta',
    'DI - Oposisi',
    'DI - KO'
  ];

  Future refreshPage() async {
    _requestDisplay.clear();
    _requests.clear();
    _textSearch.clear();
    // setState(() {
    cekToken();
    // });
    Fluttertoast.showToast(
        msg: "Data Berhasil diperbarui",
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  Future filterData() async {
    FilterRequest data = FilterRequest(
        tanggal_awal: _tecTanggalAwal.text.toString(),
        tanggal_akhir: _tecTanggalAkhir.text.toString(),
        keyword: _tecKeyword.text.toString(),
        kategori: _dropdownValueFilter.toString());
    await fetchPermintaan(token, data).then((value) {
      setState(() {
        _isLoading = false;
        _requests.clear();
        valuelistview = value;
        _requests.addAll(valuelistview);
        _requestDisplay = _requests;
      });
      _pngguna(token);
    }).onError((error, stackTrace) {
      print(error.toString() + ' -- ' + stackTrace.toString());
    });
  }

  ApiService _apiService = new ApiService();
  String? _mypengguna;
  List? pnggunaList;
  Future<String?> _pngguna(String token_pengguna) async {
    var url = Uri.parse(_apiService.baseUrl + 'pengguna');
    final response = await client
        .get(url, headers: {"Authorization": "BEARER ${token_pengguna}"});
    // .then((value) => print("Pengguna?" + value.toString()))
    // .onError((error, stackTrace) {
    //   ReusableClasses().modalbottomWarning(context, "Pengguna ",
    //       'Pengguna tidak ke load', 'f404', 'assets/images/sorry');
    // });
    var dataz = json.decode(response.body);
    setState(() {
      print('Data Pengguna?' + dataz.toString());
      pnggunaList = dataz['data'];
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
                refreshPage();
                // openFilterDialog(context);
              },
              icon: Icon(
                Icons.refresh_outlined,
                color: Colors.black87,
              )),
          IconButton(
              onPressed: () {
                filterBottom(context);
              },
              icon: Icon(
                Icons.filter_list_alt,
                color: Colors.black87,
              ))
        ],
        title: Text(
          'Daftar Permintaan',
          style: GoogleFonts.lato(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: backgroundcolor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => BottomNav(
          //               numberOfpage: 2,
          //             )));
          modalAddRequestDirect(
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
                            idpengguna: idpengguna,
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

  void filterBottom(context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
      builder: (BuildContext context) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'FILTER ',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        child: Column(
                          children: [
                            TextField(
                              controller: _tecTanggalAwal,
                              decoration: InputDecoration(
                                icon: Icon(Icons.date_range_outlined),
                                hintText: 'Tanggal Awal',
                                filled: true,
                              ),
                              readOnly: true,
                              onTap: () async {
                                tanggal_awal = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2015),
                                    lastDate: DateTime(2030));
                                setState(() {
                                  _tecTanggalAwal.text =
                                      DateFormat('yyyy-MM-dd')
                                          .format(tanggal_awal!)
                                          .toString();
                                });
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _tecTanggalAkhir,
                              decoration: InputDecoration(
                                icon: Icon(Icons.date_range_outlined),
                                hintText: 'Tanggal Akhir',
                                filled: true,
                              ),
                              readOnly: true,
                              onTap: () async {
                                tanggal_akhir = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2015),
                                    lastDate: DateTime(2030));
                                setState(() {
                                  _tecTanggalAkhir.text =
                                      DateFormat('yyyy-MM-dd')
                                          .format(tanggal_akhir!)
                                          .toString();
                                });
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _tecKeyword,
                              decoration: InputDecoration(
                                icon: Icon(Icons.key_rounded),
                                hintText: 'Keyword',
                                filled: true,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Kategori : ',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                DropdownButton(
                                    dropdownColor: Colors.white,
                                    value: _dropdownValueFilter,
                                    items: kategoriItems.map((String items) {
                                      return DropdownMenuItem(
                                          child: Text(items), value: items);
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        print(value);
                                        _dropdownValueFilter = value!;
                                      });
                                    }),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton.icon(
                                onPressed: () async {
                                  await refreshPage();
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.search),
                                label: Text('C A R I')),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Status : ',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _requests.clear();
                                      _requests.addAll(valuelistview);
                                      setState(() {
                                        _requests = _requestDisplay;
                                      });
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            width: 2, color: Colors.orange),
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        primary: Colors.white),
                                    child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.0)),
                                        child: Container(
                                          width: 75,
                                          height: 15,
                                          alignment: Alignment.center,
                                          child: Text('Semua',
                                              style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ))),
                                SizedBox(
                                  width: 5,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _requests.clear();
                                      _requests.addAll(valuelistview);
                                      _requestDisplay = _requests
                                          .where((element) => element
                                              .flag_selesai
                                              .toString()
                                              .contains('0'))
                                          .toList();
                                      setState(() {
                                        _requests = _requestDisplay;
                                      });
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            width: 2, color: Colors.blue),
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        primary: Colors.white),
                                    child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.0)),
                                        child: Container(
                                          width: 75,
                                          height: 15,
                                          alignment: Alignment.center,
                                          child: Text('Belum Selesai',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ))),
                                SizedBox(
                                  width: 5,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _requests.clear();
                                      _requests.addAll(valuelistview);
                                      _requestDisplay = _requests
                                          .where((element) => element
                                              .flag_selesai
                                              .toString()
                                              .contains('1'))
                                          .toList();
                                      setState(() {
                                        _requests = _requestDisplay;
                                      });
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            width: 2, color: Colors.green),
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        primary: Colors.white),
                                    child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.0)),
                                        child: Container(
                                          width: 75,
                                          height: 15,
                                          alignment: Alignment.center,
                                          child: Text('Selesai',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ))),
                                SizedBox(
                                  width: 5,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _requests.clear();
                                      _requests.addAll(valuelistview);
                                      _requestDisplay = _requests
                                          .where((element) => element
                                              .flag_selesai
                                              .toString()
                                              .contains('2'))
                                          .toList();
                                      setState(() {
                                        _requests = _requestDisplay;
                                      });
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            width: 2, color: Colors.red),
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        primary: Colors.white),
                                    child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.0)),
                                        child: Container(
                                          width: 75,
                                          height: 15,
                                          alignment: Alignment.center,
                                          child: Text('Tidak Selesai',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ))),
                              ]),
                        ),
                      )
                    ])));
      },
    );
  }

  // ++ BOTTOM MODAL INPUT FORM
  void modalAddRequestDirect(
      context,
      String tipe,
      String token,
      String keterangan,
      String kategori,
      String duedate,
      String flag_selesai,
      String idpermintaan,
      String keterangan_selesai,
      String url_permintaan) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tipe.toUpperCase() + " PERMINTAAN",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                            controller: _tecKeterangan,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                icon: Icon(Icons.description_rounded),
                                labelText: 'Deskripsi Permintaan',
                                hintText: 'Masukkan Deskripsi',
                                suffixIcon:
                                    Icon(Icons.check_circle_outline_outlined))),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                            controller: _tecUrlPermintaan,
                            decoration: InputDecoration(
                                icon: Icon(Icons.link_rounded),
                                labelText: 'Sematkan URL',
                                hintText: 'Masukkan URL',
                                suffixIcon:
                                    Icon(Icons.check_circle_outline_outlined))),
                        SizedBox(
                          height: 10.0,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WebviewPage(
                                            data_url: 'https://merek.id/',
                                          )));
                            },
                            child: Text('Cari di Merek.id')),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.4,
                              child: TextFormField(
                                  enabled: false,
                                  controller: _tecDueDate,
                                  textCapitalization: TextCapitalization.words,
                                  onSaved: (String? val) {
                                    tanggal = val.toString();
                                  },
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.date_range_rounded),
                                      labelText: 'Pilih Tanggal Tenggat',
                                      hintText: 'Pilih Tanggal',
                                      suffixIcon: Icon(Icons
                                          .check_circle_outline_outlined))),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2900),
                                      builder: (context, picker) {
                                        return Theme(
                                            data: ThemeData.dark().copyWith(
                                                colorScheme: ColorScheme.dark(
                                                    primary: Colors.deepOrange,
                                                    onPrimary: Colors.white,
                                                    surface: Colors.white70,
                                                    onSurface: Colors.green),
                                                dialogBackgroundColor:
                                                    Colors.white),
                                            child: picker!);
                                      }).then((value) {
                                    if (value != null) {
                                      selectedDate = value;
                                      _tecDueDate.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(selectedDate);
                                    }
                                  });
                                },
                                child: Text('Pilih Tgl'))
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Text('Pilih Kategori '),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    StatefulBuilder(
                                      builder: (BuildContext context,
                                          void Function(void Function())
                                              setState) {
                                        return DropdownButton(
                                          dropdownColor: Colors.white,
                                          value: _dropdownValue,
                                          icon: Icon(Icons.arrow_drop_down),
                                          onChanged: (String? value) {
                                            setState(() {
                                              _dropdownValue = value!;
                                            });
                                          },
                                          items: <String>[
                                            'Merek',
                                            'Merek - QC',
                                            'Merek - Permohonan',
                                            'Merek - Oposisi',
                                            'Merek - KO',
                                            'Merek - Sanggahan',
                                            'Merek - KBM',
                                            'Merek - Perpanjangan',
                                            'Merek - Lain Lain',
                                            'Merek - Upaya Lain2',
                                            'Paten',
                                            'Desain Industri',
                                            'Hak Cipta',
                                            'DI - Oposisi',
                                            'DI - KO'
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value));
                                          }).toList(),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ]),
                        SizedBox(
                          height: 10,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                            labelText:
                                                'Keterangan Next Progress',
                                            hintText: 'Masukkan Deskripsi',
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
                          height: 15.0,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await RequestModalBottom().modalKonfirmasi(
                                  context,
                                  tipe,
                                  token,
                                  _tecKeterangan.text.toString(),
                                  _dropdownValue.toString(),
                                  _tecDueDate.text.toString(),
                                  0.toString(),

                                  ///set flag selesai permintaan
                                  idpermintaan,
                                  _tecKeteranganSelesai.text.toString(),
                                  _tecUrlPermintaan.text.toString(),
                                  nextuser,
                                  _mypengguna == null
                                      ? '0'
                                      : _mypengguna.toString(),
                                  _tecKeteranganNext.text.trim().toString());

                              /// Clear text input
                              _tecKeterangan.clear();
                              _tecDueDate.clear();
                              idpermintaan = '';
                              _tecKeteranganSelesai.clear();
                              _tecUrlPermintaan.clear();
                              // _mypengguna = '';
                              _tecKeteranganNext.clear();
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0.0, primary: thirdcolor),
                            child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18.0)),
                                child: Container(
                                  width: 325,
                                  height: 45,
                                  alignment: Alignment.center,
                                  child: Text('S I M P A N',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                )))
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
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
}
