import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/login/loginModel.dart';
import 'package:rmsmobile/utils/ReusableClasses.dart';
import 'package:rmsmobile/utils/TextFieldContainer.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:rmsmobile/widget/bottomnavigationbar.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({Key? key}) : super(key: key);

  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  ApiService _apiService = ApiService();
  TextEditingController _controllerUsername = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  bool _fieldEmail= false, _obsecureText = true, _fieldPassword=false, isloading = false;
  var emailaccountselection, token = '';

  void _toggle() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
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
                    'Masukkan akun yang sudah terdaftar',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  )
                ],
              ),
              SizedBox(
                height: 65,
              ),
              _buildTextFieldEmail(),
              SizedBox(
                height: 10,
              ),
              _buildTextFieldPassword(),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      child: Text(
                        'Lupa Password?',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: ButtonTheme(
                    buttonColor: Colors.white,
                    minWidth: MediaQuery.of(context).size.width,
                    height: 55,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNav()));
                        loginClick();
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.blue, fontSize: 22),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldEmail() {
    return TextFieldContainer(
      child: TextField(
        textInputAction: TextInputAction.next,
        // enabled: uuidAnyar != "" ? false : true,
        controller: _controllerUsername,
        decoration: InputDecoration(
          icon: Icon(
            Icons.mail,
            color: Colors.blue,
          ),
          hintText: "Email",
          fillColor: Colors.lightBlue,
          border: InputBorder.none,
          // errorText:
          //     _fieldEmail == null || _fieldEmail ? null : "Email Harus Diisi!",
        ),
        onChanged: (value) {
          bool isFieldValid = value.trim().isNotEmpty;
          if (isFieldValid != _fieldEmail) {
            setState(() => _fieldEmail = isFieldValid);
          }
        },
      ),
    );
  }

  Widget _buildTextFieldPassword() {
    return TextFieldContainer(
      child: TextField(
        textInputAction: TextInputAction.done,
        controller: _controllerPassword,
        keyboardType: TextInputType.text,
        obscureText: _obsecureText,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            color: Colors.blue,
          ),
          suffixIcon: IconButton(
            onPressed: _toggle,
            icon: new Icon(
                _obsecureText ? Icons.remove_red_eye : Icons.visibility_off),
          ),
          hintText: "Password",
          fillColor: Colors.white12,
          border: InputBorder.none,
          // errorText: _fieldPassword == null || _fieldPassword
          //     ? null
          //     : "Password Harus Diisi!",
        ),
        onChanged: (value) {
          bool isFieldValid = value.trim().isNotEmpty;
          if (isFieldValid != _fieldPassword) {
            setState(() => _fieldPassword = isFieldValid);
          }
        },
      ),
    );
  }

  loginClick() {
    isloading = true;
    String username = _controllerUsername.text.toString();
    String password = _controllerPassword.text.toString();
    // set model value for json
    LoginModel pengguna = LoginModel(
      username: username,
      password: password,
      tipe: 'mobile'
          );
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
        }return;
    }).onError((error, stackTrace){
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
