import 'package:flutter/material.dart';
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
  double scrollPosition = 0;
  double maxScroll = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChannelBloc>(
      builder: (context, channelBloc, _) {
        return Scaffold(
          appBar: ChannelHeader(),
          body: StreamBuilder<List<Message>>(
            stream: channelBloc.messages,
            initialData: [],
            builder: (context, snapshot) {
              final messages = snapshot.data.reversed.toList();
              if (scrollPosition != 0) {
                Future.microtask(() {
                  final diff =
                      _scrollController.position.maxScrollExtent - maxScroll;
                  print('diff: ${diff}');
                  _scrollController.jumpTo(scrollPosition + diff);
                });
              }
              return ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, i) {
                  final message = messages[i];
                  final isMyMessage =
                      message.user.id == channelBloc.chatBloc.user.id;
                  return Align(
                    alignment: isMyMessage
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      color: isMyMessage
                          ? Colors.lightGreen
                          : Theme.of(context).primaryColorLight,
                      margin: EdgeInsets.all(8),
                      constraints: BoxConstraints(maxWidth: 300),
                      child: ListTile(
                        subtitle: Text(
                            message.user.extraData['name'] ?? message.user.id),
                        title: Text(message.text),
                        dense: true,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    final ChannelBloc channelBloc =
        Provider.of<ChannelBloc>(context, listen: false);

    _scrollController.addListener(() {
      maxScroll = _scrollController.position.maxScrollExtent;
      scrollPosition = _scrollController.offset;
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        channelBloc.queryMessages();
      }
    });

    channelBloc.newMessage.first.then((b) {
      if (b) {
        channelBloc.channelClient.markRead();
      }
    });
  }
}
