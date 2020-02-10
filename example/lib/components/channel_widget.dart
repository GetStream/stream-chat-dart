import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';

import '../channel.bloc.dart';
import 'channel_header.dart';
import 'message_input.dart';
import 'message_widget.dart';

class ChannelWidget extends StatefulWidget {
  final PreferredSizeWidget _channelHeader;

  const ChannelWidget({
    Key key,
    @required PreferredSizeWidget channelHeader,
  })  : _channelHeader = channelHeader,
        super(key: key);

  @override
  _ChannelWidgetState createState() => _ChannelWidgetState();
}

class _ChannelWidgetState extends State<ChannelWidget> {
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final ItemScrollController _scrollController = ItemScrollController();
  bool isBottom = true;
  ItemPosition _lastBottomPosition;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChannelBloc>(
      builder: (context, channelBloc, _) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: widget._channelHeader,
          body: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder<List<Message>>(
                  stream: channelBloc.messages,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    final messages = snapshot.data.reversed.toList();
                    _handleScrollingOnNewMessage(channelBloc);
                    return ScrollablePositionedList.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: messages.length + 1,
                      itemPositionsListener: _itemPositionsListener,
                      itemScrollController: _scrollController,
                      reverse: true,
                      itemBuilder: (context, i) {
                        if (i == messages.length) {
                          return _buildLoadingIndicator(channelBloc);
                        } else {
                          final message = messages[i];
                          final previousMessage =
                              i < messages.length - 1 ? messages[i + 1] : null;
                          final nextMessage = i > 0 ? messages[i - 1] : null;
                          if (i == messages.length - 1) {
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
                            previousMessage: previousMessage,
                            message: message,
                            nextMessage: nextMessage,
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              MessageInput(
                onMessageSent: (_) {
                  _scrollController.scrollTo(
                    index: 0,
                    duration: Duration(milliseconds: 300),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleScrollingOnNewMessage(ChannelBloc channelBloc) {
    if (!channelBloc.readValue && !this.isBottom) {
      _scrollController.jumpTo(
          index: _lastBottomPosition.index + 1,
          alignment: _lastBottomPosition.itemLeadingEdge);
    }
  }

  VisibilityDetector _buildBottomMessage(
    ChannelBloc channelBloc,
    Message previousMessage,
    Message message,
    BuildContext context,
  ) {
    return VisibilityDetector(
      key: ValueKey<String>('bottom message'),
      onVisibilityChanged: (visibility) {
        this.isBottom = visibility.visibleBounds != Rect.zero;
        if (this.isBottom) {
          if (!channelBloc.readValue) {
            channelBloc.channelClient.markRead();
          }
        }
      },
      child: MessageWidget(
        previousMessage: previousMessage,
        message: message,
        nextMessage: null,
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

  VisibilityDetector _buildTopMessage(
    Message message,
    Message nextMessage,
    ChannelBloc channelBloc,
    BuildContext context,
  ) {
    return VisibilityDetector(
      child: MessageWidget(
        previousMessage: null,
        message: message,
        nextMessage: nextMessage,
      ),
      key: ValueKey<String>('top message'),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleBounds != Rect.zero) {
          channelBloc.queryMessages();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _itemPositionsListener.itemPositions.addListener(() {
      _lastBottomPosition = _itemPositionsListener.itemPositions.value.first;
    });
  }
}
