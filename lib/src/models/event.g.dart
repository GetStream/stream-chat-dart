// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map json) {
  return Event(
    type: json['type'] as String,
    cid: json['cid'] as String,
    connectionId: json['connection_id'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    me: json['me'] == null
        ? null
        : OwnUser.fromJson((json['me'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    user: json['user'] == null
        ? null
        : User.fromJson((json['user'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    message: json['message'] == null
        ? null
        : Message.fromJson((json['message'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    totalUnreadCount: json['total_unread_count'] as int,
    unreadChannels: json['unread_channels'] as int,
    reaction: json['reaction'] == null
        ? null
        : Reaction.fromJson((json['reaction'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    online: json['online'] as bool,
    channel: json['channel'] == null
        ? null
        : EventChannel.fromJson(json['channel'] as Map),
  )..isLocal = json['is_local'] as bool;
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'type': instance.type,
      'cid': instance.cid,
      'connection_id': instance.connectionId,
      'created_at': instance.createdAt?.toIso8601String(),
      'me': instance.me?.toJson(),
      'user': instance.user?.toJson(),
      'message': instance.message?.toJson(),
      'channel': instance.channel?.toJson(),
      'reaction': instance.reaction?.toJson(),
      'total_unread_count': instance.totalUnreadCount,
      'unread_channels': instance.unreadChannels,
      'online': instance.online,
      'is_local': instance.isLocal,
    };

EventChannel _$EventChannelFromJson(Map json) {
  return EventChannel(
    members: (json['members'] as List)
        ?.map((e) => e == null
            ? null
            : Member.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$EventChannelToJson(EventChannel instance) =>
    <String, dynamic>{
      'members': instance.members?.map((e) => e?.toJson())?.toList(),
    };
