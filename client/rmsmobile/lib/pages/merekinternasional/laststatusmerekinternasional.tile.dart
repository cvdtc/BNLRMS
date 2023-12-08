import 'package:flutter/material.dart';
import 'package:rmsmobile/model/merekinternasional/laststatus.merekinternasional.dart';

class LastStatusMerekInternasionalTile extends StatelessWidget {
  late final DataLastStatusMerekInternasionalModel laststatusmerekInternasional;
  LastStatusMerekInternasionalTile(
      {required this.laststatusmerekInternasional});

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
                      Text(
                        laststatusmerekInternasional.ngr.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(laststatusmerekInternasional.statusd.toString()),
                          Text(laststatusmerekInternasional.tgldoc.toString()),
                        ],
                      ),
                      Divider(),
                      Text('No. Doc : ' +
                          laststatusmerekInternasional.nodoc.toString()),
                      Text('Keterangan : ' +
                          laststatusmerekInternasional.ketd.toString()),
                    ],
                  ),
                ]))));
  }
}
