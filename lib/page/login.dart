import 'package:deti_motica_app/page/list_page.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:deti_motica_app/api.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DETIMotica"),
        centerTitle: true,
      ),
      body: WebView(
        userAgent: userAgent,
        initialUrl: url+"api/v1/login",
        onWebViewCreated: (WebViewController webViewController) {
          _controller=webViewController;
        },
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (String str) {
          _finishedCheck();
        },

      )
    );
  }

  _finishedCheck() async {
    var currUrl=await _controller.currentUrl();
    if (currUrl.contains(apiHost)) {
      _controller.evaluateJavascript("document.cookie").then((value) {
        var cookie=value.split('=');
        if (cookie.length>1){
          setSession(cookie[1].replaceAll('"',''));

          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => RoomListPage()));
        }
      });
    }

  }
}