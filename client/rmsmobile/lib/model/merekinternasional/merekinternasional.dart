class MerekInternasionalModel {
  String? message;
  Null? error;
  List<DataMerekInternasionalModel>? data;

  MerekInternasionalModel({this.message, this.error, this.data});

  MerekInternasionalModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    error = json['error'];
    if (json['data'] != null) {
      data = <DataMerekInternasionalModel>[];
      json['data'].forEach((v) {
        data!.add(new DataMerekInternasionalModel.fromJson(v));
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

class DataMerekInternasionalModel {
  String? kODE;
  String? dESKRIPSI;
  String? kelas;
  String? kETKELAS;
  String? cUSNAMA;
  String? cUSTOMER;

  DataMerekInternasionalModel(
      {this.kODE,
      this.dESKRIPSI,
      this.kelas,
      this.kETKELAS,
      this.cUSNAMA,
      this.cUSTOMER});

  DataMerekInternasionalModel.fromJson(Map<String, dynamic> json) {
    kODE = json['KODE'];
    dESKRIPSI = json['DESKRIPSI'];
    kelas = json['kelas'];
    kETKELAS = json['KET_KELAS'];
    cUSNAMA = json['CUS_NAMA'];
    cUSTOMER = json['CUSTOMER'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['KODE'] = this.kODE;
    data['DESKRIPSI'] = this.dESKRIPSI;
    data['kelas'] = this.kelas;
    data['KET_KELAS'] = this.kETKELAS;
    data['CUS_NAMA'] = this.cUSNAMA;
    data['CUSTOMER'] = this.cUSTOMER;
    return data;
  }
}
