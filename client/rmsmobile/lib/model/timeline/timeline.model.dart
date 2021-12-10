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
      prg_flag_selesai,
      nama_request,
      nama_progress,
      nama_close_permintaan,
      date_selesai;

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
      this.prg_flag_selesai,
      this.nama_request,
      this.nama_progress,
      this.nama_close_permintaan,
      this.date_selesai});

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
        nama_request: map['nama_request'],
        nama_progress: map['nama_progress'],
        nama_close_permintaan: map['nama_close_permintaan'],
        date_selesai: map['date_selesai']);
  }
  @override
  String toString() {
    return 'tipe: $tipe, keterangan: $keterangan, kategori: $kategori, due_date: $due_date, created: $created, edited: $edited, flag_selesai: $flag_selesai, keterangan_selesai: $keterangan_selesai, idpengguna_close_permintaan: $idpengguna_close_permintaan, prg_keterangan: $prg_keterangan, prg_created: $prg_created, prg_edited: $prg_edited, prg_flag_selesai: $prg_flag_selesai, nama_request: $nama_request, nama_progress: $nama_progress, nama_close_permintaan: $nama_close_permintaan';
  }
}

List<TimelineModel> timelineFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<TimelineModel>.from(
      data["data"].map((item) => TimelineModel.fromJson(item)));
}
