import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:search_engine/Constants/Colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  static final routeName = '/webViewScreen';

  const WebViewScreen({Key key, this.url}) : super(key: key);
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ConstantColors.blue,
          // actions: [
          //   BackButton(
          //     color: Colors.blue,
          //     onPressed: () => Navigator.of(context).pop(),
          //   )
          // ],
        ),
        body: WebView(
          initialUrl: widget.url,
        ));
  }
}
