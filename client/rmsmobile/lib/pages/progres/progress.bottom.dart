import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/progress/progress.model.dart';
import 'package:rmsmobile/utils/ReusableClasses.dart';
import 'package:rmsmobile/utils/warna.dart';

class ProgressModalBottom {
  ApiService _apiService = new ApiService();
  TextEditingController _tecKeterangan = TextEditingController(text: "");
  TextEditingController _tecKeteranganNextUser =
      TextEditingController(text: "");
  TextEditingController _tecUrlProgress = TextEditingController(text: "");
  String _dropdownValue = "Merek";
  // * for edit progress
  bool flagswitchnextuser = false;
  /**
   * * parameter yang dikirim :
   * * tipe yaitu insert update atau delete
   * * token jwt yang di ambil dari shared preferences
   * * keterangan adalah deskripsi progress
   * * idpermintaan adalah idpermintaan yang dikirim dari listview
   * * tipeinsert adalah tipe yang akan dikirim ke api sebagai filter, apabila tipeinsert berisi tambahprogress makan yang di simpan ke database adalah idpengguna yang membuat progress akan tetapi jika yang dikirim nextuser maka idpengguna yang disimpan ke database adalah idnext_user
   * * idprogress dibutuhkan jika parameter tipe yang dikirim adalah update
   * * flag_selesai berisi 0/1 untuk menentukan apakah progress yang dibuat sudah selesai atau belum
   * * next_idpengguna adalah idpengguna yang dipilih user dari combobox halaman progress
   * * keterangan_next user untuk memberikan deskripsi atau note kepada user yang dituju
   * * url_progress untuk memberikan / menyematkan url jika diperlukan
   */

  // ++ BOTTOM MODAL INPUT FORM
  void modalAddProgress(
      context,
      String tipe,
      String token,
      String keterangan,
      String idpermintaan,
      String tipeinsert,
      String idprogress,
      String flag_selesai,
      String next_idpengguna,
      String keterangan_nextuser,
      String url_progress) {
    // * setting value text form field if action is edit
    if (tipe == 'ubah' && idprogress != "") {
      _tecKeterangan.value = TextEditingValue(
          text: keterangan,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecKeterangan.text.length)));
      _tecKeteranganNextUser.value = TextEditingValue(
          text: keterangan_nextuser,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecKeteranganNextUser.text.length)));
      _tecUrlProgress.value = TextEditingValue(
          text: url_progress,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecUrlProgress.text.length)));
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
                    tipe.toUpperCase() + " PROGRES",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                      controller: _tecKeterangan,
                      decoration: InputDecoration(
                          icon: Icon(Icons.description_rounded),
                          labelText: 'Deskripsi Progres',
                          hintText: 'Masukkan Deskripsi',
                          suffixIcon:
                              Icon(Icons.check_circle_outline_outlined))),
                  TextFormField(
                      controller: _tecUrlProgress,
                      decoration: InputDecoration(
                          icon: Icon(Icons.link_rounded),
                          labelText: 'Sematkan URL',
                          hintText: 'Masukkan URL',
                          suffixIcon:
                              Icon(Icons.check_circle_outline_outlined))),
                  SizedBox(
                    height: 15.0,
                  ),
                  tipe == "ubah"
                      ? Row(
                          children: [
                            Text('Assign To : '),
                            Switch(
                              onChanged: (bool value) {
                                // setState(() {
                                flagswitchnextuser = value;
                                // });
                              },
                              activeTrackColor: thirdcolor,
                              activeColor: Colors.green,
                              value: flagswitchnextuser,
                            ),
                            flagswitchnextuser == true
                                ? TextFormField(
                                    controller: _tecKeteranganNextUser,
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.cabin_rounded),
                                        labelText: 'Keterangan Next Progress',
                                        hintText: 'Masukkan Deskripsi',
                                        suffixIcon: Icon(Icons
                                            .check_circle_outline_outlined)))
                                : SizedBox(
                                    height: 0,
                                  ),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        print('simpan clicked');
                        Navigator.of(context).pop();
                        modalKonfirmasi(
                            context,
                            tipe,
                            token,
                            _tecKeterangan.text.toString(),
                            idpermintaan,
                            tipeinsert,
                            idprogress,
                            flag_selesai,
                            next_idpengguna,
                            _tecKeteranganNextUser.text.toString(),
                            _tecUrlProgress.text.toString());
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0, primary: backgroundcolor),
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
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          )))
                ],
              ),
            ),
          );
        });
  }

/**
   * * parameter yang dikirim :
   * * tipe yaitu insert update atau delete
   * * token jwt yang di ambil dari shared preferences
   * * keterangan adalah deskripsi progress
   * * idpermintaan adalah idpermintaan yang dikirim dari listview
   * * idnext_user apabila progress tersebut sudah selesai dan akan di lanjutkan ke user yang lain jika tidak yang dikirim ""
   * * tipeinsert adalah tipe yang akan dikirim ke api sebagai filter, apabila tipeinsert berisi tambahprogress makan yang di simpan ke database adalah idpengguna yang membuat progress akan tetapi jika yang dikirim nextuser maka idpengguna yang disimpan ke database adalah idnext_user
   * * idprogress dibutuhkan jika parameter tipe yang dikirim adalah update
   * * flag_selesai berisi 0/1 untuk menentukan apakah progress yang dibuat sudah selesai atau belum
   * * next_idpengguna adalah idpengguna yang dipilih user dari combobox halaman progress
   * * keterangan_next user untuk memberikan deskripsi atau note kepada user yang dituju
   * * url_progress untuk memberikan / menyematkan url jika diperlukan
   */

  // ++ BOTTOM MODAL CONFIRMATION
  void modalKonfirmasi(
      context,
      String tipe,
      String token,
      String keterangan,
      String idpermintaan,
      String tipeinsert,
      String idprogress,
      String flag_selesai,
      String next_idpengguna,
      String keterangan_nextuser,
      String url_progress) {
    if (keterangan == "") {
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
                        ? Text('Apakah anda yakin akan menghapus progress ? ' +
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
                        ElevatedButton(
                            onPressed: () {
                              // Navigator.pop(context);
                              _actiontoApi(
                                  context,
                                  tipe,
                                  token,
                                  keterangan,
                                  idpermintaan,
                                  tipeinsert,
                                  idprogress,
                                  flag_selesai,
                                  next_idpengguna,
                                  keterangan_nextuser,
                                  url_progress);
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
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    }

    // }
  }

  // ++ UNTUK MELAKUKAN TRANSAKSI KE API SESUAI DENGAN PARAMETER TIPE YANG DIKIRIM
  void _actiontoApi(
      context,
      String tipe,
      String token,
      String keterangan,
      String idpermintaan,
      String tipeinsert,
      String idprogress,
      String flag_selesai,
      String next_idpengguna,
      String keterangan_nextuser,
      String url_progress) {
    if (keterangan == "") {
      ReusableClasses().modalbottomWarning(
          context,
          "Tidak Valid!",
          "Pastikan semua kolom terisi dengan benar",
          'f405',
          'assets/images/sorry.png');
    } else {
      ProgressModel dataprogress = ProgressModel(
          keterangan: keterangan,
          idpermintaan: idpermintaan,
          idnextuser: next_idpengguna,
          tipe: tipeinsert,
          flag_selesai: flag_selesai,
          keterangan_selesai: keterangan_nextuser,
          url_progress: url_progress);
      if (tipe == 'tambah') {
        _apiService.addProgres(token, dataprogress).then((isSuccess) {
          if (isSuccess) {
            _tecKeterangan.clear();
            _tecKeteranganNextUser.clear();
            _tecUrlProgress.clear();
            Fluttertoast.showToast(
                msg: "${_apiService.responseCode.messageApi}",
                backgroundColor: Colors.red,
                textColor: Colors.white);
            // ReusableClasses().modalbottomWarning(
            //     context,
            //     "Berhasil!",
            //     "${_apiService.responseCode.messageApi}",
            //     "f200",
            //     "assets/images/congratulations.png");
          } else {
            Fluttertoast.showToast(
                msg: "${_apiService.responseCode.messageApi}",
                backgroundColor: Colors.red,
                textColor: Colors.white);
            // ReusableClasses().modalbottomWarning(
            //     context,
            //     "Gagal!",
            //     "${_apiService.responseCode.messageApi}",
            //     "f400",
            //     "assets/images/sorry.png");
          }
          return;
        }).onError((error, stackTrace) {
          Fluttertoast.showToast(
              msg: "${_apiService.responseCode.messageApi}",
              backgroundColor: Colors.red,
              textColor: Colors.white);
          // ReusableClasses().modalbottomWarning(
          //     context,
          //     "Gagal!",
          //     "${_apiService.responseCode.messageApi}",
          //     "f407",
          //     "assets/images/sorry.png");
        });
      } else if (tipe == 'ubah') {
        _apiService
            .ubahProgres(token, idprogress, dataprogress)
            .then((isSuccess) {
          if (isSuccess) {
            ProgressModel data = ProgressModel(
                keterangan: keterangan,
                idpermintaan: idpermintaan,
                idnextuser: next_idpengguna,
                tipe: tipeinsert,
                flag_selesai: flag_selesai,
                keterangan_selesai: keterangan_nextuser,
                url_progress: url_progress);
            _apiService.addProgres(token, data).then((progressSuccess) {
              if (progressSuccess) {
                Fluttertoast.showToast(
                    msg: "${_apiService.responseCode.messageApi}",
                    backgroundColor: Colors.red,
                    textColor: Colors.white);
                // ReusableClasses().modalbottomWarning(
                //     context,
                //     "Berhasil!",
                //     "${_apiService.responseCode.messageApi}",
                //     "f200",
                //     "assets/images/congratulations.png");
              } else {
                Fluttertoast.showToast(
                    msg: "${_apiService.responseCode.messageApi}",
                    backgroundColor: Colors.red,
                    textColor: Colors.white);
                // ReusableClasses().modalbottomWarning(
                //     context,
                //     "Gagal!",
                //     "${_apiService.responseCode.messageApi}",
                //     "f400",
                //     "assets/images/sorry.png");
              }
            });
          } else {
            Fluttertoast.showToast(
                msg: "${_apiService.responseCode.messageApi}",
                backgroundColor: Colors.red,
                textColor: Colors.white);
            // ReusableClasses().modalbottomWarning(
            //     context,
            //     "Gagal!",
            //     "${_apiService.responseCode.messageApi}",
            //     "f400",
            //     "assets/images/sorry.png");
          }
          return;
        });
      } else if (tipe == 'selesai') {
        _apiService
            .ubahProgres(token, idprogress, dataprogress)
            .then((isSuccess) {
          if (isSuccess) {
            Fluttertoast.showToast(
                msg: "${_apiService.responseCode.messageApi}",
                backgroundColor: Colors.red,
                textColor: Colors.white);
            // Navigator.of(context).pop();
            // ReusableClasses().modalbottomWarning(
            //     context,
            //     "Berhasil!",
            //     "${_apiService.responseCode.messageApi}",
            //     "f200",
            //     "assets/images/congratulations.png");
          } else {
            Fluttertoast.showToast(
                msg: "${_apiService.responseCode.messageApi}",
                backgroundColor: Colors.red,
                textColor: Colors.white);
            // ReusableClasses().modalbottomWarning(
            //     context,
            //     "Gagal!",
            //     "${_apiService.responseCode.messageApi}",
            //     "f400",
            //     "assets/images/sorry.png");
          }
          return;
        });
      } else {
        ReusableClasses().modalbottomWarning(context, "Tidak Valid!",
            "Action anda tidak sesuai", 'f404', 'assets/images/sorry.png');
      }
    }
  }
}
