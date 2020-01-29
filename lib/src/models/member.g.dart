// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) {
  return Member(
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    json['invite_accepted_at'] == null
        ? null
        : DateTime.parse(json['invite_accepted_at'] as String),
    json['invite_rejected_at'] == null
        ? null
        : DateTime.parse(json['invite_rejected_at'] as String),
    json['invited'] as bool,
    json['role'] as String,
    json['user_id'] as String,
    json['is_moderator'] as bool,
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'user': instance.user?.toJson(),
      'invite_accepted_at': instance.inviteAcceptedAt?.toIso8601String(),
      'invite_rejected_at': instance.inviteRejectedAt?.toIso8601String(),
      'invited': instance.invited,
      'role': instance.role,
      'user_id': instance.userID,
      'is_moderator': instance.isModerator,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
