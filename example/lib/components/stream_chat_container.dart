import 'package:flutter/widgets.dart';
import 'package:stream_chat/stream_chat.dart';

class StreamChat extends InheritedWidget {
  final Widget child;
  final Client client;

  StreamChat({
    @required this.client,
    this.child,
  });

  static StreamChat of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StreamChat>();
  }

  @override
  bool updateShouldNotify(StreamChat oldWidget) {
    return this.client != oldWidget.client;
  }
}
