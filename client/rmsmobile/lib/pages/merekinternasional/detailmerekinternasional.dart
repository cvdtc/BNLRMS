import 'package:flutter/material.dart';
import 'package:rmsmobile/model/merekinternasional/merekinternasional.dart';
import 'package:rmsmobile/pages/merekinternasional/detailmerekinternasional.component.dart';
import 'package:rmsmobile/pages/merekinternasional/timelinemerekinternasional.dart';
import 'package:rmsmobile/utils/warna.dart';

class DetailListMerekInternasional extends StatefulWidget {
  late final DataMerekInternasionalModel merekInternasional;
  final String token;
  DetailListMerekInternasional(
      {required this.merekInternasional, required this.token});

  @override
  State<DetailListMerekInternasional> createState() =>
      _DetailListMerekInternasionalState();
}

class _DetailListMerekInternasionalState
    extends State<DetailListMerekInternasional> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundcolor,
          foregroundColor: darkgreen,
          bottom: TabBar(
              indicatorColor: darkgreen,
              labelColor: darkgreen,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.auto_fix_normal_rounded,
                    color: darkgreen,
                  ),
                  text: 'Details',
                ),
                Tab(
                  icon: Icon(
                    Icons.history_edu_rounded,
                    color: darkgreen,
                  ),
                  text: 'History',
                )
              ]),
          title: Text(
            'Detail',
            style: TextStyle(color: darkgreen),
          ),
          centerTitle: true,
        ),
        body: TabBarView(children: [
          ComponentDetailMerekInternasional(
              merekInternasional: widget.merekInternasional),
          TimelineMerekInternasional(
            kode: widget.merekInternasional.kODE.toString(),
          )
        ]),
      ),
    );
  }
}
