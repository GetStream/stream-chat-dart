import '../models/read.dart';
import '../models/user.dart';

import 'channel.dart';
import 'package:json_annotation/json_annotation.dart';

import 'member.dart';
import 'message.dart';

part 'channel_state.g.dart';

@JsonSerializable()
class ChannelState {
  Channel channel;
  List<Message> messages;
  List<Member> members;
  int watcherCount;
  List<User> watchers;
  List<Read> read;

  ChannelState(this.channel, this.messages, this.members, this.watcherCount,
      this.watchers, this.read);

  factory ChannelState.fromJson(Map<String, dynamic> json) =>
      _$ChannelStateFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelStateToJson(this);
}
