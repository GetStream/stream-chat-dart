import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'read.g.dart';

@JsonSerializable()
class Read {
  final DateTime lastRead;
  final User user;

  Read({
    this.lastRead,
    this.user,
  });

  factory Read.fromJson(Map<String, dynamic> json) => _$ReadFromJson(json);
  Map<String, dynamic> toJson() => _$ReadToJson(this);
}
