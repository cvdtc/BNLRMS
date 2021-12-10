import 'dart:convert';

class ProgressModelDel {
  var idprogress,
  keterangan,
  created,
  edited,
  flag_selesai,
  next_idpengguna,
  idpengguna,
  idpermintaan,
  permintaan,
  kategori,
  due_date;

  ProgressModelDel(
      {
        this.idprogress,
      this.keterangan,
      this.created,
      this.edited,
      this.flag_selesai,
      this.next_idpengguna,
      this.idpengguna,
      this.idpermintaan,
      this.permintaan,
      this.kategori,
      this.due_date
      });

  factory ProgressModelDel.fromJson(Map<dynamic, dynamic> map) {
    return ProgressModelDel(
        idprogress: map["idprogress"],
        keterangan: map["keterangan"],
        created: map["created"],
        edited: map["edited"],
        flag_selesai: map["flag_selesai"],
        next_idpengguna: map["next_idpengguna"],
        idpengguna: map["idpengguna"],
        idpermintaan: map["idpermintaan"],
        permintaan: map["permintaan"],
        kategori: map["kategori"],
        due_date: map["due_date"]
        );
  }

  Map<String, dynamic> toJson() {
    return {
      "idpermintaan": idpermintaan,
    };
  }

  @override
  String toString() {
    return 'idpermintaan: $idpermintaan';
  }
}

List<ProgressModelDel> ProgressModelDelFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<ProgressModelDel>.from(
      data["data"].map((item) => ProgressModelDel.fromJson(item)));
}

String ProgressModelDelToJson(ProgressModelDel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
