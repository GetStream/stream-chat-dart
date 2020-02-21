import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:stream_chat/stream_chat.dart';

import '../stream_channel.dart';
import 'message_widget.dart';

typedef MessageBuilder = Widget Function(BuildContext, Message, int index);

class MessageListView extends StatefulWidget {
  final ScrollController scrollController;

  MessageListView({
    this.scrollController,
    Key key,
    MessageBuilder messageBuilder,
  })  : _messageBuilder = messageBuilder,
        super(key: key);

  final MessageBuilder _messageBuilder;

  @override
  _MessageListViewState createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  static const _newMessageLoadingOffset = 100;
  bool _isBottom = true;
  bool _topWasVisible = false;
  List<Message> _messages = [];
  List<Message> _newMessageList = [];

  @override
  Widget build(BuildContext context) {
    final streamChannel = StreamChannel.of(context);

    /// TODO: find a better solution when (https://github.com/flutter/flutter/issues/21023) is fixed
    return NotificationListener<ScrollNotification>(
      onNotification: (_) {
        if (widget.scrollController.offset < 150 &&
            _newMessageList.isNotEmpty) {
          setState(() {
            _messages.insert(0, _newMessageList.removeLast());
          });
        }
        return true;
      },
      child: ListView.custom(
        physics: AlwaysScrollableScrollPhysics(),
        controller: widget.scrollController,
        reverse: true,
        childrenDelegate: SliverChildBuilderDelegate(
          (context, i) {
            if (i == this._messages.length) {
              return _buildLoadingIndicator(streamChannel);
            }
            final message = this._messages[i];

            if (widget._messageBuilder != null) {
              return widget._messageBuilder(context, message, i);
            }

            final previousMessage =
                i < this._messages.length - 1 ? this._messages[i + 1] : null;
            final nextMessage = i > 0 ? this._messages[i - 1] : null;

            if (i == 0) {
              return _buildBottomMessage(
                streamChannel,
                previousMessage,
                message,
                context,
              );
            }

            if (i == this._messages.length - 1) {
              return _buildTopMessage(
                message,
                nextMessage,
                streamChannel,
                context,
              );
            }

            return MessageWidget(
              key: ValueKey<String>('MESSAGE-${message.id}'),
              previousMessage: previousMessage,
              message: message,
              nextMessage: nextMessage,
            );
          },
          childCount: this._messages.length + 1,
          findChildIndexCallback: (key) {
            final ValueKey<String> valueKey = key;
            final index = this
                ._messages
                .indexWhere((m) => 'MESSAGE-${m.id}' == valueKey.value);
            return index != -1 ? index : null;
          },
        ),
      ),
    );
  }

  Container _buildLoadingIndicator(StreamChannel channelBloc) {
    return Container(
      height: 100,
      child: StreamBuilder<bool>(
          stream: channelBloc.queryMessage,
          initialData: false,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print((snapshot.error as Error).stackTrace.toString());
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (!snapshot.data) {
              return Container();
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }),
    );
  }

  Widget _buildTopMessage(
    Message message,
    Message nextMessage,
    StreamChannel channelBloc,
    BuildContext context,
  ) {
    return VisibilityDetector(
      key: ValueKey<String>('TOP-MESSAGE'),
      child: MessageWidget(
        key: ValueKey<String>('MESSAGE-${message.id}'),
        previousMessage: null,
        message: message,
        nextMessage: nextMessage,
      ),
      onVisibilityChanged: (visibility) {
        final topIsVisible = visibility.visibleBounds != Rect.zero;
        if (topIsVisible && !_topWasVisible) {
          channelBloc.queryMessages();
        }
        _topWasVisible = topIsVisible;
      },
    );
  }

  Widget _buildBottomMessage(
    StreamChannel channelBloc,
    Message previousMessage,
    Message message,
    BuildContext context,
  ) {
    return VisibilityDetector(
      key: ValueKey<String>('BOTTOM-MESSAGE'),
      onVisibilityChanged: (visibility) {
        this._isBottom = visibility.visibleBounds != Rect.zero;
        if (this._isBottom) {
          if (channelBloc.channelClient.state.unreadCount > 0) {
            channelBloc.channelClient.markRead();
          }
        }
      },
      child: MessageWidget(
        key: ValueKey<String>('MESSAGE-${message.id}'),
        previousMessage: previousMessage,
        message: message,
        nextMessage: null,
      ),
    );
  }

  StreamSubscription _streamListener;

  @override
  void initState() {
    super.initState();

    final streamChannel = StreamChannel.of(context);
    if (streamChannel.channelClient.state.unreadCount > 0) {
      streamChannel.channelClient.markRead();
    }

    _streamListener = StreamChannel.of(context)
        .channelStateStream
        .map((c) => c.messages)
        .distinct()
        .listen((newMessages) {
      newMessages = newMessages.reversed.toList();
      if (_messages.isEmpty || newMessages.first.id != _messages.first.id) {
        if (!widget.scrollController.hasClients ||
            widget.scrollController.offset < _newMessageLoadingOffset) {
          setState(() {
            this._messages = newMessages;
          });
        } else if (newMessages.first.user.id ==
            StreamChannel.of(context).channelClient.client.user.id) {
          widget.scrollController.jumpTo(0);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              this._messages = newMessages;
            });
          });
        } else {
          _newMessageList =
              newMessages.toSet().difference(this._messages.toSet()).toList();
        }
      } else if (newMessages.last.id != _messages.last.id) {
        setState(() {
          this._messages = newMessages;
        });
      }
    });
  }

  @override
  void dispose() {
    _streamListener.cancel();
    super.dispose();
  }
}
