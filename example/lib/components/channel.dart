import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';

import '../channel.bloc.dart';
import '../chat.bloc.dart';

class ChannelWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ChannelBloc, ChatBloc>(
      builder: (context, channelBloc, chatBloc, _) {
        return Scaffold(
          body: StreamBuilder<List<Message>>(
            stream: channelBloc.messages,
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  final message = snapshot.data[i];
                  return Align(
                    alignment: message.user.id == chatBloc.user.id
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      constraints: BoxConstraints(maxWidth: 300),
                      child: Text('${message.user.id} - ${message.text}'),
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
}
