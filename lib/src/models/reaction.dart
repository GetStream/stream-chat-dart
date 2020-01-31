import 'package:json_annotation/json_annotation.dart';

import 'serialization.dart';
import 'user.dart';

part 'reaction.g.dart';

@JsonSerializable()
class Reaction {
  final String messageId;
  final String type;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime createdAt;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final User user;

  final int score;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final String userId;

  @JsonKey(includeIfNull: false)
  final Map<String, dynamic> extraData;

  static const topLevelFields = [
    'message_id',
    'created_at',
    'type',
    'user',
    'user_id',
    'score',
  ];

  Reaction({
    this.messageId,
    this.createdAt,
    this.type,
    this.user,
    this.userId,
    this.score,
    this.extraData,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return _$ReactionFromJson(
        Serialization.moveKeysToRoot(json, topLevelFields));
  }

  Map<String, dynamic> toJson() {
    return Serialization.moveKeysToMapInPlace(
        _$ReactionToJson(this), topLevelFields);
  }
}
