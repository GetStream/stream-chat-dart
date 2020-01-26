// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelConfig _$ChannelConfigFromJson(Map<String, dynamic> json) {
  return ChannelConfig(
    json['automod'] as String,
    (json['commands'] as List)
        ?.map((e) =>
            e == null ? null : Command.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['connect_events'] as bool,
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    json['max_message_length'] as int,
    json['message_retention'] as String,
    json['mutes'] as bool,
    json['name'] as String,
    json['reactions'] as bool,
    json['read_events'] as bool,
    json['replies'] as bool,
    json['search'] as bool,
    json['typing_events'] as bool,
    json['uploads'] as bool,
    json['url_enrichment'] as bool,
  );
}

Map<String, dynamic> _$ChannelConfigToJson(ChannelConfig instance) =>
    <String, dynamic>{
      'automod': instance.automod,
      'commands': instance.commands?.map((e) => e?.toJson())?.toList(),
      'connect_events': instance.connectEvents,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'max_message_length': instance.maxMessageLength,
      'message_retention': instance.messageRetention,
      'mutes': instance.mutes,
      'name': instance.name,
      'reactions': instance.reactions,
      'read_events': instance.readEvents,
      'replies': instance.replies,
      'search': instance.search,
      'typing_events': instance.typingEvents,
      'uploads': instance.uploads,
      'url_enrichment': instance.urlEnrichment,
    };
