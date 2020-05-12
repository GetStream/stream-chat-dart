// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    id: json['id'] as String,
    text: json['text'] as String,
    type: json['type'] as String,
    attachments: (json['attachments'] as List)
        ?.map((e) =>
            e == null ? null : Attachment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    mentionedUsers: (json['mentioned_users'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    silent: json['silent'] as bool,
    reactionCounts: (json['reaction_counts'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as int),
    ),
    reactionScores: (json['reaction_scores'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as int),
    ),
    latestReactions: (json['latest_reactions'] as List)
        ?.map((e) =>
            e == null ? null : Reaction.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    ownReactions: (json['own_reactions'] as List)
        ?.map((e) =>
            e == null ? null : Reaction.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    parentId: json['parent_id'] as String,
    replyCount: json['reply_count'] as int,
    showInChannel: json['show_in_channel'] as bool,
    command: json['command'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    extraData: json['extra_data'] as Map<String, dynamic>,
    status: _$enumDecodeNullable(_$MessageSendingStatusEnumMap, json['status']),
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'text': instance.text,
    'status': _$MessageSendingStatusEnumMap[instance.status],
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('type', readonly(instance.type));
  writeNotNull(
      'attachments', instance.attachments?.map((e) => e?.toJson())?.toList());
  val['mentioned_users'] = Serialization.userIds(instance.mentionedUsers);
  writeNotNull('reaction_counts', readonly(instance.reactionCounts));
  writeNotNull('reaction_scores', readonly(instance.reactionScores));
  writeNotNull('latest_reactions', readonly(instance.latestReactions));
  writeNotNull('own_reactions', readonly(instance.ownReactions));
  val['parent_id'] = instance.parentId;
  writeNotNull('reply_count', readonly(instance.replyCount));
  val['show_in_channel'] = instance.showInChannel;
  val['silent'] = instance.silent;
  writeNotNull('command', readonly(instance.command));
  writeNotNull('created_at', readonly(instance.createdAt));
  writeNotNull('updated_at', readonly(instance.updatedAt));
  writeNotNull('user', readonly(instance.user));
  writeNotNull('extra_data', instance.extraData);
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$MessageSendingStatusEnumMap = {
  MessageSendingStatus.SENDING: 'SENDING',
  MessageSendingStatus.SENT: 'SENT',
  MessageSendingStatus.FAILED: 'FAILED',
};
