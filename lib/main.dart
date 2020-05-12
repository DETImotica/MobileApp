import 'dart:io';

import 'package:deti_motica_app/page/list_page.dart';
import 'package:deti_motica_app/page/login.dart';
//import 'package:deti_motica_app/push_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<dynamic> onBackgroundMessageHandler(Map<String, dynamic> message) async {
  print(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseMessaging _fcm=FirebaseMessaging();
  FlutterLocalNotificationsPlugin _lnp=FlutterLocalNotificationsPlugin();

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }
  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {

  }
  Future displayNotification(Map<String, dynamic> message) async{
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channelid', 'flutterfcm', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await _lnp.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: 'hello',);
  }

  var initializationSettingsAndroid=AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS=IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initializationSettings=InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  _lnp.initialize(initializationSettings,
      onSelectNotification: onSelectNotification);

  _fcm.configure(
    onBackgroundMessage: Platform.isIOS?null:onBackgroundMessageHandler,
    onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      displayNotification(message);
      return;
    },
    onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      return;
    },
    onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      return;
    },
  );
  if (Platform.isIOS) _fcm.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true)
  );
  _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });
  _fcm.getToken().then((String token) {
    assert(token != null);
    print(token);
  });

  runApp(DETIMotica());
}

class DETIMotica extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
