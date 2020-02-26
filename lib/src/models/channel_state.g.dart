// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelState _$ChannelStateFromJson(Map<String, dynamic> json) {
  return ChannelState(
    channel: json['channel'] == null
        ? null
        : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>),
    messages: (json['messages'] as List)
        ?.map((e) =>
            e == null ? null : Message.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    members: (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    watcherCount: json['watcher_count'] as int,
    watchers: (json['watchers'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    read: (json['read'] as List)
        ?.map(
            (e) => e == null ? null : Read.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ChannelStateToJson(ChannelState instance) =>
    <String, dynamic>{
      'channel': instance.channel?.toJson(),
      'messages': instance.messages?.map((e) => e?.toJson())?.toList(),
      'members': instance.members?.map((e) => e?.toJson())?.toList(),
      'watcher_count': instance.watcherCount,
      'watchers': instance.watchers?.map((e) => e?.toJson())?.toList(),
      'read': instance.read?.map((e) => e?.toJson())?.toList(),
    };
