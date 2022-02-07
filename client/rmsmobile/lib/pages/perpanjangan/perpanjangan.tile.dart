import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rmsmobile/model/perpanjangan/perpanjangan.model.dart';

class PerpanjanganTile extends StatefulWidget {
  late final PerpanjanganModel perpanjangan;
  final String token;
  PerpanjanganTile({required this.perpanjangan, required this.token});

  @override
  State<PerpanjanganTile> createState() => _PerpanjanganTileState();
}

class _PerpanjanganTileState extends State<PerpanjanganTile> {
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
          child: Card(
            elevation: 0.0,
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
                      Text("TS: " + widget.perpanjangan.tglsertifikat,
                          style: TextStyle(fontSize: 14.0)),
                      Text("TP: " + widget.perpanjangan.tglperpanjangan,
                          style: TextStyle(fontSize: 14.0)),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Produk : " + widget.perpanjangan.produk,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,)),
                  SizedBox(
                    height: 5,
                  ),
                  Text(widget.perpanjangan.nama,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black45
                        // fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Kelas : " + widget.perpanjangan.kelas,
                          style:
                              TextStyle(fontSize: 14.0, color: Colors.black38)),
                      Text("Sales : " + widget.perpanjangan.sales,
                          style:
                              TextStyle(fontSize: 14.0, color: Colors.black38)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
