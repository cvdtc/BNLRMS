import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/progress/progress.model.add.dart';
import 'package:rmsmobile/model/request/request.model.dart';
import 'package:rmsmobile/model/request/request.model.edit.dart';
import 'package:rmsmobile/pages/timeline/timeline.dart';
import 'package:rmsmobile/utils/warna.dart';

class RequestModalBottom {
  ApiService _apiService = new ApiService();
  TextEditingController _tecKeterangan = TextEditingController(text: "");
  TextEditingController _tecDueDate = TextEditingController(text: "");
  TextEditingController _tecKeteranganSelesai = TextEditingController(text: "");
  String _dropdownValue = "Merek", tanggal = "";
  DateTime selectedDate = DateTime.now();

  bool isSelesai = false;

  // ++ BOTTOM MODAL INPUT FORM
  void modalAddSite(
      context,
      String tipe,
      String token,
      String keterangan,
      String kategori,
      String duedate,
      String flag_selesai,
      String idpermintaan,
      String keterangan_selesai,
      String tipeupdate) {
    // * setting value text form field if action is edit

    if (tipe == 'ubah') {
      _tecKeterangan.value = TextEditingValue(
          text: keterangan,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecKeterangan.text.length)));
      _tecDueDate.value = TextEditingValue(
          text: duedate,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecDueDate.text.length)));
      _dropdownValue = kategori;
    }
    tipe == 'progres'
        ? showModalBottomSheet(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tipe.toUpperCase(),
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                          controller: _tecKeterangan,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                              icon: Icon(Icons.cabin_rounded),
                              labelText: 'Keterangan Progres',
                              hintText: 'Masukkan Deskripsi',
                              suffixIcon:
                                  Icon(Icons.check_circle_outline_outlined))),
                      SizedBox(
                        height: 15.0,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            print(
                                'showmodalbottomsheet1progress $token, $tipe, ${_tecKeterangan.text.toString()}, ${_dropdownValue.toString()}, ${_tecDueDate.text.toString()}, $idpermintaan');
                            _modalKonfirmasi(
                                context,
                                token,
                                tipe,
                                _tecKeterangan.text.toString(),
                                "",
                                "",
                                0,
                                "",
                                "tambahprogress",
                                idpermintaan.toString());
                            _tecKeterangan.clear();
                            _tecDueDate.clear();
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0.0, primary: Colors.white),
                          child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18.0)),
                              child: Container(
                                width: 325,
                                height: 45,
                                alignment: Alignment.center,
                                child: Text('S I M P A N',
                                    style: TextStyle(
                                      color: primarycolor,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              )))
                    ],
                  ),
                ),
              );
            })
        : showModalBottomSheet(
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
                              tipe.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                                controller: _tecKeterangan,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.cabin_rounded),
                                    labelText: 'Deskripsi Permintaan',
                                    hintText: 'Masukkan Deskripsi',
                                    suffixIcon: Icon(
                                        Icons.check_circle_outline_outlined))),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.4,
                                  child: TextFormField(
                                      enabled: false,
                                      controller: _tecDueDate,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      onSaved: (String? val) {
                                        tanggal = val.toString();
                                        print('jos?');
                                      },
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.note_outlined),
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
                                                    colorScheme:
                                                        ColorScheme.dark(
                                                            primary: Colors
                                                                .deepOrange,
                                                            onPrimary:
                                                                Colors.white,
                                                            surface:
                                                                Colors.white70,
                                                            onSurface:
                                                                Colors.green),
                                                    dialogBackgroundColor:
                                                        Colors.white),
                                                child: picker!);
                                          }).then((value) {
                                        if (value != null) {
                                          selectedDate = value;
                                          _tecDueDate.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(selectedDate);
                                          // _tecDueDate.text = value.toString();

                                          print(
                                              'tanggalnya dapet berapa ? ${_tecDueDate.text}');
                                        }
                                      });
                                    },
                                    child: Text('Pilih'))
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                // setState(() {
                                                setState(() {
                                                  _dropdownValue = value!;
                                                });
                                                print("Value Dropdown? " +
                                                    value.toString());
                                                // });
                                              },
                                              items: <String>[
                                                'Merek',
                                                'Paten',
                                                'Desain Industri',
                                                'Lainnya'
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
                                        void Function(void Function())
                                            setState) {
                                      return Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text('Selesai Permintaan '),
                                                Switch(
                                                  onChanged: (bool value) {
                                                    value == true
                                                        ? 'selesai'
                                                        : 'data';
                                                    setState(() {
                                                      isSelesai = value;
                                                    });
                                                    print(
                                                        'telah diswitch $value + $isSelesai');
                                                  },
                                                  activeTrackColor: thirdcolor,
                                                  activeColor: Colors.green,
                                                  value: isSelesai,
                                                ),
                                                // Text(
                                                //   isSelesai == true
                                                //       ? 'selesai'
                                                //       : 'data',
                                                // )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            isSelesai == true
                                                ? TextFormField(
                                                    controller:
                                                        _tecKeteranganSelesai,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .words,
                                                    decoration: InputDecoration(
                                                        icon: Icon(Icons
                                                            .note_outlined),
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
                                  print(
                                      'showmodalbottomsheet2 $token, $tipe, ${_tecKeterangan.text.toString()}, ${_dropdownValue.toString()}, ${_tecDueDate.text.toString()}, $idpermintaan');
                                  _modalKonfirmasi(
                                      context,
                                      token,
                                      tipe,
                                      _tecKeterangan.text.toString(),
                                      _dropdownValue.toString(),
                                      _tecDueDate.text.toString(),
                                      isSelesai == true ? 1 : 0,
                                      _tecKeteranganSelesai.text.toString(),
                                      isSelesai == true ? 'selesai' : 'data',
                                      idpermintaan);
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 0.0, primary: Colors.white),
                                child: Ink(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(18.0)),
                                    child: Container(
                                      width: 325,
                                      height: 45,
                                      alignment: Alignment.center,
                                      child: Text('S I M P A N',
                                          style: TextStyle(
                                            color: primarycolor,
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
  void _modalKonfirmasi(
      context,
      String token,
      String tipe,
      String keterangan,
      String kategori,
      String duedate,
      int flag_selesai,
      String keterangan_selesai,
      String tipeupdate,
      String idpermintaan) {
    if (tipe == "progres") {
      print('idperrogres? $idpermintaan $tipeupdate');
      if (keterangan == "") {
        _modalbottomSite(
            context,
            "Tidak Valid!",
            "Pastikan semua kolom terisi dengan benar",
            'f405',
            'assets/images/sorry.png');
      }
    } else if (tipe == 'hapus') {
      if (idpermintaan == "") {
        _modalbottomSite(context, "Tidak Valid!", "idpermintaan tidak valid",
            'f405', 'assets/images/sorry.png');
      }
    } else if (tipe == 'tambah') {
      print('tipeupdatenya?? $tipeupdate');
      if (keterangan == "" || duedate == "" || kategori == "") {
        _modalbottomSite(
            context,
            "Tidak Valid!",
            "Pastikan semua kolom terisi dengan benar",
            'f405',
            'assets/images/sorry.png');
      }
    } else if (tipe == 'ubah') {
      print('tipeupdatenya?? $tipeupdate');
      if (keterangan == "" || duedate == "" || kategori == "") {
        _modalbottomSite(
            context,
            "Tidak Valid!",
            "Pastikan semua kolom terisi dengan benar",
            'f405',
            'assets/images/sorry.png');
      }
    }
    // if (keterangan == "" || duedate == "" || kategori == "") {
    //   _modalbottomSite(
    //       context,
    //       "Tidak Valid!",
    //       "Pastikan semua kolom terisi dengan benar",
    //       'f405',
    //       'assets/images/sorry.png');
    // } else {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
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
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  tipe == 'hapus'
                      ? Text('Apakah anda yakin akan menghapus permintaan ' +
                          keterangan +
                          '?')
                      : Text('Apakah data yang anda masukkan sudah sesuai.?',
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
                            Navigator.of(context).pop();
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
                              print("Will be Execute up" +
                                  tipe +
                                  token +
                                  keterangan +
                                  kategori +
                                  duedate +
                                  flag_selesai.toString() +
                                  keterangan_selesai +
                                  idpermintaan.toString());
                              if (tipe == 'progres') {
                                Navigator.of(context).pop();
                                _actiontoapiProgress(
                                    context,
                                    tipe,
                                    token,
                                    keterangan,
                                    kategori,
                                    duedate,
                                    flag_selesai,
                                    keterangan_selesai,
                                    tipeupdate,
                                    idpermintaan);
                              } else if (tipe == 'hapus') {
                                _actiontoapiHapusReq(
                                    context,
                                    tipe,
                                    token,
                                    keterangan,
                                    kategori,
                                    duedate,
                                    flag_selesai,
                                    keterangan_selesai,
                                    tipeupdate,
                                    idpermintaan);
                              } else if (tipe == 'tambah') {
                                Navigator.of(context).pop();
                                // _apiService.getListRequest(token).then((value){
                                //     setState((){
                                //       this._requestDisplay= value!;
                                //       print('valuenya $value');
                                //     });
                                //   });
                                _actiontoapi(
                                    context,
                                    tipe,
                                    token,
                                    keterangan,
                                    kategori,
                                    duedate,
                                    flag_selesai,
                                    "",
                                    tipeupdate,
                                    "");
                              } else if (tipe == 'ubah') {
                                Navigator.of(context).pop();
                                _actiontoapi(
                                    context,
                                    tipe,
                                    token,
                                    keterangan,
                                    kategori,
                                    duedate,
                                    flag_selesai,
                                    keterangan_selesai,
                                    tipeupdate,
                                    idpermintaan.toString());
                              }
                              // tipe == 'progres'
                              // ? _actiontoapiProgress(
                              //     context,
                              //     tipe,
                              //     token,
                              //     keterangan,
                              //     kategori,
                              //     duedate,
                              //     flag_selesai,
                              //     keterangan_selesai,
                              //     tipeupdate,
                              //     idpermintaan)
                              // : _actiontoapi(
                              //     context,
                              //     tipe,
                              //     token,
                              //     keterangan,
                              //     kategori,
                              //     duedate,
                              //     flag_selesai,
                              //     keterangan_selesai,
                              //     tipeupdate,
                              //     idpermintaan);
                              Navigator.of(context).pop();
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
    // }
  }

  // ++ UNTUK MELAKUKAN TRANSAKSI KE API SESUAI DENGAN PARAMETER TIPE YANG DIKIRIM
  void _actiontoapi(
      context,
      String tipe,
      String token,
      String keterangan,
      String kategori,
      String duedate,
      int flag_selesai,
      String keterangan_selesai,
      String tipeupdate,
      String idpermintaan) {
    print('here? $tipe');
    print("Will be Execute act to api " +
        tipe.toString() +
        token.toString() +
        keterangan.toString() +
        kategori.toString() +
        duedate.toString() +
        flag_selesai.toString() +
        keterangan_selesai.toString() +
        tipeupdate.toString() +
        idpermintaan.toString());
    if (keterangan == "" || duedate == "" || kategori == "") {
      print('mosok masuk sini?');
      _modalbottomSite(
          context,
          "Tidak Valid!",
          "Pastikan semua kolom terisi dengan benar",
          'f405',
          'assets/images/sorry.png');
    } else {
      print('heres?? $tipe ~ $idpermintaan');
      ProgressModelAdd dataprogress =
          ProgressModelAdd(keterangan: keterangan, idpermintaan: idpermintaan);

      RequestModelEdit dataEdit = RequestModelEdit(
          keterangan: keterangan,
          kategori: kategori,
          due_date: duedate,
          flag_selesai: flag_selesai,
          keterangan_selesai: keterangan_selesai,
          tipeupdate: tipeupdate);

      RequestModel dataadd = RequestModel(
          keterangan: keterangan,
          kategori: kategori,
          due_date: duedate,
          flag_selesai: flag_selesai);
      print('model ?' + dataadd.toString());
      if (tipe == 'tambah') {
        _apiService.addRequest(token.toString(), dataadd).then((isSuccess) {
          // print('ini tambah ya $token + $dataadd + $isSuccess');
          if (isSuccess) {
            // Navigator.pop(context);
            // print('tes masuk');s
            Fluttertoast.showToast(
                msg: "Berhasil tambah permintaan",
                backgroundColor: Colors.black,
                textColor: Colors.white);

            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //         builder: (BuildContext context) =>
            //             BottomNav(initIndex: 1, callpage: RequestPageSearch())),
            //     (route) => false);
            // return Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(
            //         builder: (BuildContext context) => BottomNav(
            //               callpage: RequestPageSearch(),
            //               initIndex: 1,
            //             )),
            //     (Route<dynamic> route) => false);
            // Navigator.of(context).pop();
            // _modalbottomSite(
            //     context,
            //     "Berhasil!",
            //     "${_apiService.responseCode.messageApi}",
            //     "f200",
            //     "assets/images/congratulations.png");
          } else {
            _modalbottomSite(
                context,
                "Gagal!",
                "${_apiService.responseCode.messageApi}",
                "f400",
                "assets/images/sorry.png");
          }
          // return;
        });
      } else if (tipe == 'ubah') {
        print('ubah belum kamu buat');
        _apiService
            .ubahRequest(token.toString(), idpermintaan.toString(), dataEdit)
            .then((isSuccess) {
          print('masuk edit? $token, - $idpermintaan, - $dataEdit');
          if (isSuccess) {
            // Navigator.of(context).pop();
            Fluttertoast.showToast(
                msg: "Berhasil ubah data permintaan",
                backgroundColor: Colors.black,
                textColor: Colors.white);
            // _tecNama.clear();
            // _tecKeterangan.clear();
            // _modalbottomSite(
            //     context,
            //     "Berhasil!",
            //     "${_apiService.responseCode.messageApi}",
            //     "f200",
            //     "assets/images/congratulations.png");
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
      } else if (tipe == 'hapus') {
        print('hapus belum kamu buat');
        _apiService
            .hapusRequest(token.toString(), idpermintaan.toString())
            .then((isSuccess) {
          if (isSuccess) {
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
      } else if (tipe == 'progres') {
        print('ini tambah progres lho');
        _apiService
            .addProgres(token.toString(), dataprogress)
            .then((isSuccess) {
          print('tambah progress $token, $dataprogress');
          if (isSuccess) {
            Fluttertoast.showToast(
                msg: "Berhasil tambah data progres",
                backgroundColor: Colors.black,
                textColor: Colors.white);
            // Navigator.of(context).pop();
            // _modalbottomSite(
            //     context,
            //     "Berhasil!",
            //     "${_apiService.responseCode.messageApi}",
            //     "f200",
            //     "assets/images/congratulations.png");
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
      } else {
        _modalbottomSite(context, "Tidak Valid!", "Action anda tidak sesuai",
            'f404', 'assets/images/sorry.png');
      }
    }
  }

  void _actiontoapiProgress(
      context,
      String tipe,
      String token,
      String keterangan,
      String kategori,
      String duedate,
      int flag_selesai,
      String keterangan_selesai,
      String tipeupdate,
      String idpermintaan) {
    print('here? $tipe');
    print("Will be Execute act to api " +
        tipe +
        token +
        keterangan +
        idpermintaan);
    if (keterangan == "") {
      print('mosok masuk sini?');
      _modalbottomSite(
          context,
          "Tidak Valid!",
          "Pastikan semua kolom terisi dengan benar",
          'f405',
          'assets/images/sorry.png');
    } else {
      print('heres?? $tipe ~ $idpermintaan');
      ProgressModelAdd dataprogress = ProgressModelAdd(
          keterangan: keterangan,
          idpermintaan: idpermintaan,
          idnextuser: flag_selesai,
          tipe: tipeupdate);
      print('act to api progress $dataprogress');
      if (tipe == 'progres') {
        print('ini tambah progres lho');
        _apiService.addProgres(token, dataprogress).then((isSuccess) {
          print('tambah progress $token, $dataprogress');
          if (isSuccess) {
            Fluttertoast.showToast(
                msg: "Berhasil tambah data progres",
                backgroundColor: Colors.black,
                textColor: Colors.white);
            // Navigator.of(context).pop();
            // _modalbottomSite(
            //     context,
            //     "Berhasil!",
            //     "${_apiService.responseCode.messageApi}",
            //     "f200",
            //     "assets/images/congratulations.png");
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
      } else {
        _modalbottomSite(context, "Tidak Valid!", "Action anda tidak sesuai",
            'f404', 'assets/images/sorry.png');
      }
    }
  }

  void _actiontoapiHapusReq(
      context,
      String tipe,
      String token,
      String keterangan,
      String kategori,
      String duedate,
      int flag_selesai,
      String keterangan_selesai,
      String tipeupdate,
      String idpermintaan) {
    print('here? $tipe');
    print("Will be Execute act to api " +
        tipe +
        token +
        keterangan +
        idpermintaan);
    if (idpermintaan == "") {
      print('mosok masuk sini?');
      _modalbottomSite(context, "Tidak Valid!", "idpermintaan tidak valid!",
          'f405', 'assets/images/sorry.png');
    } else {
      print('heres?? $tipe ~ $idpermintaan');
      // ProgressModelDel datahapus =
      //     ProgressModelDel(idpermintaan: idpermintaan);

      if (tipe == 'hapus') {
        print('ini hapus lho');
        _apiService.hapusRequest(token, idpermintaan).then((isSuccess) {
          print('hapus req $token');
          if (isSuccess) {
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
      } else {
        _modalbottomSite(context, "Tidak Valid!", "Action anda tidak sesuai",
            'f404', 'assets/images/sorry.png');
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
   * * tipeupdate apakah edit data atau selesai permintaan
   * * idflag_selesai diambil dari switch jika enable maka valuenya 1 jika sebaliknya 0
   */
  void modalActionItem(
      context,
      token,
      String keterangan,
      String duedate,
      String kategori,
      String idpermintaan,
      String keterangan_selesai,
      String tipeupdate,
      int flag_selesai) {
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
                  Text(
                    'Deskripsi : ' + keterangan,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text('Kategori: ' + kategori, style: TextStyle(fontSize: 16)),
                  Text('Due Date: ' + duedate.toString(),
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 10,
                  ),
                  // ++ add filter jika permintaan sudah selesai maka tombol tambah progress dihilangkan
                  flag_selesai == 0
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            modalAddSite(
                                context,
                                'progres',
                                token,
                                keterangan,
                                '',
                                '',
                                '0',
                                idpermintaan.toString(),
                                '',
                                tipeupdate);
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
                                child: Text('TAMBAH PROGRESS',
                                    style: TextStyle(
                                      color: Colors.blue,
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
                          side: BorderSide(width: 2, color: Colors.orange),
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
                                  color: Colors.orange,
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
                  flag_selesai == 0
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            modalAddSite(
                                context,
                                'ubah',
                                token,
                                keterangan,
                                kategori,
                                duedate,
                                flag_selesai.toString(),
                                idpermintaan,
                                keterangan_selesai,
                                tipeupdate);
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
                                child: Text('EDIT PERMINTAAN',
                                    style: TextStyle(
                                      color: Colors.green,
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
