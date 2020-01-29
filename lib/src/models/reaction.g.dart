// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reaction _$ReactionFromJson(Map<String, dynamic> json) {
  return Reaction(
    json['message_id'] as String,
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    json['type'] as String,
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    json['user_id'] as String,
  )
    ..score = json['score'] as int
    ..extraData = json['extraData'] as Map<String, dynamic>;
}

Map<String, dynamic> _$ReactionToJson(Reaction instance) {
  final val = <String, dynamic>{
    'message_id': instance.messageID,
    'created_at': instance.createdAt?.toIso8601String(),
    'type': instance.type,
    'user': instance.user?.toJson(),
    'score': instance.score,
    'user_id': instance.userID,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('extraData', instance.extraData);
  return val;
}
