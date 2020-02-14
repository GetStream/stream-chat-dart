import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';

import '../channel.bloc.dart';
import 'message_widget.dart';

class MessageList extends StatefulWidget {
  final List<Message> messages;
  final ItemScrollController scrollController;

  MessageList(
    this.messages, {
    this.scrollController,
    Key key,
  }) : super(key: key);

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final ItemScrollController _scrollController = ItemScrollController();

  bool isBottom = true;
  ItemPosition _lastBottomPosition;
  bool _topWasVisible = false;
  int _lastMessageCount = 0;

  @override
  Widget build(BuildContext context) {
    final channelBloc = Provider.of<ChannelBloc>(context);
    _handleScrollingOnNewMessage(channelBloc, widget.messages.length);
    _lastMessageCount = widget.messages.length;
    return ScrollablePositionedList.builder(
      key: ValueKey<String>('LIST-${channelBloc.channelState.channel.id}'),
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: widget.messages.length + 1,
      itemPositionsListener: _itemPositionsListener,
      itemScrollController: _scrollController,
      reverse: true,
      itemBuilder: (context, i) {
        if (i == widget.messages.length) {
          return _buildLoadingIndicator(channelBloc);
        } else {
          final message = widget.messages[i];
          final previousMessage =
              i < widget.messages.length - 1 ? widget.messages[i + 1] : null;
          final nextMessage = i > 0 ? widget.messages[i - 1] : null;
          if (i == widget.messages.length - 1) {
            return _buildTopMessage(
              message,
              nextMessage,
              channelBloc,
              context,
            );
          }
          if (i == 0) {
            return _buildBottomMessage(
              channelBloc,
              previousMessage,
              message,
              context,
            );
          }
          return MessageWidget(
            key: ValueKey<String>('MESSAGE-${message.id}'),
            previousMessage: previousMessage,
            message: message,
            nextMessage: nextMessage,
          );
        }
      },
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
      child: MessageWidget(
        key: ValueKey<String>('MESSAGE-${message.id}'),
        previousMessage: null,
        message: message,
        nextMessage: nextMessage,
      ),
      key: ValueKey<String>('MESSAGE-${message.id}'),
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
      key: ValueKey<String>('MESSAGE-${message.id}'),
      onVisibilityChanged: (visibility) {
        this.isBottom = visibility.visibleBounds != Rect.zero;
        if (this.isBottom) {
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

  void _handleScrollingOnNewMessage(ChannelBloc channelBloc, int messageCount) {
    if (!channelBloc.readValue &&
        !this.isBottom &&
        messageCount > _lastMessageCount) {
      _scrollController.jumpTo(
          index: _lastBottomPosition.index + 1,
          alignment: _lastBottomPosition.itemLeadingEdge);
    }
  }

  @override
  void initState() {
    super.initState();

    _itemPositionsListener.itemPositions.addListener(() {
      _lastBottomPosition = _itemPositionsListener.itemPositions.value.first;
    });
  }
}
