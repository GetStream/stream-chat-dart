import 'package:json_annotation/json_annotation.dart';

import 'attachment.dart';
import 'reaction.dart';
import 'serialization.dart';
import 'user.dart';

part 'message.g.dart';

/// Enum defining the status of a sending message
enum MessageSendingStatus {
  /// Message is being sent
  SENDING,

  /// Message is being updated
  UPDATING,

  /// Message is being deleted
  DELETING,

  /// Message failed to send
  FAILED,

  /// Message failed to updated
  FAILED_UPDATE,

  /// Message failed to delete
  FAILED_DELETE,

  /// Message correctly sent
  SENT,
}

/// The class that contains the information about a message
@JsonSerializable()
class Message {
  /// The message ID. This is either created by Stream or set client side when the message is added.
  final String id;

  /// The text of this message
  final String text;

  /// The status of a sending message
  @JsonKey(ignore: true)
  final MessageSendingStatus status;

  /// The message type
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final String type;

  /// The list of attachments, either provided by the user or generated from a command or as a result of URL scraping.
  @JsonKey(includeIfNull: false)
  final List<Attachment> attachments;

  /// The list of user mentioned in the message
  @JsonKey(toJson: Serialization.userIds)
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

  /// A quoted reply message
  @JsonKey(toJson: Serialization.readOnly)
  final Message quotedMessage;

  /// The ID of the quoted message, if the message is a quoted reply.
  final String quotedMessageId;

  /// Reserved field indicating the number of replies for this message.
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final int replyCount;

  /// Reserved field indicating the thread participants for this message.
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final List<User> threadParticipants;

  /// Check if this message needs to show in the channel.
  final bool showInChannel;

  /// If true the message is silent
  final bool silent;

  /// If true the message is shadowed
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final bool shadowed;

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

  /// True if the message is a system info
  bool get isSystem => type == 'system';

  /// True if the message has been deleted
  bool get isDeleted => type == 'deleted';

  /// True if the message is ephemeral
  bool get isEphemeral => type == 'ephemeral';

  /// Reserved field indicating when the message was deleted.
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime deletedAt;

  /// Known top level fields.
  /// Useful for [Serialization] methods.
  static const topLevelFields = [
    'id',
    'text',
    'type',
    'silent',
    'attachments',
    'latest_reactions',
    'shadowed',
    'own_reactions',
    'mentioned_users',
    'reaction_counts',
    'reaction_scores',
    'silent',
    'parent_id',
    'quoted_message',
    'quoted_message_id',
    'reply_count',
    'thread_participants',
    'show_in_channel',
    'command',
    'created_at',
    'updated_at',
    'deleted_at',
    'user',
  ];

  /// Constructor used for json serialization
  Message({
    this.id,
    this.text,
    this.type,
    this.attachments,
    this.mentionedUsers,
    this.silent,
    this.shadowed,
    this.reactionCounts,
    this.reactionScores,
    this.latestReactions,
    this.ownReactions,
    this.parentId,
    this.quotedMessage,
    this.quotedMessageId,
    this.replyCount = 0,
    this.threadParticipants,
    this.showInChannel,
    this.command,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.extraData,
    this.deletedAt,
    this.status = MessageSendingStatus.SENT,
  });

  /// Create a new instance from a json
  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(
      Serialization.moveToExtraDataFromRoot(json, topLevelFields));

  /// Serialize to json
  Map<String, dynamic> toJson() => Serialization.moveFromExtraDataToRoot(
      _$MessageToJson(this), topLevelFields);

  /// Creates a copy of [Message] with specified attributes overridden.
  Message copyWith({
    String id,
    String text,
    String type,
    List<Attachment> attachments,
    List<User> mentionedUsers,
    Map<String, int> reactionCounts,
    Map<String, int> reactionScores,
    List<Reaction> latestReactions,
    List<Reaction> ownReactions,
    String parentId,
    Message quotedMessage,
    String quotedMessageId,
    int replyCount,
    List<User> threadParticipants,
    bool showInChannel,
    bool shadowed,
    bool silent,
    String command,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime deletedAt,
    User user,
    Map<String, dynamic> extraData,
    MessageSendingStatus status,
  }) =>
      Message(
        id: id ?? this.id,
        text: text ?? this.text,
        type: type ?? this.type,
        attachments: attachments ?? this.attachments,
        mentionedUsers: mentionedUsers ?? this.mentionedUsers,
        reactionCounts: reactionCounts ?? this.reactionCounts,
        reactionScores: reactionScores ?? this.reactionScores,
        latestReactions: latestReactions ?? this.latestReactions,
        ownReactions: ownReactions ?? this.ownReactions,
        parentId: parentId ?? this.parentId,
        quotedMessage: quotedMessage ?? this.quotedMessage,
        quotedMessageId: quotedMessageId ?? this.quotedMessageId,
        replyCount: replyCount ?? this.replyCount,
        threadParticipants: threadParticipants ?? this.threadParticipants,
        showInChannel: showInChannel ?? this.showInChannel,
        command: command ?? this.command,
        createdAt: createdAt ?? this.createdAt,
        silent: silent ?? this.silent,
        extraData: extraData ?? this.extraData,
        user: user ?? this.user,
        shadowed: shadowed ?? this.shadowed,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        status: status ?? this.status,
      );
}

/// A translated message
/// It has an additional property called [i18n]
@JsonSerializable()
class TranslatedMessage extends Message {
  /// Constructor used for json serialization
  TranslatedMessage(this.i18n);

  /// A Map of
  final Map<String, String> i18n;

  /// Known top level fields.
  /// Useful for [Serialization] methods.
  static final topLevelFields = [
    'i18n',
    ...Message.topLevelFields,
  ];

  /// Create a new instance from a json
  factory TranslatedMessage.fromJson(Map<String, dynamic> json) {
    return _$TranslatedMessageFromJson(
      Serialization.moveToExtraDataFromRoot(json, topLevelFields),
    );
  }
}
