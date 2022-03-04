import 'dart:convert';

class RequestModel {
  // ++ list json response
  var idpermintaan,
      keterangan,
      kategori,
      due_date,
      created,
      edited,
      flag_selesai,
      keterangan_selesai,
      nama_request,
      jmlprogress,
      url_permintaan,
      date_selesai;
// ++ addons json

  RequestModel(
      {this.idpermintaan,
      this.keterangan,
      this.kategori,
      this.due_date,
      this.created,
      this.edited,
      this.flag_selesai,
      this.keterangan_selesai,
      this.nama_request,
      this.jmlprogress,
      this.url_permintaan,
      this.date_selesai});

  factory RequestModel.fromJson(Map<dynamic, dynamic> map) {
    return RequestModel(
      idpermintaan: map["idpermintaan"],
      keterangan: map["keterangan"],
      kategori: map["kategori"],
      due_date: map["due_date"],
      created: map["created"],
      edited: map["edited"],
      flag_selesai: map["flag_selesai"],
      keterangan_selesai: map["keterangan_selesai"],
      nama_request: map["nama_request"],
      jmlprogress: map["jmlprogress"],
      url_permintaan: map["url_permintaan"],
      date_selesai: map["date_selesai"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "keterangan": keterangan,
      "kategori": kategori,
      "due_date": due_date,
      "flag_selesai": flag_selesai,
      "url_permintaan": url_permintaan,
      "keterangan_selesai": keterangan_selesai,
      "date_selesai": date_selesai,
    };
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
