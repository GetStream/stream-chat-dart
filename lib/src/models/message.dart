import 'package:json_annotation/json_annotation.dart';

import 'attachment.dart';
import 'reaction.dart';
import 'serialization.dart';
import 'user.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final String id;
  final String text;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final String type;

  @JsonKey(includeIfNull: false)
  final List<Attachment> attachments;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final List<User> mentionedUsers;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final Map<String, int> reactionCounts;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final Map<String, int> reactionScores;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final List<Reaction> latestReactions;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final List<Reaction> ownReactions;

  final String parentId;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final int replyCount;

  final bool showInChannel;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final String command;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final String html;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime createdAt;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime updatedAt;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final User user;

  @JsonKey(includeIfNull: false)
  final Map<String, dynamic> extraData;

  static const topLevelFields = [
    'id',
    'text',
    'type',
    'attachments',
    'latest_reactions',
    'own_reactions',
    'mentioned_users',
    'reaction_counts',
    'reaction_scores',
    'parent_id',
    'reply_count',
    'show_in_channel',
    'command',
    'html',
    'created_at',
    'updated_at',
    'user',
  ];

  Message({
    this.id,
    this.text,
    this.type,
    this.attachments,
    this.mentionedUsers,
    this.reactionCounts,
    this.reactionScores,
    this.latestReactions,
    this.ownReactions,
    this.parentId,
    this.replyCount,
    this.showInChannel,
    this.command,
    this.html,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.extraData,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(Serialization.moveKeysToRoot(json, topLevelFields));

  Map<String, dynamic> toJson() =>
      Serialization.moveKeysToMapInPlace(_$MessageToJson(this), topLevelFields);
}
