import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';

import 'chat.bloc.dart';

class ChannelBloc with ChangeNotifier {
  final ChannelState channelState;

  final BehaviorSubject<bool> _readController = BehaviorSubject.seeded(true);

  Stream<bool> get read => _readController.stream;

  bool get readValue => _readController.value;

  final BehaviorSubject<List<Message>> _messagesController = BehaviorSubject();

  Stream<List<Message>> get messages => _messagesController.stream;

  List<Message> get messageList => _messagesController.value;

  final ChannelClient channelClient;
  final List<StreamSubscription> _subscriptions = [];
  final ChatBloc chatBloc;

  ChannelBloc(Client client, this.channelState, this.chatBloc)
      : channelClient = ChannelClient(
          client,
          channelState.channel.type,
          channelState.channel.id,
          null,
        ) {
    _messagesController.add(channelState.messages);
    _subscriptions.add(channelClient.on('message.new').listen((Event e) {
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

    _subscriptions.add(channelClient.on('message.read').listen((Event e) {
      if (e.user.id == chatBloc.user.id) {
        _readController.add(true);
      }
    }));
  }

  final BehaviorSubject<bool> _queryMessageController = BehaviorSubject();

  Stream<bool> get queryMessage => _queryMessageController.stream;

  void queryMessages() {
    _queryMessageController.add(true);
    channelClient.query(
      {},
      messagesPagination:
          PaginationParams(lessThan: channelState.messages.first.id, limit: 10),
    ).then((res) {
      channelState.messages.insertAll(0, res.messages);

      _messagesController.add(channelState.messages);
      _queryMessageController.add(false);
    }).catchError((e, stack) {
      _queryMessageController.addError(e, stack);
    });
  }

  @override
  void dispose() {
    _subscriptions.forEach((s) => s.cancel());
    _readController.close();
    _messagesController.close();
    _queryMessageController.close();
    channelClient.dispose();
    super.dispose();
  }
}
