import 'package:flutter/material.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/progress/progress.model.dart';
import 'package:rmsmobile/pages/login/login.dart';
import 'package:rmsmobile/pages/request/request.bottom.dart';
import 'package:rmsmobile/pages/timeline/timeline.dart';
import 'package:rmsmobile/utils/ReusableClasses.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgresList extends StatefulWidget {
  const ProgresList({Key? key}) : super(key: key);

  @override
  _ProgresListState createState() => _ProgresListState();
}

class _ProgresListState extends State<ProgresList> {
  late SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  String? token = "", username = "", jabatan = "", nama = "";

  // * ceking token and getting dashboard value from api
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
      // username = sp.getString("username");
      nama = sp.getString('nama');
      jabatan = sp.getString("jabatan");
    });
    // });
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
      future: _apiService
          .getListProgres(token.toString())
          .onError((error, stackTrace) {
        ReusableClasses().clearSharedPreferences();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Loginscreen(
                      tipe: 'sesiberakhir',
                    )));
      }),
      builder: (context, AsyncSnapshot<List<ProgressModel>?> snapshot) {
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
          List<ProgressModel>? dataRequest = snapshot.data;
          print('snapshote ${snapshot.data} $dataRequest');
          if (dataRequest!.isNotEmpty) {
            print('masuk sini?');
            return _listRequest(dataRequest);
          } else {
            print('masuk sini');
            print('data request $dataRequest + ${snapshot.data}');
            return Container(
              child: Text('Data progres masih kosong'),
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
  Widget _listRequest(List<ProgressModel>? dataIndex) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      margin: EdgeInsets.only(left: 16, right: 16),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: dataIndex!.length,
          itemBuilder: (context, index) {
            ProgressModel? dataprogress = dataIndex[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TimelinePage(
                              idpermintaan:
                                  dataprogress.idpermintaan.toString(),
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
                                  child: dataprogress.flag_selesai == 1
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
                                  child: Text(dataprogress.kategori.toString(),
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
                                child: Text(dataprogress.keterangan.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Update: " +
                                        dataprogress.created.toString(),
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45)),
                              ],
                            )
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
