import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/login/loginModel.dart';
import 'package:rmsmobile/utils/ReusableClasses.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:rmsmobile/widget/bottomnavigationbar.dart';

import '../../utils/warna.dart';

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
  bool
      // _fieldEmail = false,
      _obsecureText = true,
      // _fieldPassword = false,
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
                image: AssetImage('assets/images/rmsbg.png'),
                fit: BoxFit.cover),
            color: backgroundcolor
            // gradient: LinearGradient(
            //     colors: [thirdcolor.withOpacity(0.6), thirdcolor],
            //     begin: Alignment.bottomCenter,
            //     end: Alignment.topCenter),
            ),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 180,
              ),
              Container(
                height: 125,
                width: 225,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/images/bnlnewlogoblack.png',
                        ),
                        fit: BoxFit.contain)),
              ),
              // Text(
              //   'Selamat Datang',
              //   style: TextStyle(
              //       color: Colors.white,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 35),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Text(
              //   'Masukkan username yang sudah terdaftar',
              //   style: TextStyle(color: Colors.white, fontSize: 14),
              // ),
              SizedBox(
                height: 40,
              ),
              Container(child: _TextEditingUsername()),
              SizedBox(
                height: 20,
              ),
              Container(child: _TextEditingPassword()),
              SizedBox(
                height: 35,
              ),
              ElevatedButton(
                  onPressed: () {
                    loginClick();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0.0, primary: darkgreen),
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
                              fontSize: 26.0,
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
        style: TextStyle(color: darkgreen, fontSize: 22.0),
        cursorColor: darkgreen,
        controller: _controllerUsername,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hoverColor: darkgreen,
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          focusColor: darkgreen,
          icon: Icon(
            Icons.people_alt_outlined,
            color: darkgreen,
          ),
          hintText: 'Masukkan Username',
          suffixIcon: Icon(
            Icons.check_circle,
            color: darkgreen,
          ),
        ));
  }

  // * widget for text editing password
  Widget _TextEditingPassword() {
    return TextFormField(
        style: TextStyle(color: darkgreen, fontSize: 22.0),
        cursorColor: darkgreen,
        controller: _controllerPassword,
        obscureText: _obsecureText,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hoverColor: darkgreen,
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          icon: Icon(
            Icons.password,
            color: darkgreen,
          ),
          hintText: 'Masukkan Password',
          suffixIcon: IconButton(
            onPressed: _toggle,
            icon: new Icon(
              _obsecureText ? Icons.remove_red_eye : Icons.visibility_off,
              color: darkgreen,
            ),
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
    _apiService.loginIn(pengguna).then((isSuccess) {
      setState(() => isloading = false);
      // if login success page will be route to home page
      if (isSuccess) {
        _controllerUsername.clear();
        _controllerPassword.clear();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNav(
                      numberOfpage: 0,
                    )));
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
