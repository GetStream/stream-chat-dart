import 'package:json_annotation/json_annotation.dart';

import 'command.dart';

part 'channel_config.g.dart';

@JsonSerializable(explicitToJson: true)
class ChannelConfig {
  String automod;
  List<Command> commands;

  @JsonKey(name: 'connect_events')
  bool connectEvents;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  @JsonKey(name: 'max_message_length')
  int maxMessageLength;

  @JsonKey(name: 'message_retention')
  String messageRetention;

  bool mutes;
  String name;
  bool reactions;

  @JsonKey(name: 'read_events')
  bool readEvents;

  bool replies;
  bool search;

  @JsonKey(name: 'typing_events')
  bool typingEvents;

  bool uploads;

  @JsonKey(name: 'url_enrichment')
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
