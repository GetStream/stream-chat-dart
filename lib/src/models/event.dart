import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/models/message.dart';

import 'own_user.dart';
import 'user.dart';
import '../event_type.dart';

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

  /// The date of creation of the channel
  final DateTime createdAt;

  /// The updated current user information
  final OwnUser me;

  /// The information about the user involved in the event
  final User user;

  /// The message sent with the event
  final Message message;

  /// User total unread messages
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
  });

  /// Create a new instance from a json
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
