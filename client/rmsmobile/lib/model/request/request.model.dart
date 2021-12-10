import 'dart:convert';

class RequestModel {
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

  RequestModel(
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

  factory RequestModel.fromJson(Map<dynamic, dynamic> map) {
    return RequestModel(
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
      // "keterangan_selesai": keterangan_selesai,
      // "tipeupdate": tipeupdate
    };
  }

  @override
  String toString() {
    return 'keterangan: $keterangan, kategori: $kategori, due_date: $due_date, flag_selesai: $flag_selesai';
  }
}

List<RequestModel> RequestModelFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<RequestModel>.from(
      data["data"].map((item) => RequestModel.fromJson(item)));
}

String RequestModelToJson(RequestModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
