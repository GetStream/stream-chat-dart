import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/models/message.dart';

import '../event_type.dart';
import 'own_user.dart';
import 'reaction.dart';
import 'user.dart';

part 'event.g.dart';

/// The class that contains the information about an event
@JsonSerializable()
class Event {
  /// The type of the event
  /// [EventType] contains some predefined constant types
  final String type;

  /// The channel cid to which the event belongs
  final String cid;

  /// The connection id in which the event has been sent
  final String connectionId;

  /// The date of creation of the event
  final DateTime createdAt;

  /// User object of the health check user
  final OwnUser me;

  /// User object of the current user
  final User user;

  /// The message sent with the event
  final Message message;

  /// The reaction sent with the event
  final Reaction reaction;

  /// The number of unread messages for current user
  final int totalUnreadCount;

  /// User total unread channels
  final int unreadChannels;

  /// Constructor used for json serialization
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
    this.reaction,
  });

  /// Create a new instance from a json
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
