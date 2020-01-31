// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Read _$ReadFromJson(Map<String, dynamic> json) {
  return Read(
    lastRead: json['last_read'] == null
        ? null
        : DateTime.parse(json['last_read'] as String),
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ReadToJson(Read instance) => <String, dynamic>{
      'last_read': instance.lastRead?.toIso8601String(),
      'user': instance.user?.toJson(),
    };
