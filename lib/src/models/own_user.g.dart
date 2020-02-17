// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'own_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnUser _$OwnUserFromJson(Map<String, dynamic> json) {
  return OwnUser(
    (json['devices'] as List)
        ?.map((e) =>
            e == null ? null : Device.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['mutes'] as List)
        ?.map(
            (e) => e == null ? null : Mute.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['total_unread_count'] as int,
    json['unread_channels'] as int,
    json['id'],
    json['role'],
    json['created_at'],
    json['updated_at'],
    json['last_active'],
    json['online'],
    json['extra_data'],
    json['banned'],
  );
}

Map<String, dynamic> _$OwnUserToJson(OwnUser instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('role', readonly(instance.role));
  writeNotNull('created_at', readonly(instance.createdAt));
  writeNotNull('updated_at', readonly(instance.updatedAt));
  writeNotNull('last_active', readonly(instance.lastActive));
  writeNotNull('online', readonly(instance.online));
  writeNotNull('banned', readonly(instance.banned));
  writeNotNull('extra_data', instance.extraData);
  writeNotNull('devices', readonly(instance.devices));
  writeNotNull('mutes', readonly(instance.mutes));
  writeNotNull('total_unread_count', readonly(instance.totalUnreadCount));
  writeNotNull('unread_channels', readonly(instance.unreadChannels));
  return val;
}
