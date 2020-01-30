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
  )
    ..attachments = (json['attachments'] as List)
        ?.map((e) =>
            e == null ? null : Attachment.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..mentionedUsers = (json['mentioned_users'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..reactionCounts = (json['reaction_counts'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as int),
    )
    ..reactionScores = (json['reaction_scores'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as int),
    )
    ..latestReactions = (json['latest_reactions'] as List)
        ?.map((e) =>
            e == null ? null : Reaction.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..ownReactions = (json['own_reactions'] as List)
        ?.map((e) =>
            e == null ? null : Reaction.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..extraData = json['extra_data'] as Map<String, dynamic>;
}

Map<String, dynamic> _$MessageToJson(Message instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'text': instance.text,
    'type': instance.type,
    'attachments': instance.attachments?.map((e) => e?.toJson())?.toList(),
    'mentioned_users':
        instance.mentionedUsers?.map((e) => e?.toJson())?.toList(),
    'reaction_counts': instance.reactionCounts,
    'reaction_scores': instance.reactionScores,
    'latest_reactions':
        instance.latestReactions?.map((e) => e?.toJson())?.toList(),
    'own_reactions': instance.ownReactions?.map((e) => e?.toJson())?.toList(),
    'parent_id': instance.parentId,
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

  writeNotNull('extra_data', instance.extraData);
  return val;
}
