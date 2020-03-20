import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_apns/apns.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat/src/api/connection_status.dart';
import 'package:stream_chat/src/db/offline_storage.dart';
import 'package:stream_chat/src/models/channel_model.dart';
import 'package:stream_chat/src/models/channel_state.dart';
import 'package:stream_chat/src/models/message.dart';

import 'client.dart';

Future<void> _handleNotification(
  Map<String, dynamic> notification,
  Client client,
) async {
  print('New notification $notification');
  if (notification.containsKey('data')) {
    final data = Map<String, dynamic>.from(notification['data']);
    final message = Message.fromJson(
      Map<String, dynamic>.from(jsonDecode(data['message'].toString())),
    ).copyWith(
      createdAt: DateTime.now(),
    );
    final channelModel = ChannelModel.fromJson(
      Map<String, dynamic>.from(jsonDecode(data['channel'].toString())),
    );

    if (message != null) {
      if (client == null) {
        final sharedPreferences = await SharedPreferences.getInstance();
        final userId = sharedPreferences.getString(KEY_USER_ID);

        final offlineStorage = OfflineStorage(userId, Logger('💽'));
        await offlineStorage.updateChannelState(
          ChannelState(
            channel: channelModel,
            messages: [message],
          ),
        );
      } else {
        if (client.wsConnectionStatus.value == ConnectionStatus.disconnected) {
          await client.connect();
        }
        final channel = client.state.channels.firstWhere(
          (c) => c.cid == channelModel.cid,
        );
        channel.state.updateChannelState(
          ChannelState(
            channel: channelModel,
            messages: [message],
          ),
        );
      }
    }
  }
}

void init(Client client) async {
  WidgetsFlutterBinding.ensureInitialized();

  final pushConnector = createPushConnector();
  pushConnector.requestNotificationPermissions();

  // workaround for https://github.com/FirebaseExtended/flutterfire/issues/1669
  var lastMessage;
  pushConnector.configure(
    onMessage: (message) async {
      if (message == lastMessage) {
        return;
      }
      lastMessage = message;
      await _handleNotification(message, client);
    },
    onLaunch: (message) async {
      if (message == lastMessage) {
        return;
      }
      lastMessage = message;
      await _handleNotification(message, client);
    },
    onResume: (message) async {
      if (lastMessage != null &&
          message['data'].toString() == lastMessage['data'].toString()) {
        return;
      }
      lastMessage = message;
      await _handleNotification(message, client);
    },
  );
  pushConnector.token.addListener(() {
    final token = pushConnector.token.value;
    client.addDevice(token, 'firebase');
  });
}
