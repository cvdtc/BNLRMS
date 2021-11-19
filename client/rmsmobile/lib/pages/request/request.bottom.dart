import 'package:flutter/material.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/request/request.model.dart';
import 'package:rmsmobile/utils/ReusableClasses.dart';
import 'package:rmsmobile/utils/warna.dart';

class RequestBottom {
  ApiService _apiService = new ApiService();
  TextEditingController _Keterangan = TextEditingController(text: "");
  TextEditingController _Kategori = TextEditingController(text: "");
  TextEditingController _DueDate = TextEditingController(text: "");

  // ++ BOTTOM MODAL INPUT FORM
  void modalAddSite(
      // context, String tipe, String token, String idkomponen, String idmesin) {
        context, String tipe, String token, String keterangan, String kategori, String duedate, String flagselesai) {
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tipe.toUpperCase(),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                      controller: _Keterangan,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                          icon: Icon(Icons.cabin_rounded),
                          labelText: 'Keterangan',
                          hintText: 'Masukkan Keterangan',
                          suffixIcon:
                              Icon(Icons.check_circle_outline_outlined))),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                      controller: _Kategori,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          icon: Icon(Icons.note_outlined),
                          labelText: 'Kategori',
                          hintText: 'Masukkan Kategori',
                          suffixIcon:
                              Icon(Icons.check_circle_outline_outlined))),
                              SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                      controller: _DueDate,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          icon: Icon(Icons.note_outlined),
                          labelText: 'Due Date',
                          hintText: 'Tentukan due date',
                          suffixIcon:
                              Icon(Icons.check_circle_outline_outlined))),
                  SizedBox(
                    height: 15.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        print('showmodal1 $token, ${_Keterangan.text}, , ${_Kategori.text}, , ${_DueDate.text},');
                        _modalKonfirmasi(
                            context,
                            token,
                            'tambah',
                            _Keterangan.text.toString(),
                            _Kategori.text.toString(),
                            _DueDate.text.toString(),
                            "0"
                            );
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
        });
  }

  // ++ BOTTOM MODAL CONFIRMATION
  void _modalKonfirmasi(context, String token, String tipe, String keterangan,
      String kategori, String duedate, String flagselesai) {
    if (keterangan == "" || kategori == "" || duedate == "") {
      ReusableClasses().modalbottomWarning(
          context,
          "Tidak Valid!",
          "Pastikan semua kolom terisi dengan benar",
          'f405',
          'assets/images/sorry.png');
    } else {
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
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    tipe == 'hapus'
                        ? Text('Apakah anda yakin akan menghapus site ' +
                            kategori +
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
                        ElevatedButton(
                            onPressed: () {
                              print('showbottom2 $token, $tipe, $keterangan, $kategori, $duedate, $flagselesai');
                              _actiontoapi(context, token, tipe,  keterangan,
                                  kategori, duedate, flagselesai);
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
                            )),
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
  void _actiontoapi(context, token, tipe, String keterangan,
      String kategori, String duedate, String flagselesai) {
    if (keterangan == "" || kategori == "" || duedate == "" ) {
      ReusableClasses().modalbottomWarning(
          context,
          "Tidak Valid!",
          "Pastikan semua kolom terisi dengan benar",
          'f405',
          'assets/images/sorry.png');
    } else {
      RequestModel data =
          RequestModel(keterangan: keterangan, kategori: kategori, due_date: duedate, flag_selesai: '0');
          print('showbottom4 $data');
      if (tipe == 'tambah') {
        _apiService.addRequest(data).then((isSuccess) {
          print('showmodal3 $data');
          if (isSuccess) {
            _Keterangan.clear();
            _Kategori.clear();
            _DueDate.clear;
            ReusableClasses().modalbottomWarning(
                context,
                "Berhasil!",
                "${_apiService.responseCode.messageApi}",
                "f200",
                "assets/images/congratulations.png");
          } else {
            ReusableClasses().modalbottomWarning(
                context,
                "Gagal!",
                "${_apiService.responseCode.messageApi}",
                "f400",
                "assets/images/sorry.png");
          }
          // return Text('');
        });
      } else if (tipe == 'ubah') {
        // _apiService.ubahKomponen(token, idkomponen, data).then((isSuccess) {
        //   if (isSuccess) {
        //     _tecNama.clear();
        //     _tecJumlah.clear();
        //     ReusableClasses().modalbottomWarning(
        //         context,
        //         "Berhasil!",
        //         "${_apiService.responseCode.messageApi}",
        //         "f200",
        //         "assets/images/congratulations.png");
        //   } else {
        //     ReusableClasses().modalbottomWarning(
        //         context,
        //         "Gagal!",
        //         "${_apiService.responseCode.messageApi}",
        //         "f400",
        //         "assets/images/sorry.png");
        //   }
        //   return;
        // });
      } else if (tipe == 'hapus') {
        // _apiService.hapusSite(token, idkomponen).then((isSuccess) {
        //   if (isSuccess) {
        //     ReusableClasses().modalbottomWarning(
        //         context,
        //         "Berhasil!",
        //         "${_apiService.responseCode.messageApi}",
        //         "f200",
        //         "assets/images/congratulations.png");
        //   } else {
        //     ReusableClasses().modalbottomWarning(
        //         context,
        //         "Gagal!",
        //         "${_apiService.responseCode.messageApi}",
        //         "f400",
        //         "assets/images/sorry.png");
        //   }
        //   return;
        // });
      } else {
        ReusableClasses().modalbottomWarning(context, "Tidak Valid!",
            "Action anda tidak sesuai", 'f404', 'assets/images/sorry.png');
      }
    }
  }

  // ++ BOTTOM MODAL ACTION ITEM
  void modalActionItem(
      context,
      String token,
      String keterangan,
      String kategori, 
      String duedate
      ) {
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
                  Text('DETAIL KOMPONEN',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Keterangan : ' + keterangan,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text('Kategori: ' + kategori,
                      style: TextStyle(fontSize: 16)),
                  Text('Due date: ' + duedate, style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    thickness: 1.0,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // modalAddSite(
                        //     context, 'ubah', token, idkomponen, idmesin);
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
                            child: Text('EDIT SITE',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // _modalKonfirmasi(context, token, 'hapus', idkomponen,
                        //     nama, jumlah, idmesin);
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
                            child: Text('HAPUS SITE',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ))),
                ],
              ),
            ),
          );
        });
  }
}
