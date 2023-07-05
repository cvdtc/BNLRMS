import 'package:flutter/material.dart';

import '../../model/merekinternasional/merekinternasional.dart';

class ComponentDetailMerekInternasional extends StatelessWidget {
  late final DataMerekInternasionalModel merekInternasional;
  ComponentDetailMerekInternasional({required this.merekInternasional});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: 22, left: 14, right: 14, bottom: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              merekInternasional.cUSNAMA.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text('Merek : ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                Text(
                  merekInternasional.dESKRIPSI.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text('Kelas : ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                Text(merekInternasional.kelas.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Keterangan Kelas: ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(merekInternasional.kETKELAS.toString())
          ],
        ),
      ),
    );
  }
}
