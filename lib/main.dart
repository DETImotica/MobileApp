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
      body: Center(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset("assets/images/title.png", scale: 0.5),
              Image.asset("assets/images/logo.png", scale: 0.5),
              RaisedButton(
                onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => Login())),
                child: Text(
                  "ENTRAR",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                  ),
                ),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)
                ),
              ),
              Text(
                "Powered by DETI UA",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              )
            ],
          )
        )
      )
    );
  }
}
