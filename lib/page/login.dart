import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:deti_motica_app/api.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DETIMotica"),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: url+"api/v1/logout",
        onWebViewCreated: (WebViewController webViewController) {
          _controller=webViewController;
        },
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (String str) {
          _test();
        },

      )
    );
  }

  _test() async {
    var cookie=_controller.evaluateJavascript('document.cookie');
    cookie.then((String str) {print("$str");});
  }
}