import 'package:flutter/material.dart';
import 'package:rmsmobile/pages/webview/webviewpage.dart';
import 'package:rmsmobile/utils/warna.dart';

class TimelineBottomModal {
  void actionTimeline(context, String urlweb) {
    print("URL?" + urlweb);
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  urlweb != ""
                      ? 'anda mau melihat url yang tersemat?'.toUpperCase()
                      : 'Tidak ada url tersemat.'.toUpperCase(),
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                urlweb != ""
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebviewPage(
                                        data_url: urlweb,
                                      )));
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0.0, primary: backgroundcolor),
                        child: Ink(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18.0)),
                            child: Container(
                              width: 325,
                              height: 45,
                              alignment: Alignment.center,
                              child: Text('B U K A    U R L',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                            )))
                    : Container(),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          );
        });
  }
}
