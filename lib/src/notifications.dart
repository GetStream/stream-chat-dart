import 'package:flutter/material.dart';
import 'package:flutter_apns/apns.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat/src/db/offline_storage.dart';

import 'client.dart';
import 'models/user.dart';

void _handleNotification(Map<String, dynamic> data) async {
  final messageId = data['messageId'];
  final channelCid = data['channelCid'];

  if (messageId != null) {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userId = sharedPreferences.getString(KEY_USER_ID);
    final token = sharedPreferences.getString(KEY_TOKEN);

    final client = Client('s2dxdhpxd94g');
    client.state.user = User(id: userId);
    client.token = token;

    final offlineStorage = OfflineStorage(client.state.user.id);

    final res = await client.getMessage(messageId);
    final message = res.message;

    offlineStorage.updateMessages([message], channelCid);
    await offlineStorage.disconnect();
  }
}

void init(Client client) async {
  WidgetsFlutterBinding.ensureInitialized();
  final pushConnector = createPushConnector();
  pushConnector.requestNotificationPermissions();
  pushConnector.configure(
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
  pushConnector.token.addListener(() {
    final token = pushConnector.token.value;
    print('TOKEN REFRESHED $token');
    client.addDevice(token, 'firebase');
  });
  print('NOTIFICATION CONFIGURED');
}

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = Map<String, dynamic>.from(message['data']);
    print('NOTIFICATION DATA $data');
    _handleNotification(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print('NOTIFICATION MESSAGE $notification');
  }

  // Or do other work.
}
