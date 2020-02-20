import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';

import 'chat.bloc.dart';

class ChannelBloc with ChangeNotifier {
  final ChannelClient channelClient;
  final ChatBloc chatBloc;

  ChannelState get channelState =>
      channelClient.channelClientState.channelState;

  ChannelBloc(
    this.chatBloc,
    this.channelClient,
  );

  final BehaviorSubject<bool> _queryMessageController = BehaviorSubject();

  Stream<bool> get queryMessage => _queryMessageController.stream;

  void queryMessages() {
    _queryMessageController.add(true);

    String firstId;
    if (channelState.messages.isNotEmpty) {
      firstId = channelState.messages.first.id;
    }

    channelClient
        .query(
      messagesPagination: PaginationParams(
        lessThan: firstId,
        limit: 100,
      ),
    )
        .then((res) {
      _queryMessageController.add(false);
    }).catchError((e, stack) {
      _queryMessageController.addError(e, stack);
    });
  }

  @override
  void dispose() {
    _queryMessageController.close();
    channelClient.dispose();
    super.dispose();
  }
}

class InheritedChannelBloc extends InheritedWidget {
  final ChannelBloc channelBloc;

  InheritedChannelBloc({
    Key key,
    @required Widget child,
    @required this.channelBloc,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static InheritedChannelBloc of(BuildContext context) =>
      context.findAncestorWidgetOfExactType();
}
