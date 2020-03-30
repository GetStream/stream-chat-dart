import 'dart:convert';
import 'dart:io';

import 'package:flutter_apns/apns.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as loc;
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat/src/api/connection_status.dart';
import 'package:stream_chat/src/db/offline_storage.dart';
import 'package:stream_chat/src/models/channel_model.dart';
import 'package:stream_chat/src/models/channel_state.dart';
import 'package:stream_chat/src/models/message.dart';

import 'client.dart';
import 'models/own_user.dart';

class _NotificationData {
  final Message message;
  final ChannelModel channel;

  _NotificationData(this.message, this.channel);
}

class AndroidNotificationOptions {
  final loc.AndroidNotificationDetails androidNotificationDetails;
  final String title;
  final String body;
  final int id;

  AndroidNotificationOptions({
    this.id,
    this.androidNotificationDetails,
    this.title,
    this.body,
  });
}

typedef NotificationHandler = void Function(Map<String, dynamic> notification);

class NotificationService {
  static Future<void> _handleNotification(
    Map<String, dynamic> notification,
    Client client,
  ) async {
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
          if (client.wsConnectionStatus.value ==
              ConnectionStatus.disconnected) {
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

  static Future<void> _handleBackgroundNotification(
    Map<String, dynamic> notification,
  ) async {
    _NotificationData messageChannel = await getAndStoreMessage(notification);

    final androidNotificationOptions = getAndroidNotificationOptions(
      messageChannel.message,
      messageChannel.channel,
    );

    await sendNotification(androidNotificationOptions);
  }

  static Future<void> sendNotification(
    AndroidNotificationOptions androidNotificationOptions,
  ) async {
    final platformChannelSpecifics = loc.NotificationDetails(
      androidNotificationOptions.androidNotificationDetails,
      null,
    );

    loc.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        loc.FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
      androidNotificationOptions.id,
      androidNotificationOptions.title,
      androidNotificationOptions.body,
      platformChannelSpecifics,
    );
  }

  static Future<_NotificationData> getAndStoreMessage(
    Map<String, dynamic> notification,
  ) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final apiKey = sharedPreferences.getString(KEY_API_KEY);

    final client = Client(
      apiKey,
      persistenceEnabled: false,
    );
    final userId = sharedPreferences.getString(KEY_USER_ID);
    final token = sharedPreferences.getString(KEY_TOKEN);

    client.state.user = OwnUser(id: userId);
    client.token = token;

    final data = Map<String, dynamic>.from(notification['data']);

    final res = await client.getMessage(data['message_id']);
    final message = res.message;
    final channel = ChannelModel.fromJson(message.extraData['channel']);

    final offlineStorage = OfflineStorage(
      userId,
      Logger('💽'),
    );

    await offlineStorage.updateChannelState(ChannelState(
      messages: [message],
      channel: channel,
    ));

    await offlineStorage.disconnect();

    final messageChannel = _NotificationData(message, channel);
    return messageChannel;
  }

  static AndroidNotificationOptions getAndroidNotificationOptions(
    Message message,
    ChannelModel channel,
  ) {
    final androidPlatformChannelSpecifics = loc.AndroidNotificationDetails(
      'Message notifications',
      'Message notifications',
      'Channel dedicated to message notifications',
      importance: loc.Importance.Max,
      priority: loc.Priority.High,
    );

    return AndroidNotificationOptions(
      androidNotificationDetails: androidPlatformChannelSpecifics,
      id: message.id.hashCode,
      title: '${message.user.name} @ ${channel.cid}',
      body: message.text,
    );
  }

  static void init(
    Client client,
    NotificationHandler notificationHandler,
  ) async {
    final pushConnector = createPushConnector();
    pushConnector.requestNotificationPermissions();

    loc.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        loc.FlutterLocalNotificationsPlugin();
    final initializationSettingsAndroid =
        loc.AndroidInitializationSettings('launch_background');
    final initializationSettings = loc.InitializationSettings(
        initializationSettingsAndroid, loc.IOSInitializationSettings());
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

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
      onBackgroundMessage: notificationHandler ?? _handleBackgroundNotification,
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
      client.addDevice(token, Platform.isAndroid ? 'firebase' : 'apn');
    });
  }
}
