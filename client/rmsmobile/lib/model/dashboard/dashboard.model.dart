import 'dart:convert';

class DashboardModel {
  var jml_masalah, jml_selesai;

  DashboardModel({this.jml_masalah, this.jml_selesai});
  factory DashboardModel.fromJson(Map<dynamic, dynamic> map) {
    return DashboardModel(
        jml_masalah: map["jml_masalah"], jml_selesai: map["jml_selesai"]);
  }

  @override
  String toString() {
    return 'jml_masalah: $jml_masalah, jml_selesai: $jml_selesai';
  }
}

List<DashboardModel> dashboardFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<DashboardModel>.from(
      data["data"].map((item) => DashboardModel.fromJson(item)));
}
