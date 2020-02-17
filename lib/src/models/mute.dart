import 'package:json_annotation/json_annotation.dart';

import 'serialization.dart';
import 'user.dart';

part 'mute.g.dart';

@JsonSerializable()
class Mute {
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final User user;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final User target;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime createdAt;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime updatedAt;

  Mute({this.user, this.target, this.createdAt, this.updatedAt});

  factory Mute.fromJson(Map<String, dynamic> json) => _$MuteFromJson(json);

  Map<String, dynamic> toJson() => _$MuteToJson(this);
}
