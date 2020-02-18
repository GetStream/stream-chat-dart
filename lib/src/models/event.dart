import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/models/message.dart';

import 'own_user.dart';
import 'user.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  final String type;
  final String cid;
  final String connectionId;
  final DateTime createdAt;
  final OwnUser me;
  final User user;
  final Message message;
  final int totalUnreadCount;
  final int unreadChannels;

  Event({
    this.type,
    this.cid,
    this.connectionId,
    this.createdAt,
    this.me,
    this.user,
    this.message,
    this.totalUnreadCount,
    this.unreadChannels,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
