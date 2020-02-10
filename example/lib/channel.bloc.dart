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

  final BehaviorSubject<bool> _readController = BehaviorSubject.seeded(true);

  Stream<bool> get read => _readController.stream;

  bool get readValue => _readController.value;

  final BehaviorSubject<List<Message>> _messagesController = BehaviorSubject();

  Stream<List<Message>> get messages => _messagesController.stream;

  List<Message> get messageList => _messagesController.value;

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

      if (e.user.id != chatBloc.user.id) {
        _readController.add(false);
      }
    }));

    final userRead = channelState.read
        ?.lastWhere((r) => r.user.id == chatBloc.user.id, orElse: () => null);
    if (channelState.messages.last.user.id != chatBloc.user.id &&
        (userRead == null ||
            userRead.lastRead.isBefore(channelState.channel.lastMessageAt))) {
      _readController.add(false);
    }

    subscriptions.add(channelClient.on('message.read').listen((Event e) {
      if (e.user.id == chatBloc.user.id) {
        _readController.add(true);
      }
    }));

    subscriptions.add(channelClient.on('typing.start').listen((Event e) {
      _typingStateController.add(true);
    }));

    subscriptions.add(channelClient.on('typing.stop').listen((Event e) {
      _typingStateController.add(false);
    }));
  }

  final BehaviorSubject<bool> _queryMessageController = BehaviorSubject();

  Stream<bool> get queryMessage => _queryMessageController.stream;

  void queryMessages() {
    _queryMessageController.add(true);
    channelClient.query(
      {},
      messagesPagination: PaginationParams(
          lessThan: _channelState.messages.first.id, limit: 10),
    ).then((res) {
      _channelState.messages.insertAll(0, res.messages);

      _messagesController.add(_channelState.messages);
      _queryMessageController.add(false);
    }).catchError((e, stack) {
      _queryMessageController.addError(e, stack);
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscriptions.forEach((s) => s.cancel());
    _readController.close();
    _typingStateController.close();
    _channelStateController.close();
    _messagesController.close();
    _queryMessageController.close();
  }
}
