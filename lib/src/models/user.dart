import 'package:json_annotation/json_annotation.dart';

import 'serialization.dart';

part 'user.g.dart';

/// The class that defines the user model
@JsonSerializable()
class User {
  /// User id
  final String id;

  /// User role
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final String role;

  /// Date of user creation
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime createdAt;

  /// Date of last user update
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime updatedAt;

  /// Date of last user connection
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime lastActive;

  /// True if user is online
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final bool online;

  /// True if user is banned from the chat
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final bool banned;

  /// Map of custom user extraData
  @JsonKey(includeIfNull: false)
  final Map<String, dynamic> extraData;

  /// Known top level fields.
  /// Useful for [Serialization] methods.
  static const topLevelFields = [
    'id',
    'role',
    'created_at',
    'updated_at',
    'last_active',
    'online',
    'banned',
  ];

  /// Use this named constructor to create a new user instance
  User.init(
    this.id, {
    this.online,
    this.extraData,
  })  : this.createdAt = null,
        this.updatedAt = null,
        this.lastActive = null,
        this.banned = null,
        this.role = null;

  /// Constructor used for json serialization
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

  /// Create a new instance from a json
  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(Serialization.moveKeysToRoot(json, topLevelFields));
  }

  /// Serialize to json
  Map<String, dynamic> toJson() {
    return Serialization.moveKeysToMapInPlace(
        _$UserToJson(this), topLevelFields);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
