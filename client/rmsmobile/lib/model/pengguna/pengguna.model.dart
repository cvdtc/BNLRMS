import 'dart:convert';

class PenggunaModel {
  var token, idpengguna, nama, username, jabatan, notification_token, aktif;

  PenggunaModel(
      {this.token,
      this.idpengguna,
      this.nama,
      this.username,
      this.jabatan,
      this.notification_token,
      this.aktif});

  factory PenggunaModel.fromJson(Map<dynamic, dynamic> map) {
    return PenggunaModel(
        idpengguna: map["idpengguna"],
        nama: map["nama"],
        // username: map["username"],
        // jabatan: map["jabatan"],
        // notification_token: map["notification_token"],
        // aktif: map["aktif"]
        );
  }

  Map<String, dynamic> toJson() {
    return {
      "idpengguna": idpengguna,
      "nama": nama,
      "username": username,
      "jabatan": jabatan,
      "notification_token": notification_token,
      "aktif": aktif
    };
  }

  @override
  String toString() {
    return 'idpengguna: $idpengguna, nama: $nama, username: $username, jabatan:$jabatan, notification_token: $notification_token, aktif: $aktif';
  }
}

List<PenggunaModel> PenggunaModelFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<PenggunaModel>.from(
      data["data"].map((item) => PenggunaModel.fromJson(item)));
}

String PenggunaModelToJson(PenggunaModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
