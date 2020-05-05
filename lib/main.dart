import 'package:deti_motica_app/page/list_page.dart';
import 'package:deti_motica_app/page/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(DETIMotica());

class DETIMotica extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Start()
    );
  }
}

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => Login()));
        },
        child: Center(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(flex: 3),
                Image.asset("assets/images/title.png"),
                Spacer(flex: 1),
                Image.asset("assets/images/logo.png"),
                Spacer(flex: 3),
              ],
            )
          )
        )
      )
    );
  }
}
