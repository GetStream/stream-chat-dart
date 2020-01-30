import 'package:json_annotation/json_annotation.dart';

import 'attachment.dart';
import 'reaction.dart';
import 'serialization.dart';
import 'user.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  String id;
  String text;
  String type;

  List<Attachment> attachments;
  List<User> mentionedUsers;
  Map<String, int> reactionCounts;
  Map<String, int> reactionScores;
  List<Reaction> latestReactions;
  List<Reaction> ownReactions;
  String parentId;
  int replyCount;
  bool showInChannel;
  String command;
  String html;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  @JsonKey(includeIfNull: false)
  Map<String, dynamic> extraData;

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

  Message(
      this.id,
      this.text,
      this.type,
      this.parentId,
      this.replyCount,
      this.showInChannel,
      this.command,
      this.html,
      this.createdAt,
      this.updatedAt,
      this.user);

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(Serialization.moveKeysToRoot(json, topLevelFields));

  Map<String, dynamic> toJson() =>
      Serialization.moveKeysToMapInPlace(_$MessageToJson(this), topLevelFields);
}
