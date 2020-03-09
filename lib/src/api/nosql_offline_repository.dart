import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stream_chat/src/models/channel_state.dart';

class OfflineRepository {
  Box _channelStatesBox;

  OfflineRepository() {
    Hive.initFlutter().then((_) {
      _channelStatesBox = Hive.box('channelStates');
    });
  }

  List<ChannelState> getChannelStates() {
    _channelStatesBox.values.toList();
  }

  void updateChannelStates(List<ChannelState> channelStates) {
    _channelStatesBox.putAll(
        Map.fromEntries(channelStates.map((c) => MapEntry(c.channel.cid, c))));
  }
}
