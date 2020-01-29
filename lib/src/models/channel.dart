import 'package:json_annotation/json_annotation.dart';

import 'channel_config.dart';
import 'member.dart';
import 'serialization.dart';
import 'user.dart';

part 'channel.g.dart';

@JsonSerializable(explicitToJson: true)
class Channel {
  String id;
  String type;
  String cid;
  ChannelConfig config;

  @JsonKey(name: 'created_by')
  User createdBy;

  bool frozen;

  @JsonKey(name: 'last_message_at')
  DateTime lastMessageAt;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  @JsonKey(name: 'deleted_at')
  DateTime deletedAt;

  @JsonKey(name: 'member_count')
  int memberCount;

  List<Member> members;

  @JsonKey(includeIfNull: false)
  Map<String, dynamic> extraData;

  static const topLevelFields = const [
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
