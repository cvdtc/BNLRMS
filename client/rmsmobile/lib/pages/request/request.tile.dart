import 'package:flutter/material.dart';
import 'package:rmsmobile/model/request/request.model.dart';

import 'request.bottom.dart';

class RequestTile extends StatelessWidget {
  late final RequestModel request;
  final String token;
  RequestTile({required this.request, required this.token});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
            elevation: 0.0,
            child: InkWell(
              onTap: () {
                ReusableClass().modalActionItem(
                    context,
                    token,
                    request.keterangan,
                    request.due_date,
                    request.kategori,
                    request.idpermintaan.toString());
              },
              child: Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Nama Req : ', style: TextStyle(fontSize: 18.0)),
                        Text(request.nama_request,
                            style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text('Kategori : ' + request.kategori,
                            style: TextStyle(fontSize: 18.0)),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Keterangan : ' + request.keterangan,
                        style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              ),
            )));
  }
}
