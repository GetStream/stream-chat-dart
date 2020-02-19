import 'package:json_annotation/json_annotation.dart';

import '../models/read.dart';
import '../models/user.dart';
import 'channel.dart';
import 'member.dart';
import 'message.dart';

part 'channel_state.g.dart';

/// The class that contains the information about a command
@JsonSerializable()
class ChannelState {
  /// The channel to which this state belongs
  final Channel channel;

  /// A paginated list of channel messages
  final List<Message> messages;

  /// A paginated list of channel members
  final List<Member> members;

  /// The count of users watching the channel
  final int watcherCount;

  /// A paginated list of users watching the channel
  final List<User> watchers;

  /// The list of channel reads
  final List<Read> read;

  /// Constructor used for json serialization
  ChannelState({
    this.channel,
    this.messages,
    this.members,
    this.watcherCount,
    this.watchers,
    this.read,
  });

  /// Create a new instance from a json
  static ChannelState fromJson(Map<String, dynamic> json) =>
      _$ChannelStateFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ChannelStateToJson(this);
}
