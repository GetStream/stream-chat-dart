import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_example/components/channel.dart';

import '../channel.bloc.dart';

class ChannelPreview extends StatefulWidget {
  @override
  _ChannelPreviewState createState() => _ChannelPreviewState();
}

class _ChannelPreviewState extends State<ChannelPreview>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ChannelBloc>(
      builder: (context, channelBloc, _) => StreamBuilder<ChannelState>(
          stream: channelBloc.channelState,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final channelState = snapshot.data;
            return StreamBuilder<Event>(
                stream: channelBloc.newMessage
                    .where((e) => e.user.id != channelBloc.chatBloc.user.id),
                builder: (context, snapshot) {
                  final newMessage = snapshot.data;
                  return Material(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ChangeNotifierProvider.value(
                                value: channelBloc,
                                child: ChannelWidget(),
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 60,
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: channelState.channel.extraData
                                      .containsKey('image')
                                  ? NetworkImage(channelState
                                      .channel.extraData['image'] as String)
                                  : null,
                              child: channelState.channel.extraData
                                      .containsKey('image')
                                  ? null
                                  : Text(channelState.channel.config.name[0]),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      channelState.channel.extraData['name']
                                              as String ??
                                          channelState.channel.config.name,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    StreamBuilder<bool>(
                                        stream: channelBloc.typing,
                                        initialData: false,
                                        builder: (context, snapshot) {
                                          final typing = snapshot.data;
                                          return Text(
                                            typing
                                                ? 'Typing...'
                                                : channelState
                                                        .messages?.last?.text ??
                                                    '',
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.black.withOpacity(
                                                  newMessage != null ? 1 : 0.5),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '12/12/2020',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
