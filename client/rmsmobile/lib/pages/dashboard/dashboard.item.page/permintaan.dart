import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/request/request.model.dart';
import 'package:rmsmobile/pages/login/login.dart';
import 'package:rmsmobile/pages/timeline/timeline.dart';
import 'package:rmsmobile/utils/ReusableClasses.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermintaanList extends StatefulWidget {
  const PermintaanList({Key? key}) : super(key: key);

  @override
  _PermintaanListState createState() => _PermintaanListState();
}

class _PermintaanListState extends State<PermintaanList> {
  late SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  String? token = "";

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
                CircularProgressIndicator(),
                SizedBox(
                  height: 15,
                ),
                Text(
                    'maaf, terjadi masalah ${snapshot.error}. buka halaman ini kembali.')
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          List<RequestModel>? dataRequest = snapshot.data;
          if (dataRequest!.isNotEmpty) {
            print('masuk sini?');
            return _listRequest(dataRequest);
          } else {
            print('masuk sini');
            print('data request $dataRequest + ${snapshot.data}');
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
                CircularProgressIndicator(),
                SizedBox(
                  height: 15,
                ),
                Text(
                    'maaf, terjadi masalah ${snapshot.error}. buka halaman ini kembali.')
              ],
            ),
          );
        }
      },
    );
  }

  // ++ DESIGN LIST COMPONENT
  Widget _listRequest(List<RequestModel>? dataIndex) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      margin: EdgeInsets.only(left: 16, right: 16),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: dataIndex!.length,
          itemBuilder: (context, index) {
            RequestModel? dataRequest = dataIndex[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TimelinePage(
                              idpermintaan: dataRequest.idpermintaan.toString(),
                            )));
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: EdgeInsets.all(8),
                height: 70,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: mFillColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: mBorderColor, width: 1),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        child: Column(
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
                                      : Container(
                                          color: Colors.orange,
                                          height: 30.0,
                                          width: 30.0,
                                          child: Icon(
                                            Icons.priority_high_rounded,
                                            color: Colors.white,
                                          )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(dataRequest.kategori.toString(),
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                                height: MediaQuery.of(context).size.height / 10,
                                child: Text(
                                    dataRequest.keterangan
                                        .toString()
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))),
                            SizedBox(
                              height: 10,
                            ),
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
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
