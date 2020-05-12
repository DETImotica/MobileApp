import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationManager {
  static final PushNotificationManager _singleton=PushNotificationManager._single();

  Future<dynamic> bkgMessageHandler(Map<String, dynamic> message) async {
    print("onMessage: $message");
  }

  final FirebaseMessaging _fcm=FirebaseMessaging();

  PushNotificationManager._single();

  Future init() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onBackgroundMessage: bkgMessageHandler,
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    _fcm.getToken().then((token){
      print('FCM Token: $token');
    });
  }

  factory PushNotificationManager() {
    return _singleton;
  }

}