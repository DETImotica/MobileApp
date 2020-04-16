import 'package:flutter/material.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import 'dart:convert';
import 'package:deti_motica_app/api.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DETIMotica"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FlatButton(
            child: Text(
              "Login",
              style: TextStyle(fontSize: 28),
            ),
            onPressed: _login(),
          )
        ],
      )
    );
  }
}

_login() {
  HttpClient client = new HttpClient()
    ..badCertificateCallback = (certificateCheck);

  String post = url + "api/v1/login";

  makeRequest() async {
    var request = await client.getUrl(Uri.parse(post));
    var response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode >= 200 && response.statusCode <= 400) {
      print(responseBody);
    }
    else
      print("Communications Error: ${response.statusCode}");

    client.close();
  }
  makeRequest();
}