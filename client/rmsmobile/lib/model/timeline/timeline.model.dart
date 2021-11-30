// "tipe": 1,
//             "keterangan": "coba put 212",
//             "kategori": "Paten",
//             "due_date": "2019-12-15",
//             "created": "2021-11-17 02:19:00",
//             "edited": "2021-11-25 13:35:03",
//             "flag_selesai": "0",
//             "keterangan_selesai": "",
//             "idpengguna_close_permintaan": null,
//             "prg_keterangan": "-",
//             "prg_created": "-",
//             "prg_edited": "-",
//             "prg_flag_selesai": "-"
import 'dart:convert';

class TimelineModel {
  var tipe,
      keterangan,
      kategori,
      due_date,
      created,
      edited,
      flag_selesai,
      keterangan_selesai,
      idpengguna_close_permintaan,
      prg_keterangan,
      prg_created,
      prg_edited,
      prg_flag_selesai;

  TimelineModel(
      {this.tipe,
      this.keterangan,
      this.kategori,
      this.due_date,
      this.created,
      this.edited,
      this.flag_selesai,
      this.keterangan_selesai,
      this.idpengguna_close_permintaan,
      this.prg_keterangan,
      this.prg_created,
      this.prg_edited,
      this.prg_flag_selesai});

  factory TimelineModel.fromJson(Map<String, dynamic> map) {
    return TimelineModel(
      tipe: map['tipe'],
      keterangan: map['keterangan'],
      kategori: map['kategori'],
      due_date: map['due_date'],
      created: map['created'],
      edited: map['edited'],
      flag_selesai: map['flag_selesai'],
      keterangan_selesai: map['keterangan_selesai'],
      idpengguna_close_permintaan: map['idpengguna_close_permintaan'],
      prg_keterangan: map['prg_keterangan'],
      prg_created: map['prg_created'],
      prg_edited: map['prg_edited'],
      prg_flag_selesai: map['prg_flag_selesai'],
    );
  }
  @override
  String toString() {
    return 'tipe: $tipe, keterangan: $keterangan, kategori: $kategori, due_date: $due_date, created: $created, edited: $edited, flag_selesai: $flag_selesai, keterangan_selesai: $keterangan_selesai, idpengguna_close_permintaan: $idpengguna_close_permintaan, prg_keterangan: $prg_keterangan, prg_created: $prg_created, prg_edited: $prg_edited, prg_flag_selesai: $prg_flag_selesai';
  }
}

List<TimelineModel> timelineFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<TimelineModel>.from(
      data["data"].map((item) => TimelineModel.fromJson(item)));
}
