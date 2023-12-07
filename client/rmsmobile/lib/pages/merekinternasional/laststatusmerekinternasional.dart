import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rmsmobile/model/merekinternasional/laststatus.merekinternasional.dart';
import 'package:rmsmobile/pages/merekinternasional/laststatusmerekinternasional.tile.dart';
import 'package:rmsmobile/pages/merekinternasional/networkmerekinternasional.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/warna.dart';

class LastStatusMerekInternasional extends StatefulWidget {
  String kode;
  LastStatusMerekInternasional({required this.kode});

  @override
  State<LastStatusMerekInternasional> createState() =>
      _LastStatusMerekInternasionalState();
}

class _LastStatusMerekInternasionalState
    extends State<LastStatusMerekInternasional> {
  late SharedPreferences sp;
  // TextEditingController _textSearch = TextEditingController(text: "");
  var token = "";
  List<DataLastStatusMerekInternasionalModel> _dataList =
      <DataLastStatusMerekInternasionalModel>[];
  // List<DataTimelineMerekInternasionalModel> _dataListDisplay =
  //     <DataTimelineMerekInternasionalModel>[];

  DateTime? tanggal_awal;
  DateTime? tanggal_akhir;

  /// for set value listview to this variable
  var valuelistview;

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString('access_token')!;
    });
    await fetchLastStatusMerekInternasional(widget.kode, token).then((value) {
      setState(() {
        _isLoading = false;
        _dataList.clear();
        valuelistview = value;
        _dataList.addAll(valuelistview);
        // _dataListDisplay = _dataList;
      });
    }).onError((error, stackTrace) {
      print(error.toString() + ' -- ' + stackTrace.toString());
    });
  }

  Future refreshPage() async {
    // _dataListDisplay.clear();
    setState(() {
      cekToken();
    });
    Fluttertoast.showToast(
        msg: "Data Berhasil diperbarui",
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  @override
  initState() {
    cekToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshPage,
        child: SafeArea(
          child: Container(
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (!_isLoading) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return LastStatusMerekInternasionalTile(
                      laststatusmerekInternasional: this._dataList[index],
                    );
                  });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
              itemCount: _dataList.length,
            ),
          ),
        ),
      ),
    );
  }
}
