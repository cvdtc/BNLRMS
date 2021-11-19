import 'package:flutter/material.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/request/request.model.dart';
import 'package:rmsmobile/utils/warna.dart';

class ReusableClass {
  ApiService _apiService = new ApiService();
  TextEditingController _tecKeterangan = TextEditingController(text: "");
  TextEditingController _tecDueDate = TextEditingController(text: "");
  String _dropdownValue = "Paten";

  // ++ BOTTOM MODAL INPUT FORM
  void modalAddSite(context, String tipe, String token, String keterangan,
      String duedate, String flag_selesai, String idpermintaan) {
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
                    tipe.toUpperCase(),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                      controller: _tecKeterangan,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                          icon: Icon(Icons.cabin_rounded),
                          labelText: 'Deskripsi Permintaan',
                          hintText: 'Masukkan Deskripsi',
                          suffixIcon:
                              Icon(Icons.check_circle_outline_outlined))),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text('Jenis Rumah '),
                              SizedBox(
                                width: 10.0,
                              ),
                              DropdownButton(
                                dropdownColor: Colors.white,
                                value: _dropdownValue,
                                icon: Icon(Icons.arrow_drop_down),
                                onChanged: (String? value) {
                                  // setState(() {
                                  _dropdownValue = value!;
                                  print("Value Dropdown? " + value);
                                  // });
                                },
                                items: <String>[
                                  'Paten',
                                  'Merek',
                                  'Desain Industri',
                                  'Lainnya'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                      value: value, child: Text(value));
                                }).toList(),
                              )
                            ],
                          ),
                        ),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      controller: _tecDueDate,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          icon: Icon(Icons.note_outlined),
                          labelText: 'Due Date',
                          hintText: 'Pilih Tanggal',
                          suffixIcon:
                              Icon(Icons.check_circle_outline_outlined))),
                  SizedBox(
                    height: 15.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        print("VALUE?" +
                            token +
                            tipe +
                            '0' +
                            _dropdownValue.toString() +
                            _tecDueDate.text.toString() +
                            _tecKeterangan.text.toString());
                        _modalKonfirmasi(
                            context,
                            token,
                            'tambah',
                            _tecKeterangan.text.toString(),
                            _dropdownValue.toString(),
                            _tecDueDate.text.toString(),
                            '0',
                            "");
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
  void _modalKonfirmasi(
      context,
      String token,
      String tipe,
      String keterangan,
      String kategori,
      String duedate,
      String flag_selesai,
      String idpermintaan) {
    if (keterangan == "" || duedate == "" || kategori == "") {
      _modalbottomSite(
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
                        ElevatedButton(
                            onPressed: () {
                              // Navigator.of(context).pop();
                              print("Will be Execute" +
                                  tipe +
                                  token +
                                  keterangan +
                                  kategori +
                                  duedate +
                                  flag_selesai);
                              _actiontoapi(context, tipe, token, keterangan,
                                  kategori, duedate, flag_selesai, "");
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
  void _actiontoapi(
      context,
      String tipe,
      String token,
      String keterangan,
      String kategori,
      String duedate,
      String flag_selesai,
      String idpermintaan) {
    print('here?');
    print("Will be Execute" +
        tipe +
        token +
        keterangan +
        kategori +
        duedate +
        flag_selesai);
    if (keterangan == "" || duedate == "" || kategori == "") {
      _modalbottomSite(
          context,
          "Tidak Valid!",
          "Pastikan semua kolom terisi dengan benar",
          'f405',
          'assets/images/sorry.png');
    } else {
      print('here??');
      RequestModel data = RequestModel(
          keterangan: keterangan,
          kategori: kategori,
          due_date: duedate,
          flag_selesai: flag_selesai);
      print('model ?' + data.toString());
      if (tipe == 'tambah') {
        _apiService.addRequest(token, data).then((isSuccess) {
          if (isSuccess) {
            Navigator.of(context).pop();
            _tecKeterangan.clear();
            _tecDueDate.clear();
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
      } else if (tipe == 'ubah') {
        print('ubah belum kamu buat');

        // _apiService.ubahSite(token, idsite, data).then((isSuccess) {
        //   print(isSuccess);
        //   if (isSuccess) {
        //     Navigator.of(context).pop();
        //     _tecNama.clear();
        //     _tecKeterangan.clear();
        //     _modalbottomSite(
        //         context,
        //         "Berhasil!",
        //         "${_apiService.responseCode.messageApi}",
        //         "f200",
        //         "assets/images/congratulations.png");
        //   } else {
        //     _modalbottomSite(
        //         context,
        //         "Gagal!",
        //         "${_apiService.responseCode.messageApi}",
        //         "f400",
        //         "assets/images/sorry.png");
        //   }
        //   return;
        // });
      } else if (tipe == 'hapus') {
        print('hapus belum kamu buat');
        // _apiService.hapusSite(token, idsite).then((isSuccess) {
        //   if (isSuccess) {
        //     _modalbottomSite(
        //         context,
        //         "Berhasil!",
        //         "${_apiService.responseCode.messageApi}",
        //         "f200",
        //         "assets/images/congratulations.png");
        //   } else {
        //     _modalbottomSite(
        //         context,
        //         "Gagal!",
        //         "${_apiService.responseCode.messageApi}",
        //         "f400",
        //         "assets/images/sorry.png");
        //   }
        //   return;
        // });
      } else {
        _modalbottomSite(context, "Tidak Valid!", "Action anda tidak sesuai",
            'f404', 'assets/images/sorry.png');
      }
    }
  }

  // ++ BOTTOM MODAL ACTION ITEM
  void modalActionItem(context, token, String keterangan, String duedate,
      String kategori, String idpermintaan) {
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
                  Text('DETAIL',
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
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // modalAddSite(
                        //     context, 'ubah', token, nama, keterangan, idsite);
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
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // modalAddSite(
                        //     context, 'ubah', token, nama, keterangan, idsite);
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
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // modalAddSite(
                        //     context, 'ubah', token, nama, keterangan, idsite);
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
                            child: Text('EDIT PPERMINTAAN',
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
                        Navigator.of(context).pop();
                        // _modalKonfirmasi(context, token, 'hapus',
                        //     idsite.toString(), nama, '-');
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
                            child: Text('HAPUS PERMINTAAN',
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

  _modalbottomSite(context, String title, String message, String kode,
      String imagelocation) {
    print('Yash im show');
    dynamic navigation;
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
