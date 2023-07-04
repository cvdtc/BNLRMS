import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rmsmobile/model/merekinternasional/timeline.merekinternasional.dart';

class TimelineMerekInternasionalTile extends StatelessWidget {
  late final DataTimelineMerekInternasionalModel timelinemerekInternasional;
  TimelineMerekInternasionalTile({required this.timelinemerekInternasional});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(
            child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(timelinemerekInternasional.statusd.toString()),
                          Text(timelinemerekInternasional.tgldoc.toString()),
                        ],
                      ),
                      Divider(),
                      Text('No. Doc : ' +
                          timelinemerekInternasional.nodoc.toString()),
                      Text('Negara : ' +
                          timelinemerekInternasional.ngr.toString()),
                      Text('Keterangan : ' +
                          timelinemerekInternasional.ketd.toString()),
                    ],
                  ),
                ]))));
  }
}
