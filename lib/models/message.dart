import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat_dart/models/serialization.dart';
import 'package:stream_chat_dart/models/user.dart';

part 'message.g.dart';

@JsonSerializable(explicitToJson: true)
class Message {
  String id;
  String text;
  String type;

  // TODO: attachments
  // TODO: latest_reactions
  // TODO: own_reactions
  // TODO: mentioned_users
  // TODO: reaction_counts

  @JsonKey(name: 'parent_id')
  String parentID;

  @JsonKey(name: 'reply_count')
  int replyCount;

  @JsonKey(name: 'show_in_channel')
  bool showInChannel;

  String command;
  String html;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  User user;

  @JsonKey(includeIfNull: false)
  Map<String, dynamic> extraData;

  static const topLevelFields = const [
    'id',
    'text',
    'type',
    'attachments',
    'latest_reactions',
    'own_reactions',
    'mentioned_users',
    'reaction_counts',
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
      this.parentID,
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
