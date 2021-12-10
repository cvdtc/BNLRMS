import 'package:flutter/material.dart';
import 'package:rmsmobile/model/request/request.model.dart';

import 'request.bottom.dart';

class RequestTile extends StatefulWidget {
  late final RequestModel request;
  final String token;
  RequestTile({required this.request, required this.token});

  @override
  State<RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
                elevation: 0.0,
                child: Container(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        ReusableClass().modalActionItem(
                            context,
                            widget.token,
                            widget.request.keterangan,
                            widget.request.due_date,
                            widget.request.kategori,
                            widget.request.idpermintaan.toString(),
                            widget.request.keterangan_selesai,
                            widget.request.tipeupdate,
                            widget.request.flag_selesai,);
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.request.kategori,
                                  style: TextStyle(fontSize: 12.0)),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 30,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 8.0,
                                      width: 5.0,
                                      child: CustomPaint(
                                        painter: TrianglePainter(),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: widget.request.flag_selesai == 1
                                              ? Colors.green
                                              : Colors.red,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(6.0),
                                              bottomLeft:
                                                  Radius.circular(6.0))),
                                      width: 120.0,
                                      height: 30.0,
                                      child: Center(
                                        child: Text(
                                          widget.request.flag_selesai == 1
                                              ? 'Selesai'
                                              : 'Belum Selesai',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(widget.request.keterangan.toString(),
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,)),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Tenggat : "+widget.request.due_date,
                                  style: TextStyle(fontSize: 14.0, color: Colors.black38)),
                              Text(widget.request.nama_request,
                                  style: TextStyle(fontSize: 14.0, color: Colors.black38)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )));
      },
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0;
    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
