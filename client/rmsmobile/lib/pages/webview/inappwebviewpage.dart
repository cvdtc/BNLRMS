import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  String data_url;
  WebviewPage({required this.data_url});

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<WebviewPage> {
  String urlweb = "";
  double progress = 0;
  String currentURL = '';
  InAppWebViewController? _appWebViewController;
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
          actions: [
            IconButton(
                onPressed: () async {
                  // print(await _appWebViewController?.toString());
                  currentURL = await _appWebViewController!.getUrl().toString();
                  print(currentURL);
                  Get.snackbar('Salin', 'URL Berhasil disalin',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: thirdcolor);
                },
                icon: Icon(
                  Icons.copy_all_rounded,
                  color: Colors.black87,
                )),
          ],
        ),
        body: Container(
            child: Column(children: <Widget>[
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
