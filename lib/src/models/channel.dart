import 'package:json_annotation/json_annotation.dart';

import 'channel_config.dart';
import 'member.dart';
import 'serialization.dart';
import 'user.dart';

part 'channel.g.dart';

@JsonSerializable()
class Channel {
  final String id;
  final String type;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final String cid;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final ChannelConfig config;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final User createdBy;

  @JsonKey(includeIfNull: false)
  final bool frozen;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime lastMessageAt;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime createdAt;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime updatedAt;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime deletedAt;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final int memberCount;

  @JsonKey(includeIfNull: false)
  final List<Member> members;

  @JsonKey(includeIfNull: false)
  final Map<String, dynamic> extraData;

  static const topLevelFields = [
    'id',
    'type',
    'cid',
    'config',
    'created_by',
    'frozen',
    'last_message_at',
    'created_at',
    'updated_at',
    'deleted_at',
    'member_count',
    'members',
  ];

  Channel({
    this.id,
    this.type,
    this.cid,
    this.config,
    this.createdBy,
    this.frozen,
    this.lastMessageAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.memberCount,
    this.members,
    this.extraData,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return _$ChannelFromJson(
        Serialization.moveKeysToRoot(json, topLevelFields));
  }

  Map<String, dynamic> toJson() {
    return Serialization.moveKeysToMapInPlace(
      _$ChannelToJson(this),
      topLevelFields,
    );
  }
}
