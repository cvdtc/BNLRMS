import 'dart:convert';

class LoginModel {
  var username, password, tipe, nama;
  LoginModel({this.username, this.password, this.tipe, this.nama});

  Map<String, dynamic> toJson() {
    return {"username": username, "password": password, "tipe": tipe};
  }

  @override
  String toString() {
    return 'LoginModel{username: $username, password: $password, tipe: $tipe, nama: $nama}';
  }
}

String loginToJson(LoginModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
