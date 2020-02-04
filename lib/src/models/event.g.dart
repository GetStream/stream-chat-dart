// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    type: json['type'] as String,
    cid: json['cid'] as String,
    connectionId: json['connection_id'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    own: json['own'] == null
        ? null
        : User.fromJson(json['own'] as Map<String, dynamic>),
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    message: json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'type': instance.type,
      'cid': instance.cid,
      'connection_id': instance.connectionId,
      'created_at': instance.createdAt?.toIso8601String(),
      'own': instance.own?.toJson(),
      'user': instance.user?.toJson(),
      'message': instance.message?.toJson(),
    };
