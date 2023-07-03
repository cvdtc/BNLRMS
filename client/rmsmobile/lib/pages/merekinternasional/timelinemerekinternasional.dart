import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmsmobile/model/merekinternasional/timeline.merekinternasional.dart';
import 'package:rmsmobile/pages/merekinternasional/networkmerekinternasional.dart';
import 'package:rmsmobile/pages/merekinternasional/timelinemerekinternasional.tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/warna.dart';

class TimelineMerekInternasional extends StatefulWidget {
  String kode;
  TimelineMerekInternasional({required this.kode});

  @override
  State<TimelineMerekInternasional> createState() =>
      _TimelineMerekInternasionalState();
}

class _TimelineMerekInternasionalState
    extends State<TimelineMerekInternasional> {
  late SharedPreferences sp;
  // TextEditingController _textSearch = TextEditingController(text: "");
  var token = "";
  List<DataTimelineMerekInternasionalModel> _dataList =
      <DataTimelineMerekInternasionalModel>[];
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
    await fetchTimelineMerekInternasional(widget.kode, token).then((value) {
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
                    return TimelineMerekInternasionalTile(
                      timelinemerekInternasional: this._dataList[index],
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
