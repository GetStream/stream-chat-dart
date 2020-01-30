import 'package:json_annotation/json_annotation.dart';

import 'serialization.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String id;

  @JsonKey(includeIfNull: false)
  final Map<String, dynamic> extraData;

  static const topLevelFields = [
    'id',
  ];

  User(this.id, [this.extraData]);

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(Serialization.moveKeysToRoot(json, topLevelFields));
  }

  Map<String, dynamic> toJson() {
    return Serialization.moveKeysToMapInPlace(
        _$UserToJson(this), topLevelFields);
  }
}
