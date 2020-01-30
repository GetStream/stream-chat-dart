import 'package:json_annotation/json_annotation.dart';

import 'command.dart';

part 'channel_config.g.dart';

@JsonSerializable()
class ChannelConfig {
  String automod;
  List<Command> commands;
  bool connectEvents;
  DateTime createdAt;
  DateTime updatedAt;
  int maxMessageLength;
  String messageRetention;
  bool mutes;
  String name;
  bool reactions;
  bool readEvents;
  bool replies;
  bool search;
  bool typingEvents;
  bool uploads;
  bool urlEnrichment;

  ChannelConfig(
      this.automod,
      this.commands,
      this.connectEvents,
      this.createdAt,
      this.updatedAt,
      this.maxMessageLength,
      this.messageRetention,
      this.mutes,
      this.name,
      this.reactions,
      this.readEvents,
      this.replies,
      this.search,
      this.typingEvents,
      this.uploads,
      this.urlEnrichment);

  factory ChannelConfig.fromJson(Map<String, dynamic> json) =>
      _$ChannelConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelConfigToJson(this);
}
