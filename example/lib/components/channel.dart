import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';

import '../channel.bloc.dart';
import 'channel_header.dart';

class ChannelWidget extends StatefulWidget {
  @override
  _ChannelWidgetState createState() => _ChannelWidgetState();
}

class _ChannelWidgetState extends State<ChannelWidget> {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();

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
                  initialData: [],
                  builder: (context, snapshot) {
                    final messages = snapshot.data.reversed.toList();
                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: messages.length + 1,
                      itemBuilder: (context, i) {
                        print(
                            'context.findRenderObject().paintBounds.height: ${context.findRenderObject().paintBounds.height}');
                        if (i < messages.length) {
                          final message = messages[i];
                          return _buildMessage(message, channelBloc, context);
                        } else {
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
                                        _sendMessage(channelBloc);
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
                            _sendMessage(channelBloc);
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

  void _sendMessage(ChannelBloc channelBloc) {
    channelBloc.channelClient
        .sendMessage(
      Message(text: _textController.text),
    )
        .then((_) {
      _textController.clear();
    });
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

    final ChannelBloc channelBloc =
        Provider.of<ChannelBloc>(context, listen: false);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        channelBloc.queryMessages();
      } else if (_scrollController.offset == 0) {
        channelBloc.newMessage.first.then((b) {
          if (b != null) {
            channelBloc.channelClient.markRead();
          }
        });
      }
    });

    channelBloc.newMessage.first.then((b) {
      if (b != null) {
        channelBloc.channelClient.markRead();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
