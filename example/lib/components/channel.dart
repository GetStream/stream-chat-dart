import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';

import '../channel.bloc.dart';
import 'channel_header.dart';
import 'message_widget.dart';

class ChannelWidget extends StatefulWidget {
  @override
  _ChannelWidgetState createState() => _ChannelWidgetState();
}

class _ChannelWidgetState extends State<ChannelWidget> {
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final ItemScrollController _scrollController = ItemScrollController();
  final _textController = TextEditingController();
  bool isBottom = true;
  ItemPosition _lastBottomPosition;
  bool _messageIsPresent = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChannelBloc>(
      builder: (context, channelBloc, _) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: ChannelHeader(),
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
                            channelBloc: channelBloc,
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withAlpha(5),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.black.withOpacity(.2))),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          onSubmitted: (_) {
                            _sendMessage(context, channelBloc);
                          },
                          controller: _textController,
                          onChanged: (s) {
                            setState(() {
                              _messageIsPresent = s.isNotEmpty;
                            });
                          },
                          style: TextStyle(
                            color: Colors.black.withOpacity(.5),
                            fontSize: 15,
                          ),
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: 'Write a message',
                            prefixText: '   ',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      AnimatedCrossFade(
                        crossFadeState: _messageIsPresent
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstChild: IconButton(
                          onPressed: () {
                            _sendMessage(context, channelBloc);
                          },
                          icon: RawMaterialButton(
                            onPressed: () {
                              _sendMessage(context, channelBloc);
                            },
                            constraints: BoxConstraints.tightFor(
                              height: 40,
                              width: 40,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Icon(
                              Icons.send,
                              color: Color(0xff006bff),
                            ),
                          ),
                        ),
                        secondChild: Container(),
                        duration: Duration(milliseconds: 300),
                        firstCurve: Curves.ease,
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleScrollingOnNewMessage(ChannelBloc channelBloc) {
    if (channelBloc.newMessageValue != null && !this.isBottom) {
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
          if (channelBloc.newMessageValue != null) {
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

  void _sendMessage(BuildContext context, ChannelBloc channelBloc) {
    final text = _textController.text;
    if (text.trim().isEmpty) {
      return;
    }

    _textController.clear();
    setState(() {
      _messageIsPresent = false;
    });
    FocusScope.of(context).unfocus();
    channelBloc.channelClient
        .sendMessage(
      Message(text: text),
    )
        .then((_) {
      _scrollController.scrollTo(
        index: 0,
        duration: Duration(milliseconds: 300),
      );
    });
  }

  @override
  void initState() {
    super.initState();

    _itemPositionsListener.itemPositions.addListener(() {
      _lastBottomPosition = _itemPositionsListener.itemPositions.value.first;
    });
  }
}
