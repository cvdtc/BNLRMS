import 'dart:convert';

class ProgressModelAdd {
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
  tipe;

  ProgressModelAdd(
      {
        this.idprogress,
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
      this.tipe
      });

  factory ProgressModelAdd.fromJson(Map<dynamic, dynamic> map) {
    return ProgressModelAdd(
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
        tipe: map["tipe"]
        );
  }

  Map<String, dynamic> toJson() {
    return {
      "keterangan": keterangan,
      "idpermintaan": idpermintaan,
      "idnextuser": idnextuser,
      "tipe": tipe
    };
  }

  @override
  String toString() {
    return 'keterangan: $keterangan, idpermintaan: $idpermintaan, idnextuser: $idnextuser, tipe: $tipe';
  }
}

List<ProgressModelAdd> ProgressModelAddFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<ProgressModelAdd>.from(
      data["data"].map((item) => ProgressModelAdd.fromJson(item)));
}

String ProgressModelAddToJson(ProgressModelAdd data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
