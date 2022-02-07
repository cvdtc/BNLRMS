import 'dart:convert';

class PerpanjanganModel {
  // ++ list json response
  // var TGLSERTIFIKAT, TGLPERPANJANGAN, PRODUK,KELAS, NAMA, SALES;
  var tglsertifikat, tglperpanjangan, produk, kelas, nama, sales;
// ++ addons json

  PerpanjanganModel(
      {this.tglsertifikat,
      this.tglperpanjangan,
      this.produk,
      this.kelas,
      this.nama,
      this.sales});

  factory PerpanjanganModel.fromJson(Map<dynamic, dynamic> map) {
    return PerpanjanganModel(
      tglsertifikat: map["TGLSERTIFIKAT"],
      tglperpanjangan: map["TGLPERPANJANGAN"],
      produk: map["PRODUK"],
      kelas: map["KELAS"],
      nama: map["NAMA"],
      sales: map["SALES"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "tglsertifikat": tglsertifikat,
      "tglperpanjangan": tglperpanjangan,
      "produk": produk,
      "kelas": kelas,
      "nama": nama,
      "sales": sales,
    };
  }
}

List<PerpanjanganModel> PerpanjanganModelFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<PerpanjanganModel>.from(
      data["data"].map((item) => PerpanjanganModel.fromJson(item)));
}

String PerpanjanganModelToJson(PerpanjanganModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
