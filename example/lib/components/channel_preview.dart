import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_example/chat.bloc.dart';
import 'package:stream_chat_example/components/channel.dart';

import '../channel.bloc.dart';

class ChannelPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChannelBloc>(
      builder: (context, channelBloc, _) => StreamBuilder<ChannelState>(
          stream: channelBloc.channelState,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final channelState = snapshot.data;
            return StreamBuilder<bool>(
                stream: channelBloc.newMessage,
                initialData: false,
                builder: (context, snapshot) {
                  final newMessage = snapshot.data;
                  final textStyle = TextStyle(
                      fontWeight:
                          newMessage ? FontWeight.bold : FontWeight.normal);
                  return ListTile(
                    title: Text(
                      channelState.channel.extraData['name'] as String ??
                          channelState.channel.config.name,
                      style: textStyle,
                    ),
                    isThreeLine: true,
                    subtitle: StreamBuilder<bool>(
                        stream: channelBloc.typing,
                        initialData: false,
                        builder: (context, snapshot) {
                          final typing = snapshot.data;
                          return Text(
                            typing
                                ? 'Typing...'
                                : channelState.messages?.last?.text ?? '',
                            maxLines: 2,
                            style: textStyle,
                            overflow: TextOverflow.ellipsis,
                          );
                        }),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return MultiProvider(
                              providers: [
                                ChangeNotifierProvider.value(
                                    value: channelBloc),
                                ChangeNotifierProvider.value(
                                    value: Provider.of<ChatBloc>(context)),
                              ],
                              child: ChannelWidget(),
                            );
                          },
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundImage: channelState.channel.extraData
                              .containsKey('image')
                          ? NetworkImage(
                              channelState.channel.extraData['image'] as String)
                          : null,
                      child: channelState.channel.extraData.containsKey('image')
                          ? null
                          : Text(channelState.channel.config.name[0]),
                    ),
                  );
                });
          }),
    );
  }
}
