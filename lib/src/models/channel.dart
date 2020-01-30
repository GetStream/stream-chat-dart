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
  final String cid;
  final ChannelConfig config;
  final User createdBy;
  final bool frozen;
  final DateTime lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;
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
