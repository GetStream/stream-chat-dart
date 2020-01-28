import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat_dart/models/serialization.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  String id;

  @JsonKey(includeIfNull: false)
  Map<String, dynamic> extraData;

  static const topLevelFields = const [
    'id',
  ];

  User(this.id, this.extraData);

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(Serialization.moveKeysToRoot(json, topLevelFields));
  }

  Map<String, dynamic> toJson() {
    return Serialization.moveKeysToMapInPlace(
        _$UserToJson(this), topLevelFields);
  }
}
