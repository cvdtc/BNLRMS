import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/request/request.model.dart';
import 'package:rmsmobile/pages/progres/progress.bottom.dart';
// import 'package:rmsmobile/pages/request/request.page.dart';
import 'package:rmsmobile/pages/timeline/timeline.dart';
import 'package:rmsmobile/utils/ReusableClasses.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:http/http.dart' as client;
// import 'package:rmsmobile/widget/bottomnavigationbar.dart';

class RequestModalBottom {
  ApiService _apiService = new ApiService();
  TextEditingController _tecKeterangan = TextEditingController(text: "");
  TextEditingController _tecDueDate = TextEditingController(text: "");
  TextEditingController _tecKeteranganSelesai = TextEditingController(text: "");
  TextEditingController _tecKeteranganNextUser =
      TextEditingController(text: "");

  TextEditingController _tecUrlPermintaan = TextEditingController(text: "");
  String _dropdownValue = "Merek", tanggal = "";
  DateTime selectedDate = DateTime.now();

  bool flagpermintaanselesai = false;
  int valueflagpermintaanselesai = 0;
  // * for edit progress
  bool flagswitchnextuser = false;

  List? pnggunaList;
  String? _mypengguna;

  /**
   * * PARAMETER YANG DITERIMA:
   * * tipe yaitu tambah, ubah atau hapus
   * * token diambil dari shared preferences,
   * * keterangan adalah deskripsi permintaan
   * * kategori adalah kategori permintaan
   * * duedate adalah tanggal expired permintaan atau due date
   * * flag selesai adalah berisi 0/1 untuk menentukan apakah permintaan ini sudah selesai atau belum
   * * idpermintaan adalah idpermintaan yang di ambil dari json
   * * keterangan_selesai adalah deskripsi keterangan permintaan ketika sudah selesai
   * * url_permintaan adalah url yang akan disimpan ke database jika diperlikan
   */

  // ++ BOTTOM MODAL INPUT FORM
  void modalAddRequest(
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
    // * setting value text form field if action is edit

    if (tipe == 'ubah') {
      _tecKeterangan.value = TextEditingValue(
          text: keterangan,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecKeterangan.text.length)));
      _tecDueDate.value = TextEditingValue(
          text: duedate,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecUrlPermintaan.text.length)));
      _tecUrlPermintaan.value = TextEditingValue(
          text: url_permintaan,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecUrlPermintaan.text.length)));
      _dropdownValue = kategori;
    }

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
                                            'Paten',
                                            'Desain Industri',
                                            'Hak Cipta'
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
                        tipe == 'ubah'
                            ? StatefulBuilder(
                                builder: (BuildContext context,
                                    void Function(void Function()) setState) {
                                  return Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text('Selesai Permintaan '),
                                            Switch(
                                              onChanged: (bool value) {
                                                setState(() {
                                                  flagpermintaanselesai = value;
                                                  flagpermintaanselesai == true
                                                      ? valueflagpermintaanselesai =
                                                          1
                                                      : valueflagpermintaanselesai =
                                                          0;
                                                });
                                              },
                                              activeTrackColor: thirdcolor,
                                              activeColor: Colors.green,
                                              value: flagpermintaanselesai,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        flagpermintaanselesai == true
                                            ? TextFormField(
                                                controller:
                                                    _tecKeteranganSelesai,
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                decoration: InputDecoration(
                                                    icon: Icon(
                                                        Icons.note_outlined),
                                                    labelText:
                                                        'Keterangan Selesai',
                                                    hintText:
                                                        'Masukkan Keterangan Selesai',
                                                    suffixIcon: Icon(Icons
                                                        .check_circle_outline_outlined)))
                                            : SizedBox(
                                                height: 0,
                                              ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : SizedBox(height: 0),
                        SizedBox(
                          height: 15.0,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              modalKonfirmasi(
                                  context,
                                  tipe,
                                  token,
                                  _tecKeterangan.text.toString(),
                                  _dropdownValue.toString(),
                                  _tecDueDate.text.toString(),
                                  valueflagpermintaanselesai.toString(),
                                  idpermintaan,
                                  _tecKeteranganSelesai.text.toString(),
                                  _tecUrlPermintaan.text.toString(),
                                  false,

                                  /// isnextuser
                                  0.toString(), //idnextuser
                                  'tanpa progress');
                              // Navigator.pop(context);
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

  // ++ BOTTOM MODAL CONFIRMATION
  modalKonfirmasi(
      context,
      String tipe,
      String token,
      String keterangan,
      String kategori,
      String duedate,
      String flag_selesai,
      String idpermintaan,
      String keterangan_selesai,
      String url_permintaan,
      bool isnextuser,
      String idnextuser,
      keteranganProgress) {
    if (keterangan == "" || duedate == "" || kategori == "") {
      ReusableClasses().modalbottomWarning(
          context,
          "Tidak Valid!",
          "Pastikan semua kolom terisi dengan benar",
          'f405',
          'assets/images/sorry.png');
    } else {
      return showModalBottomSheet<void>(
          isScrollControlled: true,
          context: context,
          elevation: 3.0,
          useRootNavigator: true,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0))),
          builder: (BuildContext context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Konfirmasi ' + tipe,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    tipe == 'hapus'
                        ? Text('Apakah anda yakin akan menghapus permintaan ' +
                            keterangan +
                            '?')
                        : Text(
                            'Apakah data yang anda masukkan sudah sesuai.?  *note: Harap Refresh setelah menekan tombol submit.',
                            style: TextStyle(fontSize: 16)),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              primary: Colors.red,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18)),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Batal",
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 55,
                        ),
                        StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return ElevatedButton(
                              onPressed: () {
                                _actiontoapi(
                                    context,
                                    tipe,
                                    token,
                                    keterangan,
                                    kategori,
                                    duedate,
                                    flag_selesai,
                                    idpermintaan,
                                    keterangan_selesai,
                                    url_permintaan,
                                    isnextuser,
                                    idnextuser,
                                    keteranganProgress);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                primary: Colors.white,
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18)),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(color: primarycolor),
                                  ),
                                ),
                              ));
                        })
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  // ++ UNTUK MELAKUKAN TRANSAKSI KE API SESUAI DENGAN PARAMETER TIPE YANG DIKIRIM
  void _actiontoapi(
      context,
      String tipe,
      String token,
      String keterangan,
      String kategori,
      String duedate,
      String flag_selesai,
      String idpermintaan,
      String keterangan_selesai,
      String url_permintaan,
      bool isnextuser,
      String idnextuser,
      String keteranganProgress) async {
    if (keterangan == "" || duedate == "" || kategori == "") {
      ReusableClasses().modalbottomWarning(
          context,
          "Tidak Valid!",
          "Pastikan semua kolom terisi dengan benar",
          'f405',
          'assets/images/sorry.png');
    } else {
      RequestModel dataadd = RequestModel(
          keterangan: keterangan,
          kategori: kategori,
          due_date: duedate,
          flag_selesai: flag_selesai,
          url_permintaan: url_permintaan,
          keterangan_selesai: keterangan_selesai);
      if (tipe == 'tambah') {
        if (isnextuser) {
          _apiService
              .addRequestDanProgress(token, keterangan, kategori, duedate,
                  flag_selesai, url_permintaan, idnextuser, keteranganProgress)
              .then((isBerhasil) => {
                    if (isBerhasil)
                      {
                        Fluttertoast.showToast(
                            msg: 'Data berhasil dibuat!',
                            backgroundColor: Colors.white,
                            textColor: Colors.black)
                      }
                    else
                      {
                        ReusableClasses().modalbottomWarning(
                            context,
                            'Data Gagal Disimpan!',
                            '${_apiService.responseCode.messageApi}',
                            'f400',
                            'assets/images/sorry.png')
                      }
                  });
        } else {
          _apiService.addRequest(token.toString(), dataadd).then((isSuccess) {
            print('RESPONSE??' + isSuccess.toString());
            if (isSuccess) {
              _tecKeterangan.clear();
              _tecDueDate.clear();
              _tecKeteranganSelesai.clear();
              _tecUrlPermintaan.clear();
              Fluttertoast.showToast(
                msg: "${_apiService.responseCode.messageApi}",
                backgroundColor: Colors.white,
                textColor: Colors.black,
              );
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => BottomNav(
              //               numberOfpage: 0,
              //             )));
              // ReusableClasses().modalbottomWarning(
              //     context,
              //     'Data Berhasil Disimpan!',
              //     '${_apiService.responseCode.messageApi}',
              //     'f201',
              //     'assets/images/congratulations.png');
            } else {
              ReusableClasses().modalbottomWarning(
                  context,
                  'Data Gagal Disimpan!',
                  '${_apiService.responseCode.messageApi}',
                  'f400',
                  'assets/images/sorry.png');
            }
          }).onError((error, stackTrace) {
            Fluttertoast.showToast(
                msg: "${_apiService.responseCode.messageApi}",
                backgroundColor: Colors.red,
                textColor: Colors.red);
            // ReusableClasses().modalbottomWarning(context, 'Data Gagal Disimpan!',
            //     '${error}', 'f400', 'assets/images/sorry.png');
          });
        }
      } else if (tipe == 'ubah') {
        _apiService
            .ubahRequest(token.toString(), idpermintaan, dataadd)
            .then((isSuccess) {
          if (isSuccess) {
            ReusableClasses().modalbottomWarning(
                context,
                'Data Berhasil Disimpan!',
                '${_apiService.responseCode.messageApi}',
                'f201',
                'assets/images/congratulations.png');
          } else {
            ReusableClasses().modalbottomWarning(
                context,
                'Data Gagal Disimpan!',
                '${_apiService.responseCode.messageApi}',
                'f400',
                'assets/images/sorry.png');
          }
          return;
        }).onError((error, stackTrace) {
          ReusableClasses().modalbottomWarning(context, 'Data Gagal Disimpan!',
              '${error}', 'f400', 'assets/images/sorry.png');
        });
      } else {
        ReusableClasses().modalbottomWarning(context, "Tidak Valid!",
            "Action anda tidak sesuai", 'f404', 'assets/images/sorry.png');
      }
    }
  }

  // ++ BOTTOM MODAL ACTION ITEM
  /**
   * * parameter yang dikirim :
   * * token jwt dari sharedpreferences,
   * * keterangan atau deskripsi permintaan
   * * duedate tanggal deadline permintaan
   * * idpermintaan yang di ambil dari listview permintaan
   * * keterangan_selesai jika permintaan sudah selesai
   * * idflag_selesai diambil dari switch jika enable maka valuenya 1 jika sebaliknya 0
   * * url_progress diperlukan jika user perlu untuk menyematkan url
   */
  void modalActionItem(
      context,
      token,
      String keterangan,
      String duedate,
      String kategori,
      String idpermintaan,
      String keterangan_selesai,
      int flag_selesai,
      String nama_request,
      String url_permintaan,
      int jmlprogress,
      String idpengguna,
      String idrequest) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
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
                  Text('DETAIL PERMINTAAN',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Kategori: ' + kategori,
                        ),
                        Text(
                          'JT: ' + duedate.toString(),
                        )
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Deskripsi : ' + keterangan,
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        nama_request,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1.0,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // ++ add filter jika permintaan sudah selesai maka tombol tambah progress dihilangkan
                  flag_selesai == 0
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ProgressModalBottom().modalAddProgress(
                                context,
                                'tambah',
                                token,
                                "",
                                idpermintaan,
                                "",
                                "",
                                "",
                                "",
                                "",
                                "");
                          },
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(width: 2, color: Colors.green),
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              primary: Colors.white),
                          child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18.0)),
                              child: Container(
                                width: 325,
                                height: 45,
                                alignment: Alignment.center,
                                child: Text('TAMBAH PROGRESS',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              )))
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  // ++ end add filter permintaan selesai
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimelinePage(
                                      idpermintaan: idpermintaan,
                                    )));
                      },
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(width: 2, color: Colors.blue),
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          primary: Colors.white),
                      child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0)),
                          child: Container(
                            width: 325,
                            height: 45,
                            alignment: Alignment.center,
                            child: Text('LIHAT TIMELINE',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ))),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    thickness: 1.0,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // ++ add filter jika flag selesai 0 atau idpengguna tidak sama dengan idlogin maka  data masih bisa di ubah
                  flag_selesai == 0 && idpengguna == idrequest
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            modalAddRequest(
                                context,
                                'ubah',
                                token,
                                keterangan,
                                kategori,
                                duedate,
                                flag_selesai.toString(),
                                idpermintaan.toString(),
                                keterangan_selesai,
                                url_permintaan);
                          },
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(width: 2, color: Colors.red),
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              primary: Colors.white),
                          child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18.0)),
                              child: Container(
                                width: 325,
                                height: 45,
                                alignment: Alignment.center,
                                child: Text('EDIT / SELESAI PERMINTAAN',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              )))
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.of(context).pop();
                  //       _modalKonfirmasi(context, token, 'hapus', '','','','','','',idpermintaan.toString());
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //         side: BorderSide(width: 2, color: Colors.red),
                  //         elevation: 0.0,
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(8)),
                  //         primary: Colors.white),
                  //     child: Ink(
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(18.0)),
                  //         child: Container(
                  //           width: 325,
                  //           height: 45,
                  //           alignment: Alignment.center,
                  //           child: Text('HAPUS PERMINTAAN',
                  //               style: TextStyle(
                  //                 color: Colors.red,
                  //                 fontSize: 18.0,
                  //                 fontWeight: FontWeight.bold,
                  //               )),
                  //         ))),
                ],
              ),
            ),
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
