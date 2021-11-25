import 'package:flutter/material.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/progress/progress.model.dart';
import 'package:rmsmobile/model/request/request.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgresList extends StatefulWidget {
  const ProgresList({ Key? key }) : super(key: key);

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
    // TODO: implement initState
    super.initState();
    cekToken();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _apiService.client.close();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _apiService.getListProgres(token.toString()), 
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
              if (snapshot.hasData) {
                List<ProgressModel>? dataRequest = snapshot.data;
                return _listRequest(dataRequest);
              } else {
                return Center(
                  child: Text('Data Masih kosong nih!'),
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
      // width: MediaQuery.of(context).size.height /4,
      height: MediaQuery.of(context).size.height /4,
      margin: EdgeInsets.only(left: 16, right: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          itemCount: dataIndex!.length,
          itemBuilder: (context, index) {
            ProgressModel? dataRequest = dataIndex[index];
            return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                    elevation: 0.0,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Kategori : ',
                                  style: TextStyle(fontSize: 18.0)),
                              Text(
                                  dataRequest.kategori,
                                  style: TextStyle(fontSize: 18.0))
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text('Permintaan : ', style: TextStyle(fontSize: 18.0)),
                              Text(
                                  dataRequest.permintaan,
                                  style: TextStyle(fontSize: 18.0))
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Keterangan : '+dataRequest.keterangan, style: TextStyle(fontSize: 18.0)),
                        ],
                      ),
                    )));
          }),
    );
  }
}