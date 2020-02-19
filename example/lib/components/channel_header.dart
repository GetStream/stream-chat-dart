import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_example/components/channel_name_text.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../channel.bloc.dart';
import 'channel_image.dart';

class ChannelHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;

  ChannelHeader({
    Key key,
    this.showBackButton = true,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final channelBloc = InheritedChannelBloc.of(context).channelBloc;
    final channelState = channelBloc.channelState;
    return AppBar(
      leading: showBackButton ? _buildBackButton(context) : Container(),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Stack(
            children: <Widget>[
              Center(child: ChannelImage(channel: channelState.channel)),
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
          ChannelNameText(
            channel: channelState.channel,
          ),
          _buildLastActive(context, channelState),
        ],
      ),
    );
  }

  StatelessWidget _buildLastActive(
      BuildContext context, ChannelState channelState) {
    return (channelState.channel.lastMessageAt != null)
        ? Text(
            'Active ${timeago.format(channelState.channel.lastMessageAt)}',
            style: Theme.of(context).textTheme.caption,
          )
        : Container();
  }

  Padding _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: RawMaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
    );
  }

  @override
  final Size preferredSize;
}
