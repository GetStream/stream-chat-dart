import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  final String type;
  final String cid;
  final String connectionId;
  final DateTime createdAt;
  final User own;
  final User user;

  Event({
    this.type,
    this.cid,
    this.connectionId,
    this.createdAt,
    this.own,
    this.user,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
