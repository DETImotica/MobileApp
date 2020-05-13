import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<dynamic> onBackgroundMessageHandler(Map<String, dynamic> message) async {
  print(message);
}

PushNotificationManager pnm=PushNotificationManager();

class PushNotificationManager {
  static final PushNotificationManager _singleton=PushNotificationManager._single();

  final FirebaseMessaging _fcm=FirebaseMessaging();
  FlutterLocalNotificationsPlugin _lnp=FlutterLocalNotificationsPlugin();

  PushNotificationManager._single();

  Future init() async {
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
          icon: "@drawable/logo",
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

    _fcm.subscribeToTopic('control');
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
  }

  subscribe(String topic) {
    return _fcm.subscribeToTopic(topic);
  }

  unsubscribe(String topic) {
    return _fcm.unsubscribeFromTopic(topic);
  }

  factory PushNotificationManager() {
    return _singleton;
  }

}