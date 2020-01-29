import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'event.g.dart';

@JsonSerializable(explicitToJson: true)
class Event {
  String type;
  String cid;

  @JsonKey(name: 'connection_id')
  String connectionID;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  Event(this.type, this.cid, this.createdAt, this.own);

  User own;

  User user;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
