import 'package:stream_chat_dart/models/member.dart';
import 'package:stream_chat_dart/models/read.dart';
import 'package:stream_chat_dart/models/user.dart';

import 'channel.dart';
import 'package:json_annotation/json_annotation.dart';

import 'message.dart';

part 'channel_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ChannelState {

  Channel channel;
  List<Message> messages;
  List<Member> members;

  @JsonKey(name:"watcher_count")
  int watcherCount;

  List<User> watchers;
  List<Read> read;

  ChannelState(this.channel, this.messages, this.members, this.watcherCount,
      this.watchers, this.read);

  factory ChannelState.fromJson(Map<String, dynamic> json) => _$ChannelStateFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelStateToJson(this);

}