// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Read _$ReadFromJson(Map<String, dynamic> json) {
  return Read(
    json['last_read'] == null
        ? null
        : DateTime.parse(json['last_read'] as String),
    json['user'] as String,
  );
}

Map<String, dynamic> _$ReadToJson(Read instance) => <String, dynamic>{
      'last_read': instance.lastRead?.toIso8601String(),
      'user': instance.user,
    };
