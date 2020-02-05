import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';

import 'chat.bloc.dart';

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

  final BehaviorSubject<List<Message>> _messagesController = BehaviorSubject();

  Stream<List<Message>> get messages => _messagesController.stream;

  final ChannelState _channelState;
  final ChannelClient channelClient;
  final List<StreamSubscription> subscriptions = [];
  final ChatBloc chatBloc;

  ChannelBloc(Client client, ChannelState channelState, this.chatBloc)
      : channelClient = ChannelClient(
          client,
          channelState.channel.type,
          channelState.channel.id,
          null,
        ),
        _channelState = channelState {
    _channelStateController.sink.add(_channelState);
    _messagesController.add(_channelState.messages);
    subscriptions.add(channelClient.on('message.new').listen((Event e) {
      channelState.messages.add(e.message);
      _messagesController.add(channelState.messages);
      _newMessageController.add(true);
    }));

    subscriptions.add(channelClient.on('message.read').listen((Event e) {
      if (e.user.id == chatBloc.user.id) {
        _newMessageController.add(false);
      }
    }));

    subscriptions.add(channelClient.on('typing.start').listen((Event e) {
      _typingStateController.add(true);
    }));

    subscriptions.add(channelClient.on('typing.stop').listen((Event e) {
      _typingStateController.add(false);
    }));
  }

  void queryMessages() async {
    final res = await channelClient.query(
      {},
      messagesPagination: PaginationParams(
          lessThan: _channelState.messages.first.id, limit: 10),
    );

    _channelState.messages.insertAll(0, res.messages);

    _messagesController.add(_channelState.messages);
  }

  @override
  void dispose() {
    super.dispose();
    subscriptions.forEach((s) => s.cancel());
    _newMessageController.close();
    _typingStateController.close();
    _channelStateController.close();
    _messagesController.close();
  }
}
