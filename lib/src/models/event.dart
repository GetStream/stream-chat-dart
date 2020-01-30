import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  String type;
  String cid;
  String connectionId;
  DateTime createdAt;
  User own;
  User user;

  Event(this.type, this.cid, this.createdAt, this.own);

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
