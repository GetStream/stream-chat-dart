import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'client.dart';

void init(Client client) async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  await _firebaseMessaging.requestNotificationPermissions();
  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    },
    onBackgroundMessage: backgroundMessageHandler,
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    },
  );
  _firebaseMessaging.onTokenRefresh.listen((token) {
    print('TOKEN REFRESHED $token');
    client.addDevice(token, 'firebase');
  });
  print('NOTIFICATION CONFIGURED');
}

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print('NOTIFICATION DATA $data');
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print('NOTIFICATION MESSAGE $notification');
  }

  // Or do other work.
}
