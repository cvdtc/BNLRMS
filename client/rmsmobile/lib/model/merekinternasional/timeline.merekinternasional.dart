class TimelineMerekInternasionalModel {
  String? message;
  Null? error;
  List<DataTimelineMerekInternasionalModel>? data;

  TimelineMerekInternasionalModel({this.message, this.error, this.data});

  TimelineMerekInternasionalModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    error = json['error'];
    if (json['data'] != null) {
      data = <DataTimelineMerekInternasionalModel>[];
      json['data'].forEach((v) {
        data!.add(new DataTimelineMerekInternasionalModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataTimelineMerekInternasionalModel {
  String? kODE;
  String? dESKRIPSI;
  String? kelas;
  String? kETKELAS;
  String? ngr;
  String? statusd;
  String? tgldoc;
  String? nodoc;
  String? ketd;

  DataTimelineMerekInternasionalModel(
      {this.kODE,
      this.dESKRIPSI,
      this.kelas,
      this.kETKELAS,
      this.ngr,
      this.statusd,
      this.tgldoc,
      this.nodoc,
      this.ketd});

  DataTimelineMerekInternasionalModel.fromJson(Map<String, dynamic> json) {
    kODE = json['KODE'];
    dESKRIPSI = json['DESKRIPSI'];
    kelas = json['kelas'];
    kETKELAS = json['KET_KELAS'];
    ngr = json['ngr'];
    statusd = json['statusd'];
    tgldoc = json['tgldoc'];
    nodoc = json['nodoc'];
    ketd = json['ketd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['KODE'] = this.kODE;
    data['DESKRIPSI'] = this.dESKRIPSI;
    data['kelas'] = this.kelas;
    data['KET_KELAS'] = this.kETKELAS;
    data['ngr'] = this.ngr;
    data['statusd'] = this.statusd;
    data['tgldoc'] = this.tgldoc;
    data['nodoc'] = this.nodoc;
    data['ketd'] = this.ketd;
    return data;
  }
}
