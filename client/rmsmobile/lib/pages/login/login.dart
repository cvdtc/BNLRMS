import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/login/loginModel.dart';
import 'package:rmsmobile/utils/ReusableClasses.dart';
import 'package:rmsmobile/utils/TextFieldContainer.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:rmsmobile/widget/bottomnavigationbar.dart';

class Loginscreen extends StatefulWidget {
  var tipe;
  Loginscreen({this.tipe});

  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  ApiService _apiService = ApiService();
  TextEditingController _controllerUsername = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  bool _fieldEmail = false,
      _obsecureText = true,
      _fieldPassword = false,
      isloading = false;
  var emailaccountselection, token = '', tipelogin;

  void _toggle() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tipelogin = widget.tipe;
    // if (tipelogin == 'sesiberakhir') {
    //   ReusableClasses().modalbottomWarning(
    //       context,
    //       'Sesi Berakhir',
    //       'Waaah, sesi anda sudah berakhir nih, login lagi yaa.... :)',
    //       'f401',
    //       'assets/images/sorry.png');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(25.0),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/1.png'), fit: BoxFit.cover),
          gradient: LinearGradient(
              colors: [Color(0xffCCE9CC), thirdcolor],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 180,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    'Selamat Datang',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    'Masukkan username yang sudah terdaftar',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  )
                ],
              ),
              SizedBox(
                height: 65,
              ),
              Container(child: _TextEditingUsername()),
              SizedBox(
                height: 10,
              ),
              Container(child: _TextEditingPassword()),
              SizedBox(
                height: 45,
              ),
              ElevatedButton(
                  onPressed: () {
                    loginClick();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0.0, primary: Colors.blue),
                  child: Ink(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0)),
                      child: Container(
                        width: 325,
                        height: 55,
                        alignment: Alignment.center,
                        child: Text('L O G I N',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            )),
                      )))
            ],
          ),
        ),
      ),
    );
  }

  // * widget for text editing username
  Widget _TextEditingUsername() {
    return TextFormField(
        controller: _controllerUsername,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          focusColor: thirdcolor,
          icon: Icon(Icons.people_alt_outlined),
          hintText: 'Masukkan Username',
          suffixIcon: Icon(Icons.check_circle),
        ));
  }

  // * widget for text editing password
  Widget _TextEditingPassword() {
    return TextFormField(
        cursorColor: thirdcolor,
        controller: _controllerPassword,
        obscureText: _obsecureText,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          icon: Icon(Icons.password),
          hintText: 'Masukkan Password',
          suffixIcon: IconButton(
            onPressed: _toggle,
            icon: new Icon(
                _obsecureText ? Icons.remove_red_eye : Icons.visibility_off),
          ),
        ));
  }

  loginClick() {
    isloading = true;
    String username = _controllerUsername.text.toString();
    String password = _controllerPassword.text.toString();
    // set model value for json
    LoginModel pengguna =
        LoginModel(username: username, password: password, tipe: 'mobile');
    //execute sending json to api url
    print("LOGIN? : " + pengguna.toString());
    _apiService.loginIn(pengguna).then((isSuccess) {
      setState(() => isloading = false);
      // if login success page will be route to home page
      if (isSuccess) {
        print('sukses masuk');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNav()));
      } else {
        ReusableClasses().modalbottomWarning(
            context,
            'Login Gagal!',
            '${_apiService.responseCode.messageApi} [error : ${isSuccess}]',
            'f400',
            'assets/images/sorry.png');
      }
      return;
    }).onError((error, stackTrace) {
      ReusableClasses().modalbottomWarning(
          context,
          'Koneksi Bermasalah!',
          'Pastikan Koneksi anda stabil terlebih dahulu, apabila masih terkendala hubungi IT. ${error}',
          'f500',
          'assets/images/sorry.png');
    });
    return;
  }
}
