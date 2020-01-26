import 'package:flutter/widgets.dart';

import '../client.dart';

class StreamChatState {
  final Client client;
  StreamChatState(this.client);
}

class StreamChatContainer extends StatefulWidget {
  final StreamChatState state;
  final Widget child;

  StreamChatContainer({
    @required this.child,
    @required Client client,
  }) : state = StreamChatState(client);

  static StreamChatState of(BuildContext context) {
    final _InheritedStateContainer inheritedStateContainer = context.dependOnInheritedWidgetOfExactType<_InheritedStateContainer>();
    return inheritedStateContainer.data.state;
  }

  @override
  _StreamChatContainerState createState() => new _StreamChatContainerState();
}

class _StreamChatContainerState extends State<StreamChatContainer> {
  StreamChatState state;

  @override
  void initState() {
    state = widget.state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final _StreamChatContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}