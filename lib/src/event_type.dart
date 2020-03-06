/// This class defines some basic event types
class EventType {
  /// Indicates any type of events
  static const String any = "*";

  /// Event sent when a user starts typing a message
  static const String typingStart = "typing.start";

  /// Event sent when a user stops typing a message
  static const String typingStop = "typing.stop";

  /// Event sent when receiving a new message
  static const String messageNew = "message.new";

  /// Event sent when deleting a new message
  static const String messageDeleted = "message.deleted";

  /// Event sent when receiving a new reaction
  static const String reactionNew = "reaction.new";

  /// Event sent when deleting a reaction
  static const String reactionDeleted = "reaction.deleted";

  /// Event sent when updating a message
  static const String messageUpdated = "message.updated";

  /// Event sent when reading a message
  static const String messageRead = "message.read";
}
