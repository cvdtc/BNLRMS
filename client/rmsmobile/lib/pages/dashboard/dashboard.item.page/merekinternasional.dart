import 'package:flutter/material.dart';
import 'package:rmsmobile/model/merekinternasional/dashboard.merekinternasional.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiService/apiService.dart';
import '../../../utils/ReusableClasses.dart';
import '../../../utils/warna.dart';
import '../../login/login.dart';

class DashboardMerekInternasional extends StatefulWidget {
  const DashboardMerekInternasional({Key? key}) : super(key: key);

  @override
  State<DashboardMerekInternasional> createState() =>
      _DashboardMerekInternasionalState();
}

class _DashboardMerekInternasionalState
    extends State<DashboardMerekInternasional> {
  late SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  String? token = "", username = "", jabatan = "", nama = "";

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
      future: _apiService
          .getListDashboardMerekInternasional(token.toString())
          .onError((error, stackTrace) {
        ReusableClasses().clearSharedPreferences();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Loginscreen(
                      tipe: 'sesiberakhir',
                    )));
      }),
      builder: (context,
          AsyncSnapshot<List<DataDashboardMerekInternasionalModel>?> snapshot) {
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
          List<DataDashboardMerekInternasionalModel>? dataPerpanjangan =
              snapshot.data;
          print(dataPerpanjangan);
          if (dataPerpanjangan!.isNotEmpty) {
            return _listPerpanjangan(dataPerpanjangan);
          } else {
            return Container(
              child: Text('Data Perpanjangan masih kosong'),
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
  Widget _listPerpanjangan(
      List<DataDashboardMerekInternasionalModel>? dataIndex) {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      margin: EdgeInsets.only(left: 16, right: 16),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: dataIndex!.length,
          itemBuilder: (context, index) {
            DataDashboardMerekInternasionalModel? dataperpanjangan =
                dataIndex[index];
            return InkWell(
              child: Card(
                elevation: 5,
                shadowColor: darkgreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(dataperpanjangan.cUSNAMA.toString(),
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: darkgreen)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(dataperpanjangan.dESKRIPSI.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "Kelas: " + dataperpanjangan.kelas.toString(),
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
