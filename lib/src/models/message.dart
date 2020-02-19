import 'package:json_annotation/json_annotation.dart';

import 'attachment.dart';
import 'reaction.dart';
import 'serialization.dart';
import 'user.dart';

part 'message.g.dart';

/// The class that contains the information about a message
@JsonSerializable()
class Message {
  /// The message ID. This is either created by Stream or set client side when the message is added.
  final String id;

  /// The text of this message
  final String text;

  /// The message type
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final String type;

  /// The list of attachments, either provided by the user or generated from a command or as a result of URL scraping.
  @JsonKey(includeIfNull: false)
  final List<Attachment> attachments;

  /// The list of user mentioned in the message
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final List<User> mentionedUsers;

  /// A map describing the count of number of every reaction
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final Map<String, int> reactionCounts;

  /// A map describing the count of score of every reaction
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final Map<String, int> reactionScores;

  /// The latest reactions to the message created by any user.
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final List<Reaction> latestReactions;

  /// The reactions added to the message by the current user.
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final List<Reaction> ownReactions;

  /// The ID of the parent message, if the message is a reply.
  final String parentId;

  /// Reserved field indicating the number of replies for this message.
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final int replyCount;

  /// Check if this message needs to show in the channel.
  final bool showInChannel;

  /// A used command name.
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final String command;

  /// Reserved field indicating when the message was created.
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime createdAt;

  /// Reserved field indicating when the message was updated last time.
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime updatedAt;

  /// User who sent the message
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final User user;

  /// Message custom extraData
  @JsonKey(includeIfNull: false)
  final Map<String, dynamic> extraData;

  /// Known top level fields.
  /// Useful for [Serialization] methods.
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
    'created_at',
    'updated_at',
    'user',
  ];

  /// Constructor used for json serialization
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
    this.createdAt,
    this.updatedAt,
    this.user,
    this.extraData,
  });

  /// Create a new instance from a json
  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(Serialization.moveKeysToRoot(json, topLevelFields));

  /// Serialize to json
  Map<String, dynamic> toJson() =>
      Serialization.moveKeysToMapInPlace(_$MessageToJson(this), topLevelFields);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          type == other.type &&
          attachments == other.attachments &&
          mentionedUsers == other.mentionedUsers &&
          reactionCounts == other.reactionCounts &&
          reactionScores == other.reactionScores &&
          latestReactions == other.latestReactions &&
          ownReactions == other.ownReactions &&
          parentId == other.parentId &&
          replyCount == other.replyCount &&
          showInChannel == other.showInChannel &&
          command == other.command &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          user == other.user &&
          extraData == other.extraData;

  @override
  int get hashCode =>
      id.hashCode ^
      text.hashCode ^
      type.hashCode ^
      attachments.hashCode ^
      mentionedUsers.hashCode ^
      reactionCounts.hashCode ^
      reactionScores.hashCode ^
      latestReactions.hashCode ^
      ownReactions.hashCode ^
      parentId.hashCode ^
      replyCount.hashCode ^
      showInChannel.hashCode ^
      command.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      user.hashCode ^
      extraData.hashCode;
}
