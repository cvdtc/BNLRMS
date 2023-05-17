import 'package:flutter/material.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/perpanjangan/perpanjangan.model.dart';
import 'package:rmsmobile/pages/login/login.dart';
import 'package:rmsmobile/utils/ReusableClasses.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerpanjanganList extends StatefulWidget {
  const PerpanjanganList({Key? key}) : super(key: key);

  @override
  _PerpanjanganListState createState() => _PerpanjanganListState();
}

class _PerpanjanganListState extends State<PerpanjanganList> {
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
          .getListPerpanjangan(token.toString())
          .onError((error, stackTrace) {
        ReusableClasses().clearSharedPreferences();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Loginscreen(
                      tipe: 'sesiberakhir',
                    )));
      }),
      builder: (context, AsyncSnapshot<List<PerpanjanganModel>?> snapshot) {
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
          List<PerpanjanganModel>? dataPerpanjangan = snapshot.data;
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
  Widget _listPerpanjangan(List<PerpanjanganModel>? dataIndex) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      margin: EdgeInsets.only(left: 16, right: 16),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: dataIndex!.length,
          itemBuilder: (context, index) {
            PerpanjanganModel? dataperpanjangan = dataIndex[index];
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
                              Text("FD: " + dataperpanjangan.tglperpanjangan,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: darkgreen)),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 20,
                                child: Text(dataperpanjangan.produk.toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                              ),
                              Text(dataperpanjangan.nama.toString(),
                                  style: TextStyle(
                                      fontSize: 13.0, color: darkgreen)),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      "Kelas: " +
                                          dataperpanjangan.kelas.toString(),
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red)),
                                  Text(
                                      "Sales: " +
                                          dataperpanjangan.sales.toString(),
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red))
                                ],
                              ),
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
