import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rmsmobile/utils/warna.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPageNotUsed extends StatefulWidget {
  String data_url;
  WebviewPageNotUsed({required this.data_url});

  @override
  _WebviewPageNotUsedState createState() => _WebviewPageNotUsedState();
}

class _WebviewPageNotUsedState extends State<WebviewPageNotUsed> {
  var urlweb;
  final Completer<WebViewController> _webviewController =
      Completer<WebViewController>();

  @override
  void initState() {
    // TODO: implement initState

    urlweb = widget.data_url;
    final _key = UniqueKey();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(urlweb),
          centerTitle: true,
          backgroundColor: backgroundcolor,
        ),
        body: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: urlweb,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _webviewController.complete(webViewController);
            },
            onProgress: (int progress) {
              print("WebView is loading (progress : $progress%)");
            },
            javascriptChannels: <JavascriptChannel>{
              _toasterJavascriptChannel(context),
            },
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                print('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
            gestureNavigationEnabled: true,
          );
        }));
  }
}

JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
  return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        // ignore: deprecated_member_use
        // Scaffold.of(context).showSnackBar(
        //   SnackBar(content: Text(message.message)),
        // );
      });
}
