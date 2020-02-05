import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:provider/provider.dart';

import '../channel.bloc.dart';

class ChannelHeader extends StatelessWidget implements PreferredSizeWidget {
  ChannelHeader({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChannelBloc>(
      builder: (context, ChannelBloc channelBloc, _) =>
          StreamBuilder<ChannelState>(
              stream: channelBloc.channelState,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                final channelState = snapshot.data;
                return AppBar(
                  title: ListTile(
                    leading: Hero(
                      tag: channelState.channel.id,
                      child: CircleAvatar(
                        backgroundImage:
                            channelState.channel.extraData.containsKey('image')
                                ? NetworkImage(channelState
                                    .channel.extraData['image'] as String)
                                : null,
                        child:
                            channelState.channel.extraData.containsKey('image')
                                ? null
                                : Text(channelState.channel.config.name[0]),
                      ),
                    ),
                    title: Text(
                      channelState.channel.extraData['name'] as String ??
                          channelState.channel.config.name,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: StreamBuilder<bool>(
                      stream: channelBloc.typing,
                      initialData: false,
                      builder: (context, snapshot) {
                        return snapshot.data
                            ? Text(
                                'Typing...',
                                style: TextStyle(color: Colors.white),
                              )
                            : Container();
                      },
                    ),
                  ),
                );
              }),
    );
  }

  @override
  final Size preferredSize;
}
