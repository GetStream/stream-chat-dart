// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelModel _$ChannelModelFromJson(Map<String, dynamic> json) {
  return ChannelModel(
    id: json['id'] as String,
    type: json['type'] as String,
    cid: json['cid'] as String,
    config: json['config'] == null
        ? null
        : ChannelConfig.fromJson(json['config'] as Map<String, dynamic>),
    createdBy: json['created_by'] == null
        ? null
        : User.fromJson(json['created_by'] as Map<String, dynamic>),
    frozen: json['frozen'] as bool,
    lastMessageAt: json['last_message_at'] == null
        ? null
        : DateTime.parse(json['last_message_at'] as String),
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    deletedAt: json['deleted_at'] == null
        ? null
        : DateTime.parse(json['deleted_at'] as String),
    memberCount: json['member_count'] as int,
    members: (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    extraData: json['extra_data'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$ChannelModelToJson(ChannelModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('cid', readonly(instance.cid));
  writeNotNull('config', readonly(instance.config));
  writeNotNull('created_by', readonly(instance.createdBy));
  writeNotNull('frozen', instance.frozen);
  writeNotNull('last_message_at', readonly(instance.lastMessageAt));
  writeNotNull('created_at', readonly(instance.createdAt));
  writeNotNull('updated_at', readonly(instance.updatedAt));
  writeNotNull('deleted_at', readonly(instance.deletedAt));
  writeNotNull('member_count', readonly(instance.memberCount));
  writeNotNull('members', instance.members?.map((e) => e?.toJson())?.toList());
  writeNotNull('extra_data', instance.extraData);
  return val;
}
