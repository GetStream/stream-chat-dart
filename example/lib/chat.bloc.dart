import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:stream_chat/stream_chat.dart';

class ChatBloc with ChangeNotifier {
  final Client client;

  ChatBloc(this.client) {
    client.stream.listen((Event e) {
      if (e.type == 'message.new') {
        final index = channels.indexWhere((c) => c.channel.cid == e.cid);
        final channel = channels.removeAt(index);
        channel.messages.add(e.message);
        channels.insert(0, channel);
        _channelsController.sink.add(channels);
      }
    });
  }

  final StreamController<bool> _setUserLoadingController =
      StreamController.broadcast()..add(false);

  Stream<bool> get setUserLoading => _setUserLoadingController.stream;

  void setUser(User user, String token) async {
    _setUserLoadingController.sink.add(true);

    try {
      await client.setUser(user, token);
      _setUserLoadingController.sink.add(false);
    } catch (e) {
      _setUserLoadingController.sink.addError(e);
    }
  }

  final List<ChannelState> channels = [];

  final StreamController<List<ChannelState>> _channelsController =
      StreamController.broadcast()..add(null);

  Stream<List<ChannelState>> get channelsStream => _channelsController.stream;

  final StreamController<bool> _queryChannelsLoadingController =
      StreamController.broadcast()..add(false);

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
      _channelsController.sink.add(channels);
    } catch (e) {
      _channelsController.sink.addError(e);
    } finally {
      _queryChannelsLoadingController.sink.add(false);
    }
  }

  void clearChannels() {
    channels.clear();
  }

  @override
  void dispose() {
    super.dispose();
    client.dispose();
    _setUserLoadingController.close();
    _queryChannelsLoadingController.close();
    _channelsController.close();
  }
}
