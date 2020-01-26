// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    json['id'] as String,
    json['text'] as String,
    json['type'] as String,
    json['parent_id'] as String,
    json['reply_count'] as int,
    json['show_in_channel'] as bool,
    json['command'] as String,
    json['html'] as String,
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  )..extraData = json['extraData'] as Map<String, dynamic>;
}

Map<String, dynamic> _$MessageToJson(Message instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'text': instance.text,
    'type': instance.type,
    'parent_id': instance.parentID,
    'reply_count': instance.replyCount,
    'show_in_channel': instance.showInChannel,
    'command': instance.command,
    'html': instance.html,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'user': instance.user?.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('extraData', instance.extraData);
  return val;
}
