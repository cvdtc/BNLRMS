import 'dart:convert';

class FilterRequest {
  var tanggal_awal, tanggal_akhir, keyword, kategori;
  FilterRequest(
      {this.tanggal_awal, this.tanggal_akhir, this.keyword, this.kategori});

  Map<String, dynamic> toJson() {
    return {
      "tanggal_awal": tanggal_awal,
      "tanggal_akhir": tanggal_akhir,
      "keyword": keyword,
      "kategori": kategori
    };
  }

  @override
  String toString() {
    return 'FilterRequest{tanggal_awal: $tanggal_awal, tanggal_akhir: $tanggal_akhir, keyword: $keyword}, kategori: $kategori';
  }
}

String filterRequestToJson(FilterRequest data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
