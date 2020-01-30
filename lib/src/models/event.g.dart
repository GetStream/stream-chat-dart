// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    json['type'] as String,
    json['cid'] as String,
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    json['own'] == null
        ? null
        : User.fromJson(json['own'] as Map<String, dynamic>),
  )
    ..connectionId = json['connection_id'] as String
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'type': instance.type,
      'cid': instance.cid,
      'connection_id': instance.connectionId,
      'created_at': instance.createdAt?.toIso8601String(),
      'own': instance.own?.toJson(),
      'user': instance.user?.toJson(),
    };
