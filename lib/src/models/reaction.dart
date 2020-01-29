import 'package:json_annotation/json_annotation.dart';

import 'serialization.dart';
import 'user.dart';

part 'reaction.g.dart';

@JsonSerializable(explicitToJson: true)
class Reaction {
  @JsonKey(name: 'message_id')
  String messageID;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  String type;
  User user;
  int score;

  @JsonKey(name: 'user_id')
  String userID;

  @JsonKey(includeIfNull: false)
  Map<String, dynamic> extraData;

  static const topLevelFields = [
    'message_id',
    'created_at',
    'type',
    'user',
    'user_id',
    'score',
  ];

  Reaction(this.messageID, this.createdAt, this.type, this.user, this.userID);

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return _$ReactionFromJson(
        Serialization.moveKeysToRoot(json, topLevelFields));
  }

  Map<String, dynamic> toJson() {
    return Serialization.moveKeysToMapInPlace(
        _$ReactionToJson(this), topLevelFields);
  }
}
