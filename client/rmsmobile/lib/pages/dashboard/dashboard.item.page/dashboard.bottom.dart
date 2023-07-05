import 'package:flutter/material.dart';
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/request/request.model.dart';

class DashboardModalBottom {
  ApiService _apiService = ApiService();

  void showListPermintaan(context, token, int tipePermintaan) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        builder: (context) {
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
                List<RequestModel>? dataRequest = snapshot.data!
                    .where((element) => element.flag_selesai == tipePermintaan)
                    .toList();
                if (dataRequest.isNotEmpty) {
                  return _designListview(dataRequest, tipePermintaan);
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
        });
  }

  Widget _designListview(List<RequestModel>? dataIndex, int tipepermintaan) {
    return Container(
      child: ListView.builder(
          itemCount: dataIndex!.length,
          itemBuilder: (context, index) {
            RequestModel? dataRequest = dataIndex[index];
            return InkWell(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: Colors.white,
                elevation: 3.0,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(dataRequest.keterangan.toString())],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
