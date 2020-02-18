/// This class defines some basic event types
class EventType {
  /// Indicates any type of events
  static const String any = "*";

  /// Event sent when a user starts typing a message
  static const String typingStart = "typing.start";

  /// Event sent when a user stops typing a message
  static const String typingStop = "typing.stop";
}
