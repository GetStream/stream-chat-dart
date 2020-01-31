import 'package:json_annotation/json_annotation.dart';

import 'serialization.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final String role;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime createdAt;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime updatedAt;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime lastActive;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final bool online;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final bool banned;

  @JsonKey(includeIfNull: false)
  final Map<String, dynamic> extraData;

  static const topLevelFields = [
    'id',
    'role',
    'created_at',
    'updated_at',
    'last_active',
    'online',
    'banned',
  ];

  User.init(this.id, {this.online = null, this.extraData})
      : this.createdAt = null,
        this.updatedAt = null,
        this.lastActive = null,
        this.banned = null,
        this.role = null;

  User({
    this.id,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.lastActive,
    this.online,
    this.extraData,
    this.banned,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(Serialization.moveKeysToRoot(json, topLevelFields));
  }

  Map<String, dynamic> toJson() {
    return Serialization.moveKeysToMapInPlace(
        _$UserToJson(this), topLevelFields);
  }
}
