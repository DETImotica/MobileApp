import 'package:deti_motica_app/page/list_page.dart';
import 'package:deti_motica_app/page/login.dart';
import 'package:deti_motica_app/push_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> onBackgroundMessageHandler(Map<String, dynamic> message) async {
  print(message);
}

void main() => runApp(DETIMotica());

class DETIMotica extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Start(),
        '/login': (context) => Login(),
        '/rooms': (context) => RoomListPage(),
        '/err/401': (context) => Err401()
      },
    );
  }
}

class Start extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StartState();
}

class _StartState extends State<Start> {

  @override
  void initState() {
    super.initState();

    pnm.init();
  }

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
              Image.asset("assets/images/logo.png", scale: 0.75),
              RaisedButton(
                onPressed: () => Navigator.pushNamed(context,"/login"),
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

class Err401 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Error 401"),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Image.asset("assets/images/err401.png",scale: 0.5),
            Text(
              "Infelizmente não tem permissões para aceder a esta informação",
              style: TextStyle(fontSize: 32),
              textAlign: TextAlign.center,
            )
          ],
        )
      )
    );
  }
}
