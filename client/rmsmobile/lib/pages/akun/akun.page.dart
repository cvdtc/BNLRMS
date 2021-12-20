import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/pengguna/pengguna.model.gantipassword.dart';
import 'package:rmsmobile/pages/akun/akun.bottommodal.dart';
import 'package:rmsmobile/pages/login/login.dart';
import 'package:rmsmobile/pages/setting/setting_notif.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AkunPage extends StatefulWidget {
  @override
  _AkunPageState createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  late SharedPreferences sp;
  bool
      // _obsecureText = true,
      _fieldPassword = false;
  // _fieldPasswordretype = false
  // ;
  String? token = "", username = "", jabatan = "", nama = "";
  TextEditingController _textFieldControllerGantipass = TextEditingController();
  TextEditingController _textFieldControllerGantipassretype =
      TextEditingController();

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
      username = sp.getString("username");
      nama = sp.getString("nama");
      jabatan = sp.getString("jabatan");
    });
    if (token == null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Loginscreen(
                    tipe: 'sesiberakhir',
                  )));
    }
  }

  @override
  initState() {
    super.initState();
    cekToken();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.only(top: 45),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset('assets/images/bnllogo.png'),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(nama.toString().toUpperCase(),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                Text(jabatan.toString())
              ]),
            ],
          ),
          _option(context),
          Text('v.1.2.0 Beta (S)')
        ],
      ),
    ));
  }

  alertgantiPasword() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ganti Password'),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.password_outlined),
                )
              ],
            ),
            content: Container(
              height: 130,
              child: Column(
                children: [
                  TextField(
                    controller: _textFieldControllerGantipass,
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Ganti password disini !',
                    ),
                    onChanged: (value) {
                      bool isFieldValid = value.trim().isNotEmpty;
                      if (isFieldValid != _fieldPassword) {
                        setState(() => _fieldPassword = isFieldValid);
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _textFieldControllerGantipassretype,
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'ulangi Password !',
                    ),
                    onChanged: (value) {
                      bool isFieldValid = value.trim().isNotEmpty;
                      if (isFieldValid != _fieldPassword) {
                        setState(() => _fieldPassword = isFieldValid);
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      ChangePassword gantipass = ChangePassword(
                          nama: nama,
                          username: username,
                          password:
                              _textFieldControllerGantipass.text.toString(),
                          jabatan: jabatan,
                          notification_token: "",
                          aktif: 1);
                      if (_textFieldControllerGantipass.text.toString() == "" ||
                          _textFieldControllerGantipassretype.text.toString() ==
                              "") {
                        Fluttertoast.showToast(
                            msg: "Maaf, pastikan semua kolom terisi",
                            backgroundColor: Colors.red,
                            textColor: Colors.white);
                      } else if (_textFieldControllerGantipassretype.text
                              .toString() !=
                          _textFieldControllerGantipass.text.toString()) {
                        Fluttertoast.showToast(
                            msg:
                                "Maaf, Kolom Password tidak sama dengan retype password",
                            backgroundColor: Colors.red,
                            textColor: Colors.white);
                      } else {
                        ApiService()
                            .ubahPassword(token.toString(), gantipass)
                            .then((isSuccess) {
                          if (isSuccess) {
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "Berhasil Ubah Password",
                                backgroundColor: Colors.black,
                                textColor: Colors.white);
                          } else {
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "Maaf, password gagal diubah",
                                backgroundColor: Colors.red,
                                textColor: Colors.white);
                          }
                        });
                      }
                    },
                    child: Text('Simpan')),
              )
            ],
          );
        });
  }

  Widget _option(context) {
    return Card(
      color: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
                left: 1 - .0, right: 1 - .0, top: 5.0, bottom: 5.0),
            alignment: Alignment.center,
            width: double.infinity,
            child: ListTile(
              onTap: () {
                alertgantiPasword();
              },
              title: (Text(
                'Ganti Password',
                style: TextStyle(fontSize: 18, color: Colors.black),
              )),
              leading: Icon(
                Icons.password_rounded,
                color: Colors.black,
                size: 22,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
                left: 1 - .0, right: 1 - .0, top: 5.0, bottom: 5.0),
            alignment: Alignment.center,
            width: double.infinity,
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingNotifikasi()));
              },
              title: (Text(
                'Setting Notifikasi',
                style: TextStyle(fontSize: 18, color: Colors.black),
              )),
              leading: Icon(
                Icons.notifications_active_outlined,
                color: Colors.black,
                size: 22,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: 1 - .0, right: 1 - .0, top: 5.0, bottom: 5.0),
            alignment: Alignment.center,
            width: double.infinity,
            child: ListTile(
              onTap: () {
                _modalKonfirmasi();
              },
              title: (Text(
                'Keluar',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
              leading: Icon(
                Icons.exit_to_app_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

// ++ BOTTOM MODAL CONFIRMATION
  void _modalKonfirmasi() {
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
                    'Keluar',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Apakah anda mau keluar aplikasi ?',
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
                                "Tidak",
                              ),
                            ),
                          )),
                      SizedBox(
                        width: 55,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            AkunBottomModal().exit(context);
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
                                "Ya",
                                style: TextStyle(
                                    color: primarycolor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
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
