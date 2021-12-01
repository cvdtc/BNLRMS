import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:rmsmobile/model/request/request.model.dart';
import 'package:rmsmobile/utils/selectListController.dart';
// import 'package:rmsmobile/utils/warna.dart';

import 'request.bottom.dart';

class RequestTile extends StatelessWidget {
  late final RequestModel request;
  final String token;
  RequestTile({required this.request, required this.token});

  // var controllers = Get.put(SelectedListController());

  // void openFilterDialog(context) async{
  //   await FilterListDialog.display<String>(
  //     context, 
  //     listData: request.kategori,
  //     selectedListData: controllers.getSelectedList(), 
  //     headlineText: 'Pilih Kategori',
  //     closeIconColor: Colors.grey,
  //     applyButtonTextStyle: TextStyle(fontSize: 20),
  //     choiceChipLabel: (item)=> item,
  //     validateSelectedItem: (list, val)=>list!.contains(val),
  //     onItemSearch: (list, text){
  //       if (list!.any((element) => element.toLowerCase().contains(text.toLowerCase()))) {
  //         return list.where((element) => element.toLowerCase().contains(text.toLowerCase())).toList();
  //       } else {
  //         return [];
  //       }
  //     },
  //     onApplyButtonClick: (list){
  //       controllers.setSelectedList(List<String>.from(list!));
  //     });
  // }

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
                            token,
                            request.keterangan,
                            request.due_date,
                            request.kategori,
                            request.idpermintaan.toString(),
                            request.tipeupdate,
                            request.flag_selesai);
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
                            children: [
                              Text('Nama Req : ',
                                  style: TextStyle(fontSize: 12.0)),
                              Text(request.nama_request,
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
                                          color: request.flag_selesai == 1
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
                                          request.flag_selesai == 1
                                              ? 'Selesai'
                                              : 'Progres',
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
                          Row(
                            children: [
                              Text('Kategori : ' + request.kategori,
                                  style: TextStyle(fontSize: 12.0))
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Keterangan : ' + request.keterangan,
                              style: TextStyle(fontSize: 12.0)),
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
