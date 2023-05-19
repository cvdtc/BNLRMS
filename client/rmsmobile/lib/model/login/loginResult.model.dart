import 'dart:convert';

class LoginResult {
  String access_token, refresh_token, username, jabatan, nama;
  int idpengguna;

  LoginResult(
      {required this.access_token,
      required this.refresh_token,
      required this.username,
      required this.jabatan,
      required this.nama,
      required this.idpengguna});
  factory LoginResult.fromJson(Map<dynamic, dynamic> map) {
    return LoginResult(
        access_token: map["access_token"],
        username: map["username"],
        jabatan: map["jabatan"],
        refresh_token: map["refresh_token"],
        nama: map['nama'],
        idpengguna: map['idpengguna']);
  }

  @override
  String toString() {
    return 'LoginResult{access_token: $access_token, refresh_token: $refresh_token, username: $username, jabatan: $jabatan, nama: $nama, idpengguna: $idpengguna}';
  }
}

List<LoginResult> resultloginFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<LoginResult>.from(
      data["data"].map((item) => LoginResult.fromJson(item)));
}
