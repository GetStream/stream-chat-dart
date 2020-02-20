import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';

import 'channel.bloc.dart';

class ChatBloc with ChangeNotifier {
  final Client client;
  final List<StreamSubscription> _subscriptions = [];
  final Map<String, ChannelBloc> channelBlocs = {};

  ChatBloc(this.client) {
    _subscriptions.add(client.on('message.new').listen((Event e) {
      final index = channels.indexWhere((c) => c.channel.cid == e.cid);
      if (index > 0) {
        final channel = channels.removeAt(index);
        channels.insert(0, channel);
        _channelsController.add(channels);
      }
    }));

    setUser(User(id: "wild-breeze-7"),
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoid2lsZC1icmVlemUtNyJ9.VM2EX1EXOfgqa-bTH_3JzeY0T99ngWzWahSauP3dBMo');
  }

  User get user => _userController.value;

  Stream<User> get userStream => _userController.stream;
  final BehaviorSubject<User> _userController = BehaviorSubject();

  void setUser(User newUser, [String token]) async {
    _userController.sink.add(null);

    try {
      if (token != null) {
        await client.setUser(newUser, token);
      } else {
        await client.setUserWithProvider(newUser);
      }
      _userController.sink.add(newUser);
    } catch (e, stack) {
      _userController.sink.addError(e, stack);
    }
  }

  Stream<List<ChannelState>> get channelsStream => _channelsController.stream;
  final BehaviorSubject<List<ChannelState>> _channelsController =
      BehaviorSubject();
  final List<ChannelState> channels = [];

  final BehaviorSubject<bool> _queryChannelsLoadingController =
      BehaviorSubject.seeded(false);

  Stream<bool> get queryChannelsLoading =>
      _queryChannelsLoadingController.stream;

  Future<void> queryChannels(
    Map<String, dynamic> filter,
    List<SortOption> sortOptions,
    PaginationParams paginationParams,
    Map<String, dynamic> options,
  ) async {
    if (_queryChannelsLoadingController.value) {
      return;
    }
    _queryChannelsLoadingController.sink.add(true);

    try {
      final res = await client.queryChannels(
        filter: filter,
        sort: sortOptions,
        options: options,
        paginationParams: paginationParams,
      );
      channels.addAll(res.map((c) => c.channelClientState.channelState));
      res.forEach((c) {
        if (!channelBlocs.containsKey(c.id)) {
          channelBlocs[c.id] = ChannelBloc(this, c);
        }
      });
      _channelsController.sink.add(channels);
      _queryChannelsLoadingController.sink.add(false);
    } catch (e) {
      _channelsController.sink.addError(e);
    }
  }

  void clearChannels() {
    channels.clear();
  }

  @override
  void dispose() {
    channelBlocs.values.forEach((cBloc) => cBloc.dispose());
    client.dispose();
    _subscriptions.forEach((s) => s.cancel());
    _userController.close();
    _queryChannelsLoadingController.close();
    _channelsController.close();
    super.dispose();
  }
}

class InheritedChatBloc extends InheritedWidget {
  final ChatBloc chatBloc;

  InheritedChatBloc({
    Key key,
    @required Widget child,
    @required this.chatBloc,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static InheritedChatBloc of(BuildContext context) =>
      context.findAncestorWidgetOfExactType();
}
