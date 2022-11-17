import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebviewPage extends StatefulWidget {
  String data_url;
  WebviewPage({required this.data_url});

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<WebviewPage> {
  String urlweb = "";
  double progress = 0;

  @override
  void initState() {
    // TODO: implement initState

    urlweb = widget.data_url;
    final _key = UniqueKey();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(urlweb),
          backgroundColor: backgroundcolor,
        ),
        body: Container(
            child: Column(children: <Widget>[
          // Container(
          //   padding: EdgeInsets.all(20.0),
          //   child: Text(
          //       "CURRENT URL\n${(urlweb.length > 50) ? urlweb.substring(0, 50) + "..." : urlweb}"),
          // ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: progress < 1.0
                ? LinearProgressIndicator(
                    value: progress,
                    color: primarycolor,
                  )
                : Text(
                    urlweb,
                    style: TextStyle(fontSize: 8.0),
                  ),
          ),

          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              decoration:
                  BoxDecoration(border: Border.all(color: primarycolor)),
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(urlweb)),
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions()),
                onWebViewCreated: (InAppWebViewController controller) {},
                onReceivedServerTrustAuthRequest:
                    (controller, challenge) async {
                  return ServerTrustAuthResponse(
                      action: ServerTrustAuthResponseAction.PROCEED);
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
              ),
            ),
          ),
        ])),
      ),
    );
  }
}
