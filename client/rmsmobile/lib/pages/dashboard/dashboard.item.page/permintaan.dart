import 'package:flutter/material.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/request/request.model.dart';
import 'package:rmsmobile/pages/request/request.network.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../request/request.bottom.dart';

class PermintaanList extends StatefulWidget {
  // * buat filter listview jika tipe list 1 maka data yang keluar sudah selesai, jika 0 data yang keluar yang belum selesai
  int tipelist;
  PermintaanList({required this.tipelist});

  @override
  _PermintaanListState createState() => _PermintaanListState();
}

class _PermintaanListState extends State<PermintaanList> {
  late SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  String? token = "";
  int tipelist = 0;

  // * ceking token and getting dashboard value from api
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
  }

  @override
  initState() {
    super.initState();
    tipelist = widget.tipelist;
    cekToken();
  }

  @override
  void dispose() {
    super.dispose();
    _apiService.client.close();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _apiService.getListRequest(token.toString()),
      builder: (context, AsyncSnapshot<List<RequestModel>?> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // CircularProgressIndicator(),
                SizedBox(
                  height: 15,
                ),
                Text(
                    'SORRY, terjadi masalah ${snapshot.error}. buka halaman ini kembali.')
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          // List<RequestModel>? dataRequest = snapshot.data!
          //     .where((element) => element.flag_selesai == tipelist)
          //     .toList();
          List<RequestModel>? dataRequest = snapshot.data!.toList();
          if (dataRequest.isNotEmpty) {
            // (tipelist == 2 || tipelist == 1)
            //     ? dataRequest.sort((b, a) => a.due_date.compareTo(b.due_date))
            //     : dataRequest;
            // if (tipelist == 2) {
            //   dataRequest.sort((b, a) => a.due_date.compareTo(b.due_date));
            // } else if (tipelist == 1) {
            //   dataRequest
            //       .sort((b, a) => a.date_selesai.compareTo(b.date_selesai));
            // } else {
            //   dataRequest;
            // }

            return _listRequestAll(dataRequest);
          } else {
            return Container(
              child: Text('Data Permintaan masih kosong'),
            );
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // CircularProgressIndicator(),
                SizedBox(
                  height: 15,
                ),
                Text(
                    'SORRY 2, terjadi masalah ${snapshot.error}. buka halaman ini kembali.')
              ],
            ),
          );
        }
      },
    );
  }

  // ++ DESIGN LIST COMPONENT
  Widget _listRequest(List<RequestModel>? dataIndex1, int tipelist) {
    List<RequestModel>? dataIndex;
    if (tipelist == 2) {
      print("masuk 2");
      dataIndex = dataIndex1!
          .where((element) => element.flag_selesai == tipelist)
          .toList();
      dataIndex.sort((b, a) => a.due_date.compareTo(b.due_date));
    } else if (tipelist == 1) {
      print("masuk 1");
      dataIndex = dataIndex1!
          .where((element) => element.flag_selesai == tipelist)
          .toList();
      dataIndex.sort((b, a) => a.date_selesai.compareTo(b.date_selesai));
    } else {
      print("masuk 0");
      dataIndex = dataIndex1;
    }
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      margin: EdgeInsets.only(left: 16, right: 16),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: dataIndex!.length,
          itemBuilder: (context, index) {
            RequestModel? dataRequest = dataIndex![index];
            return InkWell(
              onTap: () {
                print('xxxx' +
                    dataRequest.keterangan +
                    ' - ' +
                    dataRequest.due_date.toString() +
                    ' - ' +
                    dataRequest.kategori +
                    ' - ' +
                    // dataRequest.idpermintaan.toString() +
                    // ' - ' +
                    '' +
                    ' - ' +
                    dataRequest.flag_selesai.toString() +
                    ' - ' +
                    dataRequest.nama_request +
                    ' - ' +
                    dataRequest.url_permintaan +
                    ' - ' +
                    dataRequest.jmlprogress.toString());
                RequestModalBottom().modalActionItem(
                    context,
                    token,
                    dataRequest.keterangan,
                    dataRequest.due_date.toString(),
                    dataRequest.kategori,
                    dataRequest.idpermintaan.toString(),
                    dataRequest.keterangan_selesai.toString(),
                    dataRequest.flag_selesai,
                    dataRequest.nama_request,
                    dataRequest.url_permintaan,
                    0);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => TimelinePage(
                //               idpermintaan: dataRequest.idpermintaan.toString(),
                //             )));
              },
              child: Card(
                elevation: 5,
                shadowColor: darkgreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: dataRequest.flag_selesai == 1
                                    ? Container(
                                        color: Colors.green,
                                        height: 30.0,
                                        width: 30.0,
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ))
                                    : (dataRequest.flag_selesai == 0
                                        ? Container(
                                            color: Colors.orange,
                                            height: 30.0,
                                            width: 30.0,
                                            child: Icon(
                                              Icons.priority_high_rounded,
                                              color: Colors.white,
                                            ))
                                        : Container(
                                            color: Colors.black,
                                            height: 30.0,
                                            width: 30.0,
                                            child: Icon(
                                              Icons.close_rounded,
                                              color: Colors.white,
                                            ))),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(dataRequest.kategori.toString(),
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: darkgreen)),
                            ],
                          ),
                          Text("TR: " + dataRequest.created.toString(),
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: darkgreen)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(dataRequest.keterangan.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("JT: " + dataRequest.due_date.toString(),
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45)),
                          Text(dataRequest.nama_request.toString(),
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _listRequestAll(List<RequestModel>? dataRequest) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Tidak Selesai',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          _listRequest(dataRequest, 2), //tipelist 2

          Card(
            color: Colors.orange,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Belum Selesai',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          _listRequest(dataRequest, 0), //tipelist 0

          Card(
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Sudah Selesai',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          _listRequest(dataRequest, 1), //tipelist 2
        ],
      ),
    );
  }
}
