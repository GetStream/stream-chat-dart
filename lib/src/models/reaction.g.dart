// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reaction _$ReactionFromJson(Map<String, dynamic> json) {
  return Reaction(
    messageId: json['message_id'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    type: json['type'] as String,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    userId: json['user_id'] as String,
    score: json['score'] as int,
    extraData: json['extra_data'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$ReactionToJson(Reaction instance) {
  final val = <String, dynamic>{
    'message_id': instance.messageId,
    'created_at': instance.createdAt?.toIso8601String(),
    'type': instance.type,
    'user': instance.user?.toJson(),
    'score': instance.score,
    'user_id': instance.userId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('extra_data', instance.extraData);
  return val;
}
