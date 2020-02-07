import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:provider/provider.dart';

import '../channel.bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

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
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  leading: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: RawMaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      elevation: 0,
                      highlightElevation: 0,
                      focusElevation: 0,
                      disabledElevation: 0,
                      hoverElevation: 0,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      fillColor: Colors.black.withOpacity(.1),
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: CircleAvatar(
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
                          ),
                          (channelState.members.isNotEmpty &&
                                  channelState.members.first.user.online)
                              ? Positioned(
                                  right: 0,
                                  top: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                    height: 8,
                                    width: 8,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                  centerTitle: true,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        channelState.channel.extraData['name'] as String ??
                            channelState.channel.config.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      (channelState.members.isNotEmpty &&
                              channelState.members.first.user.lastActive !=
                                  null)
                          ? Text(
                              'Active ${timeago.format(channelState.members.first.user.lastActive.toLocal())}',
                              style: TextStyle(
                                color: Colors.black.withOpacity(.5),
                                fontSize: 13,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                );
              }),
    );
  }

  @override
  final Size preferredSize;
}
