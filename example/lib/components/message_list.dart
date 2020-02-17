import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';

import '../channel.bloc.dart';
import 'message_widget.dart';

class MessageList extends StatefulWidget {
  final List<Message> messages;
  final ScrollController scrollController;

  MessageList(
    this.messages, {
    this.scrollController,
    Key key,
  }) : super(key: key);

  @override
  _MessageListState createState() => _MessageListState(messages);
}

class _MessageListState extends State<MessageList> {
  static const _newMessageLoadingOffset = 100;
  bool _isBottom = true;
  bool _topWasVisible = false;
  List<Message> _messages;
  List<Message> _newMessageList = [];

  _MessageListState(this._messages);

  @override
  Widget build(BuildContext context) {
    final channelBloc = Provider.of<ChannelBloc>(context);

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
              return _buildLoadingIndicator(channelBloc);
            }
            final message = this._messages[i];
            final previousMessage =
                i < this._messages.length - 1 ? this._messages[i + 1] : null;
            final nextMessage = i > 0 ? this._messages[i - 1] : null;

            if (i == 0) {
              return _buildBottomMessage(
                channelBloc,
                previousMessage,
                message,
                context,
              );
            }

            if (i == this._messages.length - 1) {
              return _buildTopMessage(
                message,
                nextMessage,
                channelBloc,
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

  Container _buildLoadingIndicator(ChannelBloc channelBloc) {
    return Container(
      height: 100,
      child: StreamBuilder<bool>(
          stream: channelBloc.queryMessage,
          initialData: false,
          builder: (context, snapshot) {
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
    ChannelBloc channelBloc,
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
    ChannelBloc channelBloc,
    Message previousMessage,
    Message message,
    BuildContext context,
  ) {
    return VisibilityDetector(
      key: ValueKey<String>('BOTTOM-MESSAGE'),
      onVisibilityChanged: (visibility) {
        this._isBottom = visibility.visibleBounds != Rect.zero;
        if (this._isBottom) {
          if (!channelBloc.readValue) {
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

  @override
  void didUpdateWidget(MessageList oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newMessages = this.widget.messages;

    if (newMessages[0].id != oldWidget.messages[0].id) {
      if (widget.scrollController.offset < _newMessageLoadingOffset) {
        this._messages = newMessages;
      } else {
        _newMessageList =
            newMessages.toSet().difference(this._messages.toSet()).toList();
        print('NEWME ${_newMessageList.length}');
      }
    } else if (newMessages.length != oldWidget.messages.length) {
      this._messages = newMessages;
    }
  }
}
