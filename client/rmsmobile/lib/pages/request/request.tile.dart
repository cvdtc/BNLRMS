import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rmsmobile/model/request/request.model.dart';
import 'request.bottom.dart';

class RequestTile extends StatefulWidget {
  late final RequestModel request;
  final String token, idpengguna;
  RequestTile(
      {required this.request, required this.token, required this.idpengguna});

  @override
  State<RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  var tanggalhariini = '';
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tanggalhariini = formatted;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return InkWell(
          onTap: () {
            // setState(() {
            RequestModalBottom().modalActionItem(
                context,
                widget.token,
                widget.request.keterangan,
                widget.request.due_date,
                widget.request.kategori,
                widget.request.idpermintaan.toString(),
                widget.request.keterangan_selesai != null
                    ? widget.request.keterangan_selesai
                    : '-',
                widget.request.flag_selesai,
                widget.request.nama_request,
                widget.request.url_permintaan,
                widget.request.jmlprogress,
                widget.idpengguna,
                widget.request.idpengguna.toString());
            // });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 8, left: 4, right: 4),
            child: Card(
              elevation: 5,
              child: Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.request.kategori,
                            style: TextStyle(fontSize: 16.0)),
                        Container(
                          decoration: BoxDecoration(
                              color: widget.request.flag_selesai == 1
                                  ? Colors.green
                                  : (widget.request.flag_selesai == 0
                                      ? Colors.orange
                                      : Colors.black),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6.0),
                                  bottomLeft: Radius.circular(6.0))),
                          width: 120.0,
                          height: 30.0,
                          child: Center(
                            child: Text(
                              widget.request.flag_selesai == 1
                                  ? 'Selesai'
                                  : (widget.request.flag_selesai == 0
                                      ? 'Belum Selesai'
                                      : 'Tidak Selesai'),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(widget.request.keterangan.toString(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("TR : " + widget.request.created,
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.black38)),
                            Text("JT : " + widget.request.due_date,
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.black38)),
                            Text(widget.request.nama_request,
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.black38)),
                          ],
                        ),
                        Container(
                            color: Colors.blue,
                            padding: EdgeInsets.all(4),
                            child: Text(
                              widget.request.jmlprogress.toString() +
                                  " Progress",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
