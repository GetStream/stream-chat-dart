import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'read.g.dart';

@JsonSerializable(explicitToJson: true)
class Read {
  @JsonKey(name: "last_read")
  DateTime lastRead;

  User user;
  Read(this.lastRead, this.user);

  factory Read.fromJson(Map<String, dynamic> json) => _$ReadFromJson(json);
  Map<String, dynamic> toJson() => _$ReadToJson(this);
}
