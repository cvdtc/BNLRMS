import 'dart:convert';

class DashboardModel {
  var belum_selesai, selesai, jumlah;

  DashboardModel({this.belum_selesai, this.selesai, this.jumlah});
  factory DashboardModel.fromJson(Map<dynamic, dynamic> map) {
    return DashboardModel(
        belum_selesai: map["belum_selesai"], selesai: map["sudah_selesai"]);
  }

  @override
  String toString() {
    return 'belum_selesai: $belum_selesai, selesai: $selesai';
  }
}

List<DashboardModel> dashboardFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<DashboardModel>.from(
      data["data"].map((item) => DashboardModel.fromJson(item)));
}
