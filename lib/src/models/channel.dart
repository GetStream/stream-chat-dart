import 'package:json_annotation/json_annotation.dart';

import 'channel_config.dart';
import 'member.dart';
import 'serialization.dart';
import 'user.dart';

part 'channel.g.dart';

@JsonSerializable(explicitToJson: true)
class Channel {
  final String id;
  final String type;
  final String cid;
  final ChannelConfig config;

  @JsonKey(name: 'created_by')
  final User createdBy;

  final bool frozen;

  @JsonKey(name: 'last_message_at')
  final DateTime lastMessageAt;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @JsonKey(name: 'deleted_at')
  final DateTime deletedAt;

  @JsonKey(name: 'member_count')
  final int memberCount;

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

  Channel(
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
  );

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
