import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';

class ChannelBloc with ChangeNotifier {
  final BehaviorSubject<ChannelState> _channelStateController =
      BehaviorSubject();

  Stream<ChannelState> get channelState => _channelStateController.stream;

  final BehaviorSubject<bool> _typingStateController =
      BehaviorSubject.seeded(false);

  Stream<bool> get typing => _typingStateController.stream;

  final BehaviorSubject<bool> _newMessageController =
      BehaviorSubject.seeded(false);

  Stream<bool> get newMessage => _newMessageController.stream;

  final ChannelState _channelState;
  final ChannelClient channelClient;
  final List<StreamSubscription> subscriptions = [];

  ChannelBloc(Client client, ChannelState channelState)
      : channelClient = ChannelClient(
          client,
          channelState.channel.type,
          channelState.channel.id,
          null,
        ),
        _channelState = channelState {
    _channelStateController.sink.add(_channelState);
    subscriptions.add(channelClient.on('message.new').listen((Event e) {
      channelState.messages.add(e.message);
      _newMessageController.add(true);
    }));

    subscriptions.add(channelClient.on('message.read').listen((Event e) {
      _newMessageController.add(false);
    }));

    subscriptions.add(channelClient.on('typing.start').listen((Event e) {
      _typingStateController.add(true);
    }));

    subscriptions.add(channelClient.on('typing.stop').listen((Event e) {
      _typingStateController.add(false);
    }));
  }

  @override
  void dispose() {
    super.dispose();
    subscriptions.forEach((s) => s.cancel());
    _newMessageController.close();
    _typingStateController.close();
    _channelStateController.close();
  }
}
