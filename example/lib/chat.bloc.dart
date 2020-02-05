import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_example/channel.bloc.dart';

class ChatBloc with ChangeNotifier {
  final Client client;
  final List<StreamSubscription> subscriptions = [];
  final Map<String, ChannelBloc> channelBlocs = {};

  ChatBloc(this.client) {
    subscriptions.add(client.stream.listen((Event e) {
      if (e.type == 'message.new') {
        final index = channels.indexWhere((c) => c.channel.cid == e.cid);
        final channel = channels.removeAt(index);
        print(index);
        channels.insert(0, channel);
        _channelsController.add(channels);
      }
    }));
  }

  final BehaviorSubject<User> _userController = BehaviorSubject();

  Stream<User> get userStream => _userController.stream;

  User user;

  void setUser(User newUser, String token) async {
    _userController.sink.add(null);
    user = null;

    try {
      await client.setUser(newUser, token);
      user = newUser;
      _userController.sink.add(user);
      print(newUser.id);
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
        channelBlocs[c.channel.id] = ChannelBloc(client, c);
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
    super.dispose();
    client.dispose();
    subscriptions.forEach((s) => s.cancel());
    _userController.close();
    _queryChannelsLoadingController.close();
    _channelsController.close();
  }
}
