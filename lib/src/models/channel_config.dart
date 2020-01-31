import 'package:json_annotation/json_annotation.dart';

import 'command.dart';

part 'channel_config.g.dart';

@JsonSerializable()
class ChannelConfig {
  final String automod;
  final List<Command> commands;
  final bool connectEvents;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int maxMessageLength;
  final String messageRetention;
  final bool mutes;
  final String name;
  final bool reactions;
  final bool readEvents;
  final bool replies;
  final bool search;
  final bool typingEvents;
  final bool uploads;
  final bool urlEnrichment;

  ChannelConfig({
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
    this.urlEnrichment,
  });

  factory ChannelConfig.fromJson(Map<String, dynamic> json) =>
      _$ChannelConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelConfigToJson(this);
}
