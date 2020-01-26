// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Channel _$ChannelFromJson(Map<String, dynamic> json) {
  return Channel(
    json['id'] as String,
    json['type'] as String,
    json['cid'] as String,
    json['config'] == null
        ? null
        : ChannelConfig.fromJson(json['config'] as Map<String, dynamic>),
    json['created_by'] == null
        ? null
        : User.fromJson(json['created_by'] as Map<String, dynamic>),
    json['frozen'] as bool,
    json['last_message_at'] == null
        ? null
        : DateTime.parse(json['last_message_at'] as String),
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    json['deleted_at'] == null
        ? null
        : DateTime.parse(json['deleted_at'] as String),
    json['member_count'] as int,
    (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['extraData'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$ChannelToJson(Channel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': instance.type,
    'cid': instance.cid,
    'config': instance.config?.toJson(),
    'created_by': instance.createdBy?.toJson(),
    'frozen': instance.frozen,
    'last_message_at': instance.lastMessageAt?.toIso8601String(),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'member_count': instance.memberCount,
    'members': instance.members?.map((e) => e?.toJson())?.toList(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('extraData', instance.extraData);
  return val;
}
