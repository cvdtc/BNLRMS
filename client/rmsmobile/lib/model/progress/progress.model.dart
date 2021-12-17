import 'dart:convert';

class ProgressModel {
  var idprogress,
      keterangan,
      created,
      edited,
      flag_selesai,
      idnextuser,
      idpengguna,
      idpermintaan,
      permintaan,
      kategori,
      due_date,
      nama,
      tipe,
      keterangan_selesai,
      url_progress;

  ProgressModel(
      {this.idprogress,
      this.keterangan,
      this.created,
      this.edited,
      this.flag_selesai,
      this.idnextuser,
      this.idpengguna,
      this.idpermintaan,
      this.permintaan,
      this.kategori,
      this.due_date,
      this.nama,
      this.tipe,
      this.keterangan_selesai,
      this.url_progress});

  factory ProgressModel.fromJson(Map<dynamic, dynamic> map) {
    return ProgressModel(
        idprogress: map["idprogress"],
        keterangan: map["keterangan"],
        created: map["created"],
        edited: map["edited"],
        flag_selesai: map["flag_selesai"],
        idnextuser: map["idnextuser"],
        idpengguna: map["idpengguna"],
        idpermintaan: map["idpermintaan"],
        permintaan: map["permintaan"],
        kategori: map["kategori"],
        due_date: map["due_date"],
        nama: map["nama"],
        url_progress: map["url_progress"]);
  }

  Map<String, dynamic> addToJson() {
    return {
      "keterangan": keterangan,
      "idpermintaan": idpermintaan,
      "idnextuser": idnextuser,
      "tipe": tipe,
      "keterangan_selesai": keterangan_selesai,
      "flag_selesai": flag_selesai,
      "url_progress": url_progress
    };
  }

  @override
  String toString() {
    return 'keterangan: $keterangan, idpermintaan: $permintaan, flag_selesai: $flag_selesai, idnextuser: $idnextuser, due_date: $due_date, permintaan: $permintaan, kategori: $kategori, nama: $nama';
  }
}

List<ProgressModel> ProgressModelFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<ProgressModel>.from(
      data["data"].map((item) => ProgressModel.fromJson(item)));
}

String ProgressToJson(ProgressModel data) {
  final jsonData = data.addToJson();
  return json.encode(jsonData);
}
