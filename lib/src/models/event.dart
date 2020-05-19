import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/models/channel_model.dart';
import 'package:stream_chat/src/models/message.dart';
import 'package:stream_chat/src/models/serialization.dart';
import 'package:stream_chat/stream_chat.dart';

import '../event_type.dart';
import 'member.dart';
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

  /// The channel sent with the event
  final EventChannel channel;

  /// The member sent with the event
  final Member member;

  /// The reaction sent with the event
  final Reaction reaction;

  /// The number of unread messages for current user
  final int totalUnreadCount;

  /// User total unread channels
  final int unreadChannels;

  /// Online status
  final bool online;

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
    this.online,
    this.channel,
    this.member,
  });

  /// Create a new instance from a json
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$EventToJson(this);
}

@JsonSerializable()
class EventChannel extends ChannelModel {
  /// A paginated list of channel members
  final List<Member> members;

  /// Known top level fields.
  /// Useful for [Serialization] methods.
  static final topLevelFields = [
    'members',
    ...ChannelModel.topLevelFields,
  ];

  /// Constructor used for json serialization
  EventChannel({
    this.members,
    String id,
    String type,
    String cid,
    ChannelConfig config,
    User createdBy,
    bool frozen,
    DateTime lastMessageAt,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime deletedAt,
    int memberCount,
    Map<String, dynamic> extraData,
  }) : super(
          id: id,
          type: type,
          cid: cid,
          config: config,
          createdBy: createdBy,
          frozen: frozen,
          lastMessageAt: lastMessageAt,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
          memberCount: memberCount,
          extraData: extraData,
        );

  /// Create a new instance from a json
  factory EventChannel.fromJson(Map<String, dynamic> json) {
    return _$EventChannelFromJson(
        Serialization.moveKeysToRoot(json, topLevelFields));
  }
}
