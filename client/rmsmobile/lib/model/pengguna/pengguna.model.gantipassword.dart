import 'dart:convert';

class ChangePassword {
  var token,
      idpengguna,
      nama,
      username,
      password,
      jabatan,
      notification_token,
      aktif;

  ChangePassword(
      {this.token,
      this.idpengguna,
      this.nama,
      this.username,
      this.password,
      this.jabatan,
      this.notification_token,
      this.aktif});

  factory ChangePassword.fromJson(Map<dynamic, dynamic> map) {
    return ChangePassword(
      idpengguna: map["idpengguna"],
      nama: map["nama"],
      username: map["username"],
      password: map["password"],
      jabatan: map["jabatan"],
      notification_token: map["notification_token"],
      aktif: map["aktif"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nama": nama,      
      "password": password,
      "username": username,
      "jabatan": jabatan,
      "notification_token": notification_token,
      "aktif": aktif
    };
  }

  @override
  String toString() {
    return 'nama: $nama, username: $username, password: $password, jabatan:$jabatan, notification_token: $notification_token, aktif: $aktif';
  }
}

List<ChangePassword> ChangePasswordFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<ChangePassword>.from(
      data["data"].map((item) => ChangePassword.fromJson(item)));
}

String ChangePasswordToJson(ChangePassword data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
