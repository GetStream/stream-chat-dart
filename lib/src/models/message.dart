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
  final String type;
  final List<Attachment> attachments;
  final List<User> mentionedUsers;
  final Map<String, int> reactionCounts;
  final Map<String, int> reactionScores;
  final List<Reaction> latestReactions;
  final List<Reaction> ownReactions;
  final String parentId;
  final int replyCount;
  final bool showInChannel;
  final String command;
  final String html;
  final DateTime createdAt;
  final DateTime updatedAt;
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
