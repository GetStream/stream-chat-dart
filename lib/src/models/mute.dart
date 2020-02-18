import 'package:json_annotation/json_annotation.dart';

import 'serialization.dart';
import 'user.dart';

part 'mute.g.dart';

/// The class that contains the information about a muted user
@JsonSerializable()
class Mute {
  /// The user that performed the muting action
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final User user;

  /// The target user
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final User target;

  /// The date in which the use was muted
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime createdAt;

  /// The date of the last update
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime updatedAt;

  /// Constructor used for json serialization
  Mute({this.user, this.target, this.createdAt, this.updatedAt});

  /// Create a new instance from a json
  factory Mute.fromJson(Map<String, dynamic> json) => _$MuteFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$MuteToJson(this);
}
