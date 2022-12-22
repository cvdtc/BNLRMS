import 'dart:convert';

class FilterRequest {
  var tanggal_awal, tanggal_akhir, keyword;
  FilterRequest({this.tanggal_awal, this.tanggal_akhir, this.keyword});

  Map<String, dynamic> toJson() {
    return {
      "tanggal_awal": tanggal_awal,
      "tanggal_akhir": tanggal_akhir,
      "keyword": keyword
    };
  }

  @override
  String toString() {
    return 'FilterRequest{tanggal_awal: $tanggal_awal, tanggal_akhir: $tanggal_akhir, keyword: $keyword}';
  }
}

String filterRequestToJson(FilterRequest data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
