import 'dart:convert';

class ProgressModelEdit {
  var keterangan, flag_selesai, next_idpengguna, idprogress;

  ProgressModelEdit(
      {
        this.keterangan,
        this.flag_selesai,
        this.next_idpengguna,
        this.idprogress
      });

  factory ProgressModelEdit.fromJson(Map<dynamic, dynamic> map) {
    return ProgressModelEdit(
        keterangan: map["keterangan"],
        flag_selesai: map["flag_selesai"],
        next_idpengguna: map["next_idpengguna"],
        idprogress: map["idprogress"]
        );
  }

  Map<String, dynamic> toJson() {
    return {
      "keterangan": keterangan,
      "flag_selesai": flag_selesai,
      "next_idpengguna": next_idpengguna,
    };
  }

  @override
  String toString() {
    return 'keterangan: $keterangan, flag_selesai: $flag_selesai, next_idpengguna: $next_idpengguna, idprogress: $idprogress';
  }
}

List<ProgressModelEdit> ProgressModelEditFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<ProgressModelEdit>.from(
      data["data"].map((item) => ProgressModelEdit.fromJson(item)));
}

String ProgressModelEditToJson(ProgressModelEdit data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
