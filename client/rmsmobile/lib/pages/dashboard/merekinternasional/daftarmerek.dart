import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmsmobile/model/merekinternasional/dashboard.merekinternasional.dart';
import 'package:rmsmobile/pages/dashboard/merekinternasional/daftarmerek.tile.dart';
import 'package:rmsmobile/pages/dashboard/merekinternasional/network.merekinternasional.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/ReusableClasses.dart';
import '../../../utils/warna.dart';
import '../../login/login.dart';

class DaftarMerekInternasional extends StatefulWidget {
  const DaftarMerekInternasional({Key? key}) : super(key: key);

  @override
  State<DaftarMerekInternasional> createState() =>
      _DaftarMerekInternasionalState();
}

class _DaftarMerekInternasionalState extends State<DaftarMerekInternasional> {
  late SharedPreferences sp;
  var token = "";
  List<DashboardMerekInternasionalModel> _dashboardMerekInternasional =
      <DashboardMerekInternasionalModel>[];

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString('access_token')!;
    });
    await fetchDashboardMerekInternasional(token).then((value) {
      setState(() {
        _isLoading = false;
        _dashboardMerekInternasional.clear();
        _dashboardMerekInternasional.addAll(value);
      });
    }).onError((error, stackTrace) {
      ReusableClasses().clearSharedPreferences();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Loginscreen(
                    tipe: 'sesiberakhir',
                  )));
    });
  }

  Future refreshPage() async {
    _dashboardMerekInternasional.clear();
    setState(() {
      cekToken();
    });
    // await Future.delayed(Duration(seconds: 2));
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
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                refreshPage();
                // openFilterDialog(context);
              },
              icon: Icon(
                Icons.refresh_outlined,
                color: Colors.black87,
              ))
        ],
        title: Text(
          'Daftar Perpanjangan',
          style: GoogleFonts.lato(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: backgroundcolor,
      ),
      body: Container(
        color: thirdcolor,
        height: MediaQuery.of(context).size.height / 5,
        margin: EdgeInsets.only(left: 16, right: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            if (!_isLoading) {
              return index == 0
                  ? LinearProgressIndicator()
                  : StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                      return DaftarMerekTile(
                        merekInternasional:
                            this._dashboardMerekInternasional[index - 1],
                      );
                    });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          itemCount: _dashboardMerekInternasional.length + 1,
        ),
      ),
    );
  }
}
