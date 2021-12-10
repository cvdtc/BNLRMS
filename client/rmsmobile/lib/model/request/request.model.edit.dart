import 'dart:convert';

class RequestModelEdit {
  var idpermintaan,
      keterangan,
      kategori,
      created,
      edited,
      flag_selesai,
      keterangan_selesai,
      nama_request,
      due_date,
      token, tipeupdate;

  RequestModelEdit(
      {this.idpermintaan,
      this.keterangan,
      this.kategori,
      this.created,
      this.edited,
      this.flag_selesai,
      this.keterangan_selesai,
      this.nama_request,
      this.due_date,
      this.token,
      this.tipeupdate
      });

  factory RequestModelEdit.fromJson(Map<dynamic, dynamic> map) {
    return RequestModelEdit(
        idpermintaan: map["idpermintaan"],
        keterangan: map["keterangan"],
        kategori: map["kategori"],
        created: map["created"],
        edited: map["edited"],
        flag_selesai: map["flag_selesai"],
        keterangan_selesai: map["keterangan_selesai"],
        nama_request: map["nama_request"],
        due_date: map["due_date"],
        token: map["access_token"],
        tipeupdate: map["tipeupdate"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "keterangan": keterangan,
      "kategori": kategori,
      "due_date": due_date,
      "flag_selesai": flag_selesai,
      "keterangan_selesai": keterangan_selesai,
      "tipeupdate": tipeupdate
    };
  }

  @override
  String toString() {
    return 'keterangan: $keterangan, kategori: $kategori, due_date: $due_date, flag_selesai: $flag_selesai';
  }
}

List<RequestModelEdit> RequestModelEditFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<RequestModelEdit>.from(
      data["data"].map((item) => RequestModelEdit.fromJson(item)));
}

String RequestModelEditToJson(RequestModelEdit data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
