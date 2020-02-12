import 'dart:async';

import 'package:flutter/foundation.dart';
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
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoid2lsZC1icmVlemUtNyJ9.VM2EX1EXOfgqa-bTH_3JzeY0T99ngWzWahSauP3dBMo");
  }

  final BehaviorSubject<User> _userController = BehaviorSubject();

  Stream<User> get userStream => _userController.stream;

  User get user => _userController.value;

  void setUser(User newUser, String token) async {
    _userController.sink.add(null);

    try {
      await client.setUser(newUser, token);
      _userController.sink.add(newUser);
    } catch (e, stack) {
      _userController.sink.addError(e, stack);
    }
  }

  final List<ChannelState> channels = [];

  final BehaviorSubject<List<ChannelState>> _channelsController =
      BehaviorSubject();

  Stream<List<ChannelState>> get channelsStream => _channelsController.stream;

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
      channels.addAll(res.channels);
      channels.forEach((c) {
        if (!channelBlocs.containsKey(c.channel.id)) {
          channelBlocs[c.channel.id] = ChannelBloc(client, c, this);
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
    client.dispose();
    _subscriptions.forEach((s) => s.cancel());
    _userController.close();
    _queryChannelsLoadingController.close();
    _channelsController.close();
    super.dispose();
  }
}
