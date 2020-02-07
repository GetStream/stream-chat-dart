import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_example/chat.bloc.dart';

import '../channel.bloc.dart';
import 'channel_header.dart';

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
                          if (i == messages.length - 2) {
                            return _buildTopMessage(
                              message,
                              channelBloc,
                              context,
                            );
                          }
                          if (i == 0) {
                            return _buildBottomMessage(
                              channelBloc,
                              message,
                              context,
                            );
                          }
                          return _buildMessage(
                            message,
                            channelBloc,
                            context,
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              Material(
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Container(
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: TextField(
                                      onSubmitted: (_) {
                                        _sendMessage(context, channelBloc);
                                      },
                                      controller: _textController,
                                      decoration: InputDecoration(
                                        hintText: 'Type a message ..',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            _sendMessage(context, channelBloc);
                          },
                          child: CircleAvatar(
                            child: Icon(Icons.send),
                          ),
                        ),
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
    if (channelBloc.hasNewMessage != null && !this.isBottom) {
      _scrollController.jumpTo(
          index: _lastBottomPosition.index + 1,
          alignment: _lastBottomPosition.itemLeadingEdge);
    }
  }

  VisibilityDetector _buildBottomMessage(
    ChannelBloc channelBloc,
    Message message,
    BuildContext context,
  ) {
    return VisibilityDetector(
      key: ValueKey<String>('bottom message'),
      onVisibilityChanged: (visibility) {
        this.isBottom = visibility.visibleBounds != Rect.zero;
        if (this.isBottom) {
          if (channelBloc.hasNewMessage != null) {
            channelBloc.channelClient.markRead();
          }
        }
      },
      child: _buildMessage(
        message,
        channelBloc,
        context,
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
    ChannelBloc channelBloc,
    BuildContext context,
  ) {
    return VisibilityDetector(
      child: _buildMessage(
        message,
        channelBloc,
        context,
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
    _textController.clear();
    FocusScope.of(context).unfocus();
    channelBloc.channelClient.sendMessage(
      Message(text: text),
    );
  }

  Align _buildMessage(
    Message message,
    ChannelBloc channelBloc,
    BuildContext context,
  ) {
    final isMyMessage = message.user.id == channelBloc.chatBloc.user.id;
    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        color: isMyMessage
            ? Colors.lightGreen
            : Theme.of(context).primaryColorLight,
        margin: EdgeInsets.all(8),
        constraints: BoxConstraints(maxWidth: 300),
        child: ListTile(
          subtitle: Text(message.user.extraData['name'] ?? message.user.id),
          title: Text(message.text),
          dense: true,
        ),
      ),
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
