import 'package:flutter/material.dart';
import 'package:rmsmobile/model/merekinternasional/merekinternasional.dart';
import 'package:rmsmobile/pages/merekinternasional/detailmerekinternasional.dart';

class MerekInternasionalTile extends StatelessWidget {
  late final DataMerekInternasionalModel merekInternasional;
  final String token;
  MerekInternasionalTile(
      {required this.merekInternasional, required this.token});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailListMerekInternasional(
                        merekInternasional: merekInternasional,
                        token: token,
                      )));
        },
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      // Text(merekInternasional.cUSTOMER!),
                      Text(merekInternasional.cUSNAMA!),
                    ],
                  ),
                  Column(
                    children: [
                      // Text('Kode : ' + merekInternasional.kODE.toString()),
                      Text('Kelas : ' + merekInternasional.kelas.toString()),
                    ],
                  )
                ],
              ),
              Divider(),
              SizedBox(
                height: 5,
              ),
              Text(
                "Merek : " + merekInternasional.dESKRIPSI!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(),
              Text(
                merekInternasional.kETKELAS!,
                maxLines: 4,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
